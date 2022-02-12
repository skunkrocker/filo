import PathKit
import TSCBasic
import SwiftDate
import SwiftExif
import Foundation
import Foundation

//###########################################
//       read the paths for each file       #
//       that is found in the configured    #
//          folders in the config db        #
//       the folders in the library folder  #
//      will be created by the pattern      #
//      yyyy/MM/dd and will copy all the    #
//      files according to their EXIF in    #
//      the appropriate library folder      #
//###########################################
func forAllSrcAndLibs() {
    SwiftDate.autoFormats = ["yyyy:MM:dd HH:mm:ss", "yyyy:MM:dd"]

    connect { db in
        let config = srcAndLibConfig(in: db)
        let files = readFilePaths(config.srcs)
        if (files.isEmpty) {
            noFilesFound()
            return
        }
        let progress = barz(total: files.count)
        for (index, file) in files.enumerated() {
            createLibraryFolders(config.libs, file: file) { libPath in
                //TODO copy the file in all library target folders
                progress.update(index + 1, file.bold)
                Thread.sleep(forTimeInterval: 1)
            }//end read file path
        }//end of files loop
        progress.complete()
    }// end connect db
}

//###########################################
//      read the paths of the files in      #
//      the configured source folders       #
//###########################################
fileprivate func readFilePaths(_ srcs: [SourceConfig]) -> [String] {
    if srcs.isEmpty {
        print(Error(hint: "Try config command to configure source folders.", message: "There are no sources configured."))
        return []
    }
    var allFiles: [String] = []
    for source in srcs {
        do {
            let sourceContent = try localFileSystem.getDirectoryContents(AbsolutePath(source.path))
            for file in sourceContent {
                let content = Path(source.path) + Path(file)
                if content.isFile {
                    allFiles.append(content.absolute().string)
                    //print("Content \(file.blue) is directory: \(String(content.isDirectory).green)")
                }
            }
        } catch {
            print(Error(hint: "Is the configured source a folder or does it exist?", message: "Could not read the folder: \(source.path)"))
        }
    }
    return allFiles
}

//###########################################
//    create all the library sub folders    #
//    according the EXIF dates in of the    #
//      files that have to be copied        #
//###########################################
func createLibraryFolders(_ libs: [LibraryConfig], file: String, copyTo: (String) -> Void) {
    let dates = dateExif(file)
    for lib in libs {
        if let subFolder = getFolderStructure(exif: dates) {
            let subFoldrPath = Path(lib.path + "/" + subFolder)
            if !subFoldrPath.exists {
                do {
                    try makeDirectories(AbsolutePath(subFoldrPath.absolute().string))
                } catch {
                    //TODO figure out what to do with this
                }
            }
            copyTo(subFoldrPath.absolute().string + "/")
        }
    }
}

//###########################################
//    extract the EXIF data of the file     #
//    to build the folder structure where   #
//    it has to be copied i.e. moved        #
//###########################################
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