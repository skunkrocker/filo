import PathKit
import TSCBasic
import SwiftDate
import SwiftExif
import Foundation
import Foundation

//########################################################################
//       read the paths for each file that is found in the configured    #
//       folders in the config db the folders in the library folder      #
//      will be created by the pattern yyyy/MM/dd and will copy all the  #
//      files according to their EXIF in the appropriate library folder  #
//########################################################################
func forAllSrcAndLibs() {
    SwiftDate.autoFormats = ["yyyy:MM:dd HH:mm:ss", "yyyy:MM:dd"]
    var copied: [VintageInfo] = []
    connect { db in
        let config = srcAndLibConfig(in: db)
        let files = readFilePaths(config.srcs)
        if (files.isEmpty) {
            noFilesFound()
            return
        }
        let progress = barz(total: files.count)
        for (index, mediaFile) in files.enumerated() {
            createLibraryFolders(config.libs, file: mediaFile.value.string) { libDestination in

                let destFile = libDestination + Path(mediaFile.key)
                copy(mediaFile: mediaFile.value, destFile: destFile)

                let info = VintageInfo(
                        lineHead: "\(mediaFile.key)",
                        lineTails: destFile.shortAbs.string,
                        lineIcon: "📂 ", isPath: true)

                let message = terminal.get().vintageMessage(info)
                copied.append(info)

                progress.update(index + 1, message)
                //Thread.sleep(forTimeInterval: 2)
            }//end read file path
        }//end of files loop
        progress.complete()
    }// end connect db
    terminal.get().vintagePrint(copied, header: "files copied")
}

//########################################################################
//          copy the media file to the destination in the library        #
//########################################################################
private func copy(mediaFile: Path, destFile: Path) {
    if !destFile.exists {
        do {
            let fileContent = try localFileSystem.readFileContents(AbsolutePath(mediaFile.string))
            try localFileSystem.writeFileContents(AbsolutePath(destFile.string), bytes: fileContent)
        } catch {
            //TODO what happens with failed copies
        }
    }
}

//########################################################################
//      read the paths of the files in the configured source folders     #
//########################################################################
fileprivate func readFilePaths(_ srcs: [SourceConfig]) -> Dictionary<String, Path> {
    if srcs.isEmpty {
        print(Error(hint: "Try config command to configure source folders.", message: "There are no sources configured."))
        return [:]
    }
    var allFiles: Dictionary<String, Path> = [:]
    for source in srcs {
        do {
            let sourceContent = try localFileSystem.getDirectoryContents(AbsolutePath(source.path))
            for file in sourceContent {
                let thePath = Path(source.path) + Path(file)
                let isSimpleFile = thePath.isFile
                        && !thePath.isSymlink
                        && !thePath.isExecutable
                        && !thePath.isDirectory
                if isSimpleFile {
                    allFiles[file] = thePath.absolute()
                }
            }
        } catch {
            print(Error(hint: "Is the configured source a folder or does it exist?", message: "Could not read the folder: \(source.path)"))
        }
    }
    return allFiles
}

//########################################################################
//          create all the library sub folders according the EXIF dates  #
//                  of the files that have to be copied                  #
//########################################################################
func createLibraryFolders(_ libs: [LibraryConfig], file: String, copyTo: (Path) -> Void) {
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
            copyTo(subFoldrPath.absolute())
        }
    }
}

//########################################################################
//            extract the EXIF data of the file to build                 #
//            the folder structure where it has to be copied i.e. moved  #
//########################################################################
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