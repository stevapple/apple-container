import ContainerClient
import GRPC


extension ImageService {
    func imageStatus(request: Runtime_V1_ImageStatusRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_ImageStatusResponse {
        context.request.logger.debug("/runtime.v1.ImageService/ImageStatus called")

        var response = Runtime_V1_ImageStatusResponse()

        let containerImage = try await ClientImage.get(reference: request.image.image)
        response.image = try await Runtime_V1_Image(from: containerImage)

        if request.verbose {
            context.request.logger.warning("ImageStatusRequest.verbose is not supported")
        }

        precondition(response.isInitialized, "Runtime_V1_ImageStatusResponse not initialized")
        return response
    }
}
