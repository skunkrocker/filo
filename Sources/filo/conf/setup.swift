import PathKit
import TSCBasic
import SwiftBar
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
    
    var tarDwonloadMsg = " Downloading ".bold + exifTar.bold.green
    var tarDownloadCompleteMsg = " Downloaded ".bold  + exifTar.bold.green
    
    fileprivate func downloadExifTool(wget: String) -> Promise<Void> {
        Promise { seal in
            
            waitForAsync { stopWaitingFn in
                print(" Using ".bold + "\(wget)".bold.blue + " on $PATH".bold)
                
                aeon(.led2, tarDwonloadMsg, tarDownloadCompleteMsg) { start, complete in
                    
                    runAsync(wget,"-P", self.tmp ,  exifMacDownUrl + exifTar).onCompletion { command in
                        complete()
                        deleteWgetLog()
                        stopWaitingFn()
                    }
                    start()
                }
            }
            seal.fulfill(())
        }
    }
    
    var tarExtractingMsg = " Extracting ".bold + exifTar.bold.green
    var tarCompleteExtracingMsg = " Extracted ".bold  + exifTar.bold.green
    
    fileprivate func extractExifTool(tar: String)  -> Promise<Void> {
        Promise { seal in
            
            waitForAsync { stopWaitingFn in
                print(" Using ".bold + "\(tar)".bold.blue + " on ".bold + "$PATH".bold)
                
                aeon(.led2,tarExtractingMsg, tarCompleteExtracingMsg) { start, complete in
                    
                    runAsync(tar,"xzfv", self.tmpTarFile, "-C", self.tmp).onCompletion { command in
                        complete()
                        stopWaitingFn()
                    }
                    start()
                }
            }
            seal.fulfill(())
        }
    }
    
    
    func run() throws {
        
        waitOnQueue { queue, stopWaitingFn in
            firstly {
                findWgetOnPath()
            }.then(on: queue) { wget in
                downloadExifTool(wget: wget)
            }.then(on: queue) {
                findTarOnPath()
            }.then(on: queue) { tar in
                extractExifTool(tar: tar)
            }.done(on: queue) {
                stopWaitingFn()
            }.catch(on: queue) { error in
                print((error as NSError).userInfo["info"]!)
                stopWaitingFn()
            }
        }
    }
}
