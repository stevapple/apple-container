import ContainerClient
import GRPC


extension ImageService {
    func listImages(request: Runtime_V1_ListImagesRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_ListImagesResponse {
        context.request.logger.debug("/runtime.v1.ImageService/ListImages called")

        var response = Runtime_V1_ListImagesResponse()

        response.images = []
        for containerImage in try await ClientImage.list() {
            let image = try await Runtime_V1_Image(from: containerImage)
            response.images.append(image)
        }

        precondition(response.isInitialized, "Runtime_V1_ListImagesResponse not initialized")
        return response
    }
}
