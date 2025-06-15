import GRPC


extension RuntimeService {
    func podSandboxStats(request: Runtime_V1_PodSandboxStatsRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_PodSandboxStatsResponse {
        return .init()
    }

    func listPodSandboxStats(request: Runtime_V1_ListPodSandboxStatsRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_ListPodSandboxStatsResponse {
        return .init()
    }

    func checkpointContainer(request: Runtime_V1_CheckpointContainerRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_CheckpointContainerResponse {
        return .init()
    }

    func getContainerEvents(request: Runtime_V1_GetEventsRequest, responseStream: GRPCAsyncResponseStreamWriter<Runtime_V1_ContainerEventResponse>, context: GRPCAsyncServerCallContext) async throws {
        return
    }

    func listMetricDescriptors(request: Runtime_V1_ListMetricDescriptorsRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_ListMetricDescriptorsResponse {
        return .init()
    }

    func listPodSandboxMetrics(request: Runtime_V1_ListPodSandboxMetricsRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_ListPodSandboxMetricsResponse {
        return .init()
    }

    func runtimeConfig(request: Runtime_V1_RuntimeConfigRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_RuntimeConfigResponse {
        return .init()
    }

    func updatePodSandboxResources(request: Runtime_V1_UpdatePodSandboxResourcesRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_UpdatePodSandboxResourcesResponse {
        return .init()
    }

    func runPodSandbox(request: Runtime_V1_RunPodSandboxRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_RunPodSandboxResponse {
        return .init()
    }
    
    func stopPodSandbox(request: Runtime_V1_StopPodSandboxRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_StopPodSandboxResponse {
        return .init()
    }
    
    func removePodSandbox(request: Runtime_V1_RemovePodSandboxRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_RemovePodSandboxResponse {
        return .init()
    }
    
    func podSandboxStatus(request: Runtime_V1_PodSandboxStatusRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_PodSandboxStatusResponse {
        return .init()
    }
    
    func listPodSandbox(request: Runtime_V1_ListPodSandboxRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_ListPodSandboxResponse {
        return .init()
    }
    
    func createContainer(request: Runtime_V1_CreateContainerRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_CreateContainerResponse {
        return .init()
    }
    
    func startContainer(request: Runtime_V1_StartContainerRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_StartContainerResponse {
        return .init()
    }
    
    func stopContainer(request: Runtime_V1_StopContainerRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_StopContainerResponse {
        return .init()
    }
    
    func removeContainer(request: Runtime_V1_RemoveContainerRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_RemoveContainerResponse {
        return .init()
    }
    
    func listContainers(request: Runtime_V1_ListContainersRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_ListContainersResponse {
        return .init()
    }
    
    func containerStatus(request: Runtime_V1_ContainerStatusRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_ContainerStatusResponse {
        return .init()
    }
    
    func updateContainerResources(request: Runtime_V1_UpdateContainerResourcesRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_UpdateContainerResourcesResponse {
        return .init()
    }
    
    func reopenContainerLog(request: Runtime_V1_ReopenContainerLogRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_ReopenContainerLogResponse {
        return .init()
    }
    
    func execSync(request: Runtime_V1_ExecSyncRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_ExecSyncResponse {
        return .init()
    }
    
    func exec(request: Runtime_V1_ExecRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_ExecResponse {
        return .init()
    }
    
    func attach(request: Runtime_V1_AttachRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_AttachResponse {
        return .init()
    }
    
    func portForward(request: Runtime_V1_PortForwardRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_PortForwardResponse {
        return .init()
    }
    
    func containerStats(request: Runtime_V1_ContainerStatsRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_ContainerStatsResponse {
        return .init()
    }
    
    func listContainerStats(request: Runtime_V1_ListContainerStatsRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_ListContainerStatsResponse {
        return .init()
    }
    
    func updateRuntimeConfig(request: Runtime_V1_UpdateRuntimeConfigRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_UpdateRuntimeConfigResponse {
        return .init()
    }
    
    func status(request: Runtime_V1_StatusRequest, context: GRPCAsyncServerCallContext) async throws -> Runtime_V1_StatusResponse {
        return .init()
    }
}
