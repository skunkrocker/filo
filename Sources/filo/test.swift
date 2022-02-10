import PathKit
import TSCBasic
import SwiftExif
import Foundation
import ArgumentParser

struct Test: ParsableCommand {

    public static let configuration = conf("Testing stuff around.")

    func run() throws {

        connect() { db in

            let config = srcAndLibConfig(in: db)

            readFilePath(config.srcs) { file in
                let dates = dateExif(file)
                print(file.bold)
                if let gps_date = dates.date_original {
                    print("gps_date: day: \(gps_date.day), month: \(gps_date.month), year: \(gps_date.year)")
                }
                if let date_time = dates.date_time {
                    print("date_time: day: \(date_time.day), month: \(date_time.month), year: \(date_time.year)")
                }
                if let date_digitalized = dates.date_digitalized {
                    print("date_digitalized: day: \(date_digitalized.day), month: \(date_digitalized.month), year: \(date_digitalized.year)")
                }
                if let date_original = dates.date_original {
                    print("date_original: day: \(date_original.day), month: \(date_original.month), year: \(date_original.year)")
                }
                for lib in config.libs {
                    //print(lib.name)
                    //TODO extract exif data from file rename file
                    //TODO create target folder structure in library
                    //TODO copy the file in all library target folders
                } //end lib for
            }//end read file path

        }// end connect db
        /*
        let progress = barz(type: .pac2, total: 100)

        for i in 0...100 {
            progress.update(i, "File: \(i)")
            Thread.sleep(forTimeInterval: 0.2)
        }
        progress.complete()
         */
    }
}

func readFilePath(_ srcs: [SourceConfig], filePath: (String) -> Void) -> Void {
    if srcs.isEmpty {
        print(Error(hint: "Try config command to confugre source folders.", message: "There are no sources configured."))
        return
    }
    for source in srcs {
        do {
            let sourceContent = try localFileSystem.getDirectoryContents(AbsolutePath(source.path))
            for file in sourceContent {
                let content = Path(source.path) + Path(file)
                if content.isFile {
                    filePath(content.absolute().string)
                    //print("Content \(file.blue) is directory: \(String(content.isDirectory).green)")
                }
            }
        } catch {
            print(Error(hint: "Is the configured source a folder or does it exist?", message: "Could not read the folder: \(source.path)"))
        }
    }
}
