import CVersion
import Foundation
import GRPC


extension RuntimeService {
    func version(request: Runtime_V1_VersionRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_VersionResponse {
        context.request.logger.debug("/runtime.v1.RuntimeService/Version called")

        var response = Runtime_V1_VersionResponse()
        response.runtimeName = "com.apple.container"
        response.runtimeVersion = RuntimeService.releaseVersion()
        response.runtimeApiVersion = "v1"
        response.version = "1.33.0"

        precondition(response.isInitialized, "Runtime_V1_VersionResponse is not initialized")
        return response
    }

    private static func releaseVersion() -> String {
        (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? get_release_version().map { String(cString: $0) } ?? "0.0.0"
    }
}
