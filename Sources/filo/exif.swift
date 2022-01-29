//import TextTable
import SwiftExif
import Foundation
import ArgumentParser

struct Exif: ParsableCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: " Reads the EXIF Data of a single image and prints it out.".blue
    )
    
    @Argument(help: "The absolute path of the photo for which the EXIF should be read")
    private var path: String
    
    func run() throws {
        
        let url = URL(fileURLWithPath: path)
        let exifImage = SwiftExif.Image(imagePath: url)
        
        alternateExifTable(exifDict: exifImage.Exif())
    }
    
}
