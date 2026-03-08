import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

extension Image {
    /// A robust initializer for creating a SwiftUI Image from raw Data.
    /// Uses UIKit on iOS and handles missing modules gracefully.
    init?(data: Data) {
        #if canImport(UIKit)
        if let uiImage = UIImage(data: data) {
            self.init(uiImage: uiImage)
        } else {
            return nil
        }
        #else
        // Fallback for non-iOS environments or minimal toolchains
        return nil
        #endif
    }
}
