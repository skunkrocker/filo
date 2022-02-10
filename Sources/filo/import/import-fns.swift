import PathKit
import TSCBasic
import SwiftDate
import SwiftExif
import Foundation
import Foundation

func forAllSrcAndLibs() {
    SwiftDate.autoFormats = ["yyyy:MM:dd HH:mm:ss", "yyyy:MM:dd"]

    connect() { db in
        let config = srcAndLibConfig(in: db)
        readFilePath(config.srcs) { file in
            forLibSubDir(config.libs, path: file) { libPath in
                print(libPath.bold)
                //TODO copy the file in all library target folders
            }
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

func readFilePath(_ srcs: [SourceConfig], filePath: (String) -> Void) -> Void {
    if srcs.isEmpty {
        print(Error(hint: "Try config command to configure source folders.", message: "There are no sources configured."))
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

func forLibSubDir(_ libs: [LibraryConfig], path: String, copyTo: (String) -> Void) {
    let dates = dateExif(path)
    for lib in libs {
        if let subFolder = getFolderStructure(exif: dates) {
            let subFoldrPath = Path(lib.path + "/" + subFolder + "/")
            if !subFoldrPath.exists {
                do {
                    try makeDirectories(AbsolutePath(subFoldrPath.absolute().string))
                } catch {
                    //TODO figure out what to do with this
                }
            }
            copyTo(subFoldrPath.absolute().string)
        }
    }
}

func getFolderStructure(exif: DateExif) -> String? {
    if let date_original = exif.date_original {
        return "/\(date_original.year)/\(date_original.month)/\(date_original.day)"
        //print("date_original: day: \(date_original.day), month: \(date_original.month), year: \(date_original.year)")
    }
    if let date_time = exif.date_time {
        return "/\(date_time.year)/\(date_time.month)/\(date_time.day)"
        //print("date_time: day: \(date_time.day), month: \(date_time.month), year: \(date_time.year)")
    }
    if let date_digitalized = exif.date_digitalized {
        return "/\(date_digitalized.year)/\(date_digitalized.month)/\(date_digitalized.day)"
        //print("date_digitalized: day: \(date_digitalized.day), month: \(date_digitalized.month), year: \(date_digitalized.year)")
    }
    if let gps_date = exif.date_original {
        return "/\(gps_date.year)/\(gps_date.month)/\(gps_date.day)"
        //print("gps_date: day: \(gps_date.day), month: \(gps_date.month), year: \(gps_date.year)")
    }
    return "/lost+found"
}