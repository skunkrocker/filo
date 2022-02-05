
import Foundation

extension FileHandle {
    
    func write(string: String) {
        write(string.data(using: .utf8)!)
    }
    
    public func clearLine() {
        write(string:"\r")
    }
}

extension String {
    static func *(char: String, count: Int) -> String {
        var s = ""
        for _ in 0..<count {
            s.append(char)
        }
        return s
    }
}
