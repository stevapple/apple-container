import ContainerClient
import ContainerizationOCI
import GRPC


extension ImageService {
    func listImages(request: Runtime_V1_ListImagesRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_ListImagesResponse {
        context.request.logger.debug("/runtime.v1.ImageService/ListImages called")

        var response = Runtime_V1_ListImagesResponse()
        response.images = []

        for containerImage in try await ClientImage.list() {
            var image = Runtime_V1_Image()

            // 1. ID of the image.
            let denormalizedReference = try ClientImage.denormalizeReference(containerImage.reference)
            let reference = try ContainerizationOCI.Reference.parse(denormalizedReference)
            image.id = reference.name

            // 2. Other names by which this image is known.
            if let tag = reference.tag {
                image.repoTags = [tag]
            }

            // 3. Digests by which this image is known.
            image.repoDigests = [containerImage.descriptor.digest]

            // 4. Size of the image in bytes. Must be > 0.
            image.size = UInt64(containerImage.descriptor.size)

            // 5+6. UID/User name that will run the command(s).
            let imageDetails = try await containerImage.details()
            if let imageDetailsForCurrentPlatform = imageDetails.variants.first(where: { $0.platform ~= .current }) {
                if let user = imageDetailsForCurrentPlatform.config.config?.user {
                    if let uid = Int64(user) {
                        // 5. UID that will run the command(s). This is used as a default if no user is
                        // specified when creating the container. UID and the following user name
                        // are mutually exclusive.
                        var runtimeUID = Runtime_V1_Int64Value()
                        runtimeUID.value = uid
                        image.uid = runtimeUID
                    } else {
                        // 6. User name that will run the command(s). This is used if UID is not set
                        // and no user is specified when creating container.
                        image.username = user
                    }
                }
            }

            // 7. ImageSpec for image which includes annotations
            image.spec = Runtime_V1_ImageSpec()
            image.spec.image = try ClientImage.normalizeReference(containerImage.reference)
            if let annotations = imageDetails.index.annotations {
                image.spec.annotations = annotations
            }

            // 8. Recommendation on whether this image should be exempt from garbage collection.
            // It must only be treated as a recommendation -- the client can still request that the image be deleted,
            // and the runtime must oblige.
            image.pinned = false

            response.images.append(image)
        }

        precondition(response.isInitialized, "Runtime_V1_ListImagesResponse not initialized")
        return response
    }
}
