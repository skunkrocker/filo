import SwiftExif
import Foundation
import ArgumentParser

struct Exif: ParsableCommand {
    
    public static let configuration = conf("Extract the EXIF Data of a single image and prints it out.")
    
    //@Argument(help: help_blue("Path to the EXIF data photo."))
    //private var path: String
    
    func run() throws {
        /*
         let url = URL(fileURLWithPath: path)
         let exifImage = SwiftExif.Image(imagePath: url)
         
         let exifDict = exifImage.Exif()
         
         if exifDict.isEmpty {
         print(Error(hint: "Check if the file name and the path are correct.", message: "Failed to load photo EXIF data."))
         return
         }
         
         print(exifDict: exifDict)
         */
        let progress = barr(total: 100)
        
        for i in 0...100 {
            progress(i)
            Thread.sleep(forTimeInterval: 0.2)
        }
    }
}
