import SwiftExif
import Foundation
import ArgumentParser

struct Exif: ParsableCommand {
    
    public static let configuration = conf(" Extract the EXIF Data of a single image and prints it out.")
    
    @Argument(help: help("Path to the EXIF data photo."))
    private var path: String
    
    func run() throws {
        
        let url = URL(fileURLWithPath: path)
        let exifImage = SwiftExif.Image(imagePath: url)
        
        let exifDict = exifImage.Exif()
        
        if exifDict.isEmpty {
            print(Error(hint: "Check if the path is correct.", message: "Could not load EXIF for the image."))
            return
        }
        
        print(exifDict: exifDict)
        
    }
    
}
