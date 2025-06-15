import GRPC

extension ImageService {
    func imageFsInfo(request: Runtime_V1_ImageFsInfoRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_ImageFsInfoResponse {
        return .init()
    }
}
