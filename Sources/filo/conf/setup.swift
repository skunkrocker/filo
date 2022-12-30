import PathKit
import TSCBasic
import SwiftShell
import Foundation
import ArgumentParser

let exifTar = "Image-ExifTool-12.52.tar.gz"
let exifMacDownUrl = "https://exiftool.org/"

struct Setup: ParsableCommand{
    
    public static let configuration = conf("Download ExifTool and extract it to $HOME/.bin")
    
    fileprivate func deleteWgetLog() {
        let wgetLog = Path("wget-log")
        if wgetLog.exists {
            do {
                try wgetLog.delete()
            } catch {
                //ignore for now
            }
        }
    }
    
    func run() throws {
        
        let wget = SwiftShell.run("which", "wget").stdout
        if  wget.isEmpty {
            print("Wget was not found on your $PATH".red)
        } else {
            print(" Using ".bold + "\(wget)".bold.blue + " on your".bold + " $PATH".bold)
            
            let home = try localFileSystem.homeDirectory.pathString + "/.bin"
            
            let moonBar = moon(" Downloading ".bold + exifTar.bold.green,
                               completeMessage: " Downloaded ".bold  + exifTar.bold.green)
            
            runAsync(wget,"-P", home ,  exifMacDownUrl + exifTar).onCompletion { command in
                moonBar.complete()
                deleteWgetLog()
            }
            moonBar.start()
        }
    }
}
