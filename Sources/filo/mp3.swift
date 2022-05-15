import PathKit
import TSCBasic
import Foundation
import ArgumentParser

struct MP3: ParsableCommand {
    
    public static let configuration = conf("Merge MP3 files into one file.")
    
    //@Argument(help: help_blue("Folder path to the MP3 files."))
    //private var path: String
    
    @Option(name: .shortAndLong,  help: help_green("The path of the input directory where the MP3 files are stored"))
    private var input: String
    
    @Option(name: .shortAndLong,  help: help_green("The folder of the merged MP3 folder"))
    private var output: String
    
    func run() throws {
        let destPath = Path(input)
        if destPath.exists {
            exec(path: destPath, output: output)
        }
    }
}

func exec(path: Path, output: String){
    do{
        var args = ["cat"]
        let mp3s = path.glob("*.mp3")
        
        if mp3s.count == 0 {
            return
        }
        mp3s.forEach { file in
            args.append( file.string)
        }
        
        let completePipe = Pipe()
        let process = Process()
        
        process.arguments = args
        process.standardOutput = completePipe
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        
        try process.run()
        
        let input: Data  = completePipe
            .fileHandleForReading
            .readDataToEndOfFile()
        try Path(output).write(input)
    } catch {
        print("Error info: \(error)")
    }
}
