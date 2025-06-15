import ContainerClient
import ContainerizationOCI
import Foundation


extension Runtime_V1_Image {
    init(from image: ClientImage) async throws {
        // 1. ID of the image.
        self.id = image.reference

        // 2. Other names by which this image is known.
        let reference = try Reference.parse(ClientImage.normalizeReference(image.reference))
        if let tag = reference.tag {
            self.repoTags = ["\(reference.name):\(tag)"]
        }

        // 3. Digests by which this image is known.
        self.repoDigests = ["\(reference.name)@\(image.digest)"]

        // 4. Size of the image in bytes. Must be > 0.
        self.size = UInt64(image.descriptor.size)

        // 5+6. UID/User name that will run the command(s).
        for manifest in try await image.index().manifests {
            guard let platform = manifest.platform, platform ~= .current else {
                continue
            }
            let platformImage = try await image.config(for: platform)

            if let user = platformImage.config?.user, let user = user.split(separator: ":").first {
                if let uid = Int64(user) {
                    // 5. UID that will run the command(s). This is used as a default if no user is
                    // specified when creating the container. UID and the following user name
                    // are mutually exclusive.
                    self.uid = Runtime_V1_Int64Value()
                    self.uid.value = uid
                } else {
                    // 6. User name that will run the command(s). This is used if UID is not set
                    // and no user is specified when creating container.
                    self.username = String(user)
                }
                break
            }
        }

        // 7. ImageSpec for image which includes annotations
        self.spec = Runtime_V1_ImageSpec()
        self.spec.image = try ClientImage.normalizeReference(image.reference)
        if let annotations = image.descriptor.annotations {
            self.spec.annotations = annotations
        }

        // 8. Recommendation on whether this image should be exempt from garbage collection.
        // It must only be treated as a recommendation -- the client can still request that the image be deleted,
        // and the runtime must oblige.
        self.pinned = false
    }
}

extension Runtime_V1_FilesystemUsage {
    init?(url: URL) throws {
        // 1. Timestamp in nanoseconds at which the information were collected. Must be > 0.
        self.timestamp = Int64(DispatchTime.now().uptimeNanoseconds)

        // 2. The unique identifier of the filesystem.
        let path = url.path(percentEncoded: false)
        let attributes = try FileManager.default.attributesOfFileSystem(forPath: path)
        guard let fileSystemNumber = attributes[.systemNumber] as? Int64 else {
            return nil
        }
        guard let mountURLs = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: nil), !mountURLs.isEmpty else {
            return nil
        }
        for mountPoint in mountURLs {
            let mountPath = mountPoint.path(percentEncoded: false)
            let mountAttributes = try FileManager.default.attributesOfFileSystem(forPath: mountPath)
            guard let mountFileSystemNumber = mountAttributes[.systemNumber] as? Int64 else {
                return nil
            }
            guard mountFileSystemNumber == fileSystemNumber else {
                continue
            }
            self.fsID = Runtime_V1_FilesystemIdentifier()
            self.fsID.mountpoint = mountPath
        }

        // 3+4. UsedBytes/UsedInodes represents usage of images on the filesystem.
        guard let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.fileAllocatedSizeKey]) else {
            return nil
        }
        let (inodes, bytes) = try enumerator.reduce(into: (inodes: Set<Int64>(), usedBytes: 0)) { result, url in
            guard let url = url as? URL else {
                return
            }
            let path = url.path(percentEncoded: false)
            let attributes = try FileManager.default.attributesOfItem(atPath: path)
            guard let fileInode = attributes[.systemFileNumber] as? Int64 else {
                return
            }
            if result.inodes.insert(fileInode).inserted {
                let resourceValues = try url.resourceValues(forKeys: [.fileAllocatedSizeKey])
                if let fileAllocatedSize = resourceValues.fileAllocatedSize {
                    result.usedBytes += fileAllocatedSize
                }
            }
        }

        // 3. UsedBytes represents the bytes used for images on the filesystem.
        // This may differ from the total bytes used on the filesystem and may not
        // equal CapacityBytes - AvailableBytes.
        self.usedBytes = Runtime_V1_UInt64Value()
        self.usedBytes.value = UInt64(bytes)

        // 4. InodesUsed represents the inodes used by the images.
        // This may not equal InodesCapacity - InodesAvailable because the underlying
        // filesystem may also be used for purposes other than storing images.
        self.inodesUsed = Runtime_V1_UInt64Value()
        self.inodesUsed.value = UInt64(inodes.count)
    }
}
