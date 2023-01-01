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
    
    func wget() -> Promise<String> {
        Promise { seal in
            let wget = SwiftShell.run("which", "wget").stdout
            if wget.isEmpty {
                print("wget".bold + "was not found on " + "$PATH".bold)
                seal.reject(NSError())
            } else {
                seal.fulfill(wget)
            }
        }
    }
    
    func tar() -> Promise<String> {
        Promise { seal in
            let tar = SwiftShell.run("which", "tar").stdout
            if tar.isEmpty {
                print("tar".bold + "was not found on " + "$PATH".bold)
                seal.reject(NSError())
            } else {
                seal.fulfill(tar)
            }
        }
    }
    
    
    fileprivate func download(wget: String) -> Promise<Void> {
        return Promise { seal in
            
            var isCompleted = false
            
            print(" Using ".bold + "\(wget)".bold.blue + " on ".bold + " $PATH".bold)
            
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
    
    fileprivate func extract(tar: String)  -> Promise<Void> {
        return Promise { seal in
            
            var isCompleted = false
            
            print(" Using ".bold + "\(tar)".bold.blue + " on ".bold + " $PATH".bold)
            
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
        
        let queue = DispatchQueue.global()
        let semaphore = DispatchSemaphore(value: 0)
        
        firstly {
            wget()
        }.then(on: queue) { wget in
            download(wget: wget)
        }.then(on: queue) {
            tar()
        }.then(on: queue) { tar in
            extract(tar: tar)
        }.done(on: queue) {
            semaphore.signal()
        }.catch(on: queue) { error in
            //ignore
        }
        
        semaphore.wait()
        
    }
}
