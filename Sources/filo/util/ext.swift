import PathKit
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

extension Path {
    var shortAbs: Path {
        if self.isFile {
            let segments = self.absolute().components
            var result = Path("/")
            
            for (index, segment) in segments.enumerated() {
                //print("index: \(index) -> segment: \(segments.startIndex) -> seg: \(segment)")
                if index == segments.startIndex + 1
                    || index == segments.count - 1
                    || index == segments.count - 2 {
                    result = result + Path(segment)
                    continue
                } else {
                    if index == segments.startIndex + 2 && segment.count > 3 {
                        result = result + Path("\(segment.prefix(3))")
                    } else if segment.count > 1 {
                        result = result + Path("\(segment.prefix(1))")
                    } else {
                        result = result + Path(segment)
                    }
                }
            }
            return result
        }
        return self
    }
    
    var dirName: String {
        if self.isDirectory {
            return self.absolute().components.last!
        }
        return self.string
    }
    
    var subDirs: [Path] {
        if self.isDirectory {
            return self.glob("*").filter({ $0.isDirectory })
        }
        return []
    }
    
    func filesFor(ext: String) -> [Path] {
        return self.glob("*.\(ext)")
    }
    
    var mp3s: [Path] {
        return self.filesFor(ext: "mp3")
    }
    
    func addBeforeExt(_ toAppend: String) -> Path {
        var stringified: String = self.string
        if self.extension != nil {
            guard let index = stringified.lastIndex(of: ".") else { return self }
            stringified.insert(contentsOf: toAppend, at: index)
            return Path(stringified)
        }
        return self
    }
    
    var isNotSymlink: Bool {
        return !self.isSymlink
    }
    
    var isNotExecutable: Bool {
        return !self.isExecutable
    }
    
    var isNotDirectory: Bool {
        return !self.isDirectory
    }
}

extension Dictionary {
    func each(block: (Int, Key, Value) -> Void) -> Void {
        for (index, element) in enumerated() {
            block(index, element.key, element.value)
        }
    }
}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }
    
    func replace(character: String, with: String) -> String {
        let stringToArray = self.components(separatedBy: character)
        return stringToArray.joined(separator: with)
    }
    
    func replaceSpace(with: String) -> String {
        return self.replace(character: " ", with: with)
    }
}
