//===----------------------------------------------------------------------===//
// Copyright © 2025 Apple Inc. and the container project authors. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//===----------------------------------------------------------------------===//

import ArgumentParser
import CVersion
import ContainerLog
import Foundation
import GRPC
import Logging

@main
struct CRIShimHelper: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "container-cri-shim",
        abstract: "gRPC shim for interacting with kubelet using CRI",
        version: releaseVersion(),
        subcommands: [
            Start.self
        ]
    )
}

extension CRIShimHelper {
    struct Start: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "start",
            abstract: "Starts the CRI shim plugin"
        )

        @Flag(name: .long, help: "Enable debug logging")
        var debug = false

        @Option(name: .long, help: "XPC service prefix")
        var serviceIdentifier: String = "com.apple.container.shim.container-cri-shim"

        @Option(name: .shortAndLong, help: "UNIX domain socket path")
        var socketPath = Self.appRoot.appending(component: "container.sock").path(percentEncoded: false)

        static let appRoot: URL = {
            FileManager.default.urls(
                for: .applicationSupportDirectory,
                in: .userDomainMask
            ).first!
            .appendingPathComponent("com.apple.container")
        }()

        func run() async throws {
            let commandName = CRIShimHelper._commandName
            let log = setupLogger()
            log.info("starting \(commandName)")
            defer {
                log.info("stopping \(commandName)")
            }
            do {
                log.info("configuring gRPC server")

                let grpc = GRPC.Server
                    .insecure(group: .singletonMultiThreadedEventLoopGroup)
                    .withLogger(log)
                    .withServiceProviders([RuntimeService(), ImageService()])

                let server = try await grpc.bind(unixDomainSocketPath: socketPath).get()
                log.info("starting gRPC server")

                try await server.onClose.get()
            } catch {
                log.error("\(commandName) failed", metadata: ["error": "\(error)"])
                try? FileManager.default.removeItem(atPath: socketPath)
                CRIShimHelper.exit(withError: error)
            }
        }

        private func setupLogger() -> Logger {
            LoggingSystem.bootstrap { label in
                OSLogHandler(
                    label: label,
                    category: "CRIShimHelper"
                )
            }
            var log = Logger(label: "com.apple.container")
            if debug {
                log.logLevel = .debug
            }
            return log
        }
    }

    private static func releaseVersion() -> String {
        (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? get_release_version().map { String(cString: $0) } ?? "0.0.0"
    }
}
