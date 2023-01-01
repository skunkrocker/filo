import PathKit
import TSCBasic
import SwiftShell
import PromiseKit
import Foundation
import ArgumentParser

let exifTar = "Image-ExifTool-12.52.tar.gz"
let exifMacDownUrl = "https://exiftool.org/"

struct Setup: ParsableCommand{
    
    public static let configuration = conf("Download ExifTool and extract it to $HOME/.bin")
    
    var tmpTarFile: String {
        return self.tmp + "/" + exifTar
    }
    
    var tmp: String = "/tmp"
    
    func errorMessage(_ cmd: String) -> String {
        cmd.bold.blue + " was not found".bold.red + " on $PATH".bold
    }
    
    func rejectError(_ cmd: String) -> NSError {
        NSError(domain: "localhost", code: 2000, userInfo: ["info": errorMessage(cmd)])
    }
    
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
    
    func findWgetOnPath() -> Promise<String> {
        Promise { seal in
            let wget = SwiftShell.run("which", "wget").stdout
            if wget.isEmpty {
                seal.reject(rejectError("wget"))
            } else {
                seal.fulfill(wget)
            }
        }
    }
    
    func findTarOnPath() -> Promise<String> {
        Promise { seal in
            let tar = SwiftShell.run("which", "tar").stdout
            if tar.isEmpty {
                seal.reject(rejectError("tar"))
            } else {
                seal.fulfill(tar)
            }
        }
    }
    
    
    fileprivate func downloadExifTool(wget: String) -> Promise<Void> {
        return Promise { seal in
            
            var isCompleted = false
            
            print(" Using ".bold + "\(wget)".bold.blue + " on $PATH".bold)
            
            let loadExifTarBar = aeon(.led2, " Downloading ".bold + exifTar.bold.green,
                                      " Downloaded ".bold  + exifTar.bold.green)
            
            runAsync(wget,"-P", self.tmp ,  exifMacDownUrl + exifTar).onCompletion { command in
                loadExifTarBar.complete()
                deleteWgetLog()
                isCompleted = true
            }
            loadExifTarBar.start()
            
            while !isCompleted {}
            
            return seal.fulfill(())
        }
    }
    
    fileprivate func extractExifTool(tar: String)  -> Promise<Void> {
        return Promise { seal in
            
            var isCompleted = false
            
            print(" Using ".bold + "\(tar)".bold.blue + " on ".bold + "$PATH".bold)
            
            let extractExifBar = aeon(.led2, " Extracting ".bold + exifTar.bold.green,
                                      " Extracted ".bold  + exifTar.bold.green)
            
            runAsync(tar,"xzfv", self.tmpTarFile, "-C", self.tmp).onCompletion { command in
                extractExifBar.complete()
                isCompleted = true
            }
            
            extractExifBar.start()
            
            while !isCompleted {}
            
            return seal.fulfill(())
        }
    }
    
    
    func run() throws {
        
        waitOnQueue { queue, semaphore in
            firstly {
                findWgetOnPath()
            }.then(on: queue) { wget in
                downloadExifTool(wget: wget)
            }.then(on: queue) {
                findTarOnPath()
            }.then(on: queue) { tar in
                extractExifTool(tar: tar)
            }.done(on: queue) {
                semaphore.signal()
            }.catch(on: queue) { error in
                print((error as NSError).userInfo["info"]!)
                semaphore.signal()
            }
        }
    }
}
