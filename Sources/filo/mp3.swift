import PathKit
import TSCBasic
import Foundation
import ArgumentParser

struct MP3: ParsableCommand {
    
    public static let configuration = conf("Merge MP3 files into one file.")
    
    @Option(name: .shortAndLong,  help: help_green("The path of the input directory where the MP3 files are stored"))
    private var input: String
    
    @Option(name: .shortAndLong,  help: help_green("The folder of the merged MP3 folder"))
    private var file: String
    
    func run() throws {
        let sourcePath = Path(input)
        if sourcePath.exists {
            mergeAll(from: sourcePath, to: file)
        }
    }
    
    func mergeAll(from: Path, to: String){
        catArgs(from) { args in
            do{
                let cat = Process()
                let outputPipe = Pipe()
                
                cat.arguments = args
                cat.standardOutput = outputPipe
                cat.executableURL = URL(fileURLWithPath: "/usr/bin/env")
                
                try cat.run()
                
                let catOutput: Data  = outputPipe
                    .fileHandleForReading
                    .readDataToEndOfFile()
                
                try Path(to).write(catOutput)
                
            } catch {
                print("Error info: \(error)")
            }
        }
    }
    
    func catArgs(_ path: Path, catArgs: ([String]) -> Void) {
        let mp3s = path.glob("*.mp3")
        if mp3s.count == 0 {
            return
        }
        
        var args = ["cat"]
        let files = mp3s.map({ $0.string })
        args.append(contentsOf: files)
        
        catArgs(args)
    }
}
