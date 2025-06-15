import ContainerClient
import GRPC


extension ImageService {
    func pullImage(request: Runtime_V1_PullImageRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_PullImageResponse {
        context.request.logger.debug("/runtime.v1.ImageService/PullImage called")

        var response = Runtime_V1_PullImageResponse()

        let image = try await ClientImage.pull(reference: request.image.image)
        response.imageRef = image.descriptor.digest

        precondition(response.isInitialized, "Runtime_V1_PullImageResponse not initialized")
        return response
    }
}
