
import Foundation

extension FileHandle {
    
    func write(string: String) {
        write(string.data(using: .utf8)!)
    }
    
    public func clearLine() {
        write(string:"\r")
    }
}

import Foundation

public struct ProgressBar {
    
    private var width: Int = 60
    private var output: FileHandle
    
    public init(output: FileHandle) {
        let w = Double(termWidth()) / 1.3
        print(w)
        self.width = Int(w)
        self.output = output
        self.output.write(string:"")
    }
    
    public mutating func render(count: Int, total: Int) {
        
        let pac = pacManProgress(width: width, count: count, total: total)
        //let progress = barProgress(width: width, count: count, total: total)
        
        //tput cuu1 twice to move the curser up two lines up
        output.clearLine()
        output.write(string: pac)
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

