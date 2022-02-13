import PathKit
import TSCBasic
<<<<<<< HEAD
=======
import SwiftDate
>>>>>>> feature/import-stuff
import SwiftExif
import Foundation
import ArgumentParser

struct Test: ParsableCommand {
<<<<<<< HEAD
    
    public static let configuration = conf("Testing stuff around.")
   
    func run() throws {
        let dirPath = Path("./Tests").absolute()
        let contents = try localFileSystem.getDirectoryContents(AbsolutePath(dirPath.string))
        
        for file in contents {
            let content = dirPath + Path(file)
            print("Content \(file.blue) is directory: \(String(content.isDirectory).green)")
        }
        /*
        let progress = barz(type: .pac2, total: 100)
        
=======

    public static let configuration = conf("Testing stuff around.")

    func run() throws {
        forAllSrcAndLibs()
        /*
        let progress = barz(type: .pac2, total: 100)

>>>>>>> feature/import-stuff
        for i in 0...100 {
            progress.update(i, "File: \(i)")
            Thread.sleep(forTimeInterval: 0.2)
        }
        progress.complete()
         */
<<<<<<< HEAD

=======
>>>>>>> feature/import-stuff
    }
}
