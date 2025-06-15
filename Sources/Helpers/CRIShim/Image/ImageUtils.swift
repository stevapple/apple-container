import ContainerClient
import ContainerizationOCI


extension Runtime_V1_Image {
    init(from image: ClientImage) async throws {
        // 1. ID of the image.
        let denormalizedReference = try ClientImage.denormalizeReference(image.reference)
        let reference = try ContainerizationOCI.Reference.parse(denormalizedReference)
        self.id = reference.name

        // 2. Other names by which this image is known.
        if let tag = reference.tag {
            self.repoTags = [tag]
        }

        // 3. Digests by which this image is known.
        self.repoDigests = [image.descriptor.digest]

        // 4. Size of the image in bytes. Must be > 0.
        self.size = UInt64(image.descriptor.size)

        // 5+6. UID/User name that will run the command(s).
        for manifest in try await image.index().manifests {
            guard let platform = manifest.platform, platform ~= .current else {
                continue
            }
            let platformImage = try await image.config(for: platform)

            if let user = platformImage.config?.user {
                if let uid = Int64(user) {
                    // 5. UID that will run the command(s). This is used as a default if no user is
                    // specified when creating the container. UID and the following user name
                    // are mutually exclusive.
                    var runtimeUID = Runtime_V1_Int64Value()
                    runtimeUID.value = uid
                    self.uid = runtimeUID
                } else {
                    // 6. User name that will run the command(s). This is used if UID is not set
                    // and no user is specified when creating container.
                    self.username = user
                }
                break
            }
        }

        // 7. ImageSpec for image which includes annotations
        self.spec = Runtime_V1_ImageSpec()
        self.spec.image = try ClientImage.normalizeReference(image.reference)
        if let annotations = image.descriptor.annotations {
            self.spec.annotations = annotations
        }

        // 8. Recommendation on whether this image should be exempt from garbage collection.
        // It must only be treated as a recommendation -- the client can still request that the image be deleted,
        // and the runtime must oblige.
        self.pinned = false
    }
}
