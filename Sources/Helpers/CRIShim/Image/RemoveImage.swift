import ContainerClient
import GRPC


extension ImageService {
    func removeImage(request: Runtime_V1_RemoveImageRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_RemoveImageResponse {
        context.request.logger.debug("/runtime.v1.ImageService/RemoveImage called")

        let response = Runtime_V1_RemoveImageResponse()

        try await ClientImage.delete(reference: request.image.image)

        precondition(response.isInitialized, "Runtime_V1_RemoveImageResponse not initialized")
        return response
    }
}
