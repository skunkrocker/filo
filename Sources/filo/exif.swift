import TextTable
import SwiftExif
import Foundation
import ArgumentParser

struct EXIF {
    let key: Any
    let value: Any
}

let table = TextTable<EXIF> {
    [
        Column(title: "", value: $0.key),
        Column(title: "", value: $0.value)
    ]
}


struct Exif: ParsableCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: " Reads the EXIF Data of a single image and prints it on the CLI.".blue
    )
    
    @Argument(help: "The absolute path of the photo for which the EXIF should be read")
    private var path: String
    
    func run() throws {
        //let testFilePath = "/Users/nik/projects/cli/filo/Tests/20211230_151252.jpg"
        let url = URL(fileURLWithPath: path)
        let exifImage = SwiftExif.Image(imagePath: url)
        
        var data: [EXIF] = []
        
        for dc in exifImage.Exif() {
            for meta in dc.value {
                //print("\(meta.key)->\(meta.value)")
                data.append(EXIF(key: meta.key, value: meta.value))
            }
        }
        
        table.print(data, style: Style.plain)
        
    }
    
}
