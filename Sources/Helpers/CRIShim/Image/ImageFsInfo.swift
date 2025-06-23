import GRPC


extension ImageService {
    func imageFsInfo(request: Runtime_V1_ImageFsInfoRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_ImageFsInfoResponse {
        context.request.logger.debug("/runtime.v1.ImageService/ImageFsInfo called")

        var response = Runtime_V1_ImageFsInfoResponse()

        if let imageFileSystem = try Runtime_V1_FilesystemUsage(url: self.root.appending(component: "content")) {
            response.imageFilesystems = [imageFileSystem]
        }

        if let containerFileSystem = try Runtime_V1_FilesystemUsage(url: self.root.appending(component: "containers")) {
            response.containerFilesystems = [containerFileSystem]
        }

        precondition(response.isInitialized, "Runtime_V1_ListImagesResponse not initialized")
        return response
    }
}
