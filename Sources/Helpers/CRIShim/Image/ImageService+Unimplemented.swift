import GRPC

extension ImageService {
    func pullImage(request: Runtime_V1_PullImageRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_PullImageResponse {
        return .init()
    }
    
    func removeImage(request: Runtime_V1_RemoveImageRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_RemoveImageResponse {
        return .init()
    }

    func imageFsInfo(request: Runtime_V1_ImageFsInfoRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_ImageFsInfoResponse {
        return .init()
    }
}
