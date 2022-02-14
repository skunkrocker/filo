import Foundation
import UniformTypeIdentifiers

extension Int {
    func to_d() -> Double {
        Double(self)
    }
}

extension Double {
    func to_i() -> Int {
        Int(self)
    }
}


extension URL {
    var isImage: Bool {
        UTType(filenameExtension: self.pathExtension)?.conforms(to: .image) ?? false
    }

    var isAudio: Bool {
        UTType(filenameExtension: self.pathExtension)?.conforms(to: .audio) ?? false
    }

    var isMovie: Bool {
        UTType(filenameExtension: self.pathExtension)?.conforms(to: .movie) ?? false
    }

    var isVideo: Bool {
        UTType(filenameExtension: self.pathExtension)?.conforms(to: .video) ?? false
    }

    var mimeType: String {
        UTType(filenameExtension: self.pathExtension)?.preferredMIMEType ?? "application/octet-stream"
    }
}