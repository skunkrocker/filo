
import SwiftExif
import Foundation
import ArgumentParser


struct Exif: ParsableCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: "Imports the images from the source folder in to the library folder."
    )
    
    func run() throws {
        let testFilePath = "/Users/nik/projects/cli/filo/Tests/20211230_151252.jpg"
        let url = URL(fileURLWithPath: testFilePath)
        let exifImage = SwiftExif.Image(imagePath: url)
        
        for dc in exifImage.Exif() {
            for meta in dc.value {
                print("\(meta.key)->\(meta.value)")
            }
        }
        
    }
    
}
