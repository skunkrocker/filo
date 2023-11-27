import PathKit
import SwiftBar
import SwiftExt
import SwiftAsk
import TSCBasic
import SwiftDate
import SwiftExif
import Foundation
import AVFoundation
import Photos
import ArgumentParser
import AVFoundation
import ImageIO
//import ExifTool

struct Test: ParsableCommand {
    
    public static let configuration = conf("Testing stuff around.")
    
    func extractImageWithIO(_ path: String) {
        let fileURL =     URL(fileURLWithPath: path)
        if let imageSource = CGImageSourceCreateWithURL(fileURL as CFURL, nil) {
            let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil)
            if let dict = imageProperties as? [String: Any] {
                if let exifDict = dict[kCGImagePropertyExifDictionary as String] as? [String: Any] {
                    if let dateTimeOriginal = exifDict[kCGImagePropertyExifDateTimeOriginal as String] as? String {
                        print("DateTimeOriginal from ImageIO: \(dateTimeOriginal)".yellow.bold)
                    } 
                    if let dateTimeDigitized = exifDict[kCGImagePropertyExifDateTimeDigitized as String] as? String {
                        print("DateTimeDigitized from ImageIO: \(dateTimeDigitized)".blue.bold)
                    }
                }
            }
        }
    }
    
    func run() throws {
        
        print(DateFormatter().monthSymbols[11 - 1].capitalized)
        print(DateFormatter().shortMonthSymbols[11 - 1].capitalized)
        
        SwiftDate.autoFormats = ["yyyy:MM:dd HH:mm:ss", "yyyy:MM:dd", "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"]
        
        
        let fileName = "/Users/nik/projects/cli/filo/Tests/src3/20220213_154429.mp4"
        
        avAssetCreateDate(fileName, onSuccess:{ dateString in
            print("AVAsset date: \(dateString)")
        }, onError: {
            print("Shipaide")
        })
        
        extractImageWithIO("/Users/nik/projects/cli/filo/Tests/src/exif-example.jpeg")
        /*
         let answer = askYesNo("Do you like pings?", color: .blue)
         say("The answer was: \(answer)")
         
         print()
         
         let question = Question(question: "Wonna play game", color: .blue)
         ask(question, .yes_or_no) {
         say("Glad you agree!!".bold)
         }
         
         let q = Question(question: "Wonna play game", color: .blue)
         ask(q, .yes_no_brackets) { answer in
         say("Glad you agree!!".bold)
         }
         
         let a = ask(question, .yes_no_brackets)
         say("You answered with: \(a)")
         
         ask(question, .yes_no_brackets) { answer in
         say("The answer to your question is: \(answer) ", color: .cyan)
         }
         */
        
        /*
         print(Path(file).shortAbs)
         let url = URL(fileURLWithPath: "/Users/nik/projects/cli/filo/Tests/src3/20220213_154429.mp4")
         print("Is Movie: \(url.isMovie)")
         
         videoCreateDate(file) { creationTime in
         let info1 = VintageInfo(lineHead: "date", lineTails: creationTime, lineIcon: "📆 ")
         let info2 = VintageInfo(lineHead: "error", lineTails: "Crazy thing happened you ain't gonna believe it", lineIcon: "🔥 ")
         let info3 = VintageInfo(lineHead: "info", lineTails: "All went good, job well done", lineIcon: "👍 ")
         
         terminal.get().vintagePrint([info1, info2, info3], header: "did we find a movie: \(url.isMovie)".uppercased())
         }
         */
    }
}
