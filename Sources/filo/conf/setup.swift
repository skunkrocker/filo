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
    
    fileprivate func downloadExifToolTar(_ wget: String, extract:  @escaping () -> Void) {
        print(" Using ".bold + "\(wget)".bold.blue + " on your".bold + " $PATH".bold)
        
        //let home = try localFileSystem.homeDirectory.pathString + "/.bin"
        let tempFolder = "/tmp"
        
        let loadExifTarBar = aeon(.led2, " Downloading ".bold + exifTar.bold.green,
                                  " Downloaded ".bold  + exifTar.bold.green)
        
        runAsync(wget,"-P", tempFolder ,  exifMacDownUrl + exifTar).onCompletion { command in
            loadExifTarBar.complete()
            deleteWgetLog()
            Thread.sleep(forTimeInterval: 2)
            extract()
        }
        loadExifTarBar.start()
    }
    
    fileprivate func extractTar() {
        
    }
    
    var tmpTarFile: String {
        return self.tmp + "/" + exifTar
    }
    
    var tmp: String {
        do {
            return try localFileSystem.tempDirectory.pathString
        } catch {
            return Path.home.string
        }
    }
    
    func wgetOnPath() -> String {
        SwiftShell.run("which", "wget").stdout
    }
    
    func tarOnPath() -> String {
        SwiftShell.run("which", "tar").stdout
    }
    
    func wget() -> Promise<String> {
        Promise { seal in
            let wget = wgetOnPath()
            if wget.isEmpty {
                print("wget".bold + "was not found on your " + "$PATH".bold)
                seal.reject(NSError())
            } else {
                seal.fulfill(wget)
            }
        }
    }
    
    func tar() -> Promise<String> {
        Promise { seal in
            let tar = tarOnPath()
            if tar.isEmpty {
                print("tar".bold + "was not found on your " + "$PATH".bold)
                seal.reject(NSError())
            } else {
                seal.fulfill(tar)
            }
        }
    }
    
    
    fileprivate func download(wget: String) -> Promise<Bool> {
        return Promise { seal in
            
            var isCompleted = false
            
            print(" Using ".bold + "\(wget)".bold.blue + " on your".bold + " $PATH".bold)
            
            let loadExifTarBar = aeon(.led2, " Downloading ".bold + exifTar.bold.green,
                                      " Downloaded ".bold  + exifTar.bold.green)
            
            runAsync(wget,"-P", self.tmp ,  exifMacDownUrl + exifTar).onCompletion { command in
                loadExifTarBar.complete()
                deleteWgetLog()
                Thread.sleep(forTimeInterval: 2)
                isCompleted = true
            }
            loadExifTarBar.start()
            
            while !isCompleted {}
            
            return seal.fulfill(true)
        }
    }
    
    fileprivate func extract(tar: String)  -> Promise<Void> {
        return Promise { seal in
            
            var isCompleted = false
            
            print(" Using ".bold + "\(tar)".bold.blue + " on your".bold + " $PATH".bold)
            
            let extractExifBar = aeon(.led2, " Extracting ".bold + exifTar.bold.green,
                                      " Extracted ".bold  + exifTar.bold.green)
            
            runAsync(tar,"-xzfv", self.tmpTarFile, "-C", self.tmp).onCompletion { command in
                extractExifBar.complete()
                Thread.sleep(forTimeInterval: 2)
                isCompleted = true
            }
            extractExifBar.start()
            
            while !isCompleted {}
            
            return seal.resolve(.fulfilled(()))
        }
    }
    
    
    func run() throws {
        
        let queue = DispatchQueue.global()
        let semaphore = DispatchSemaphore(value: 0)
        
        wget()
            .then(on: queue) { wget in
                download(wget: wget)
            }.then(on: queue) { _ in
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
