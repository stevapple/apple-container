import ContainerClient
import GRPC


extension ImageService {
    func removeImage(request: Runtime_V1_RemoveImageRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_RemoveImageResponse {
        context.request.logger.debug("/runtime.v1.ImageService/RemoveImage called")

        let response = Runtime_V1_RemoveImageResponse()

        let image = try await ClientImage.get(reference: request.image.image)
        try await image.deleteSnapshot(platform: nil)

        precondition(response.isInitialized, "Runtime_V1_RemoveImageResponse not initialized")
        return response
    }
}
