import Foundation


final class ImageService: Runtime_V1_ImageServiceAsyncProvider {
    let root: URL

    init(root: URL) {
        self.root = root
    }
}
