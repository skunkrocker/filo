import SwiftExif
import Foundation

struct DateExif {
    var gps_date: String = ""
    var date_time: String = ""
    var date_original: String = ""
    var date_digitalized: String = ""
}

fileprivate let gps_date = "GPS Date"
fileprivate let date_time = "Date and Time"
fileprivate let date_original = "Date and Time (Original)"
fileprivate let date_digitalized = "Date and Time (Digitized)"

func dateExif(_ path: String) -> DateExif {
    let url = URL(fileURLWithPath: path)
    let exifImage = SwiftExif.Image(imagePath: url)
    var dateExif = DateExif()

    for dc in exifImage.Exif() {
        for exif in dc.value {
            if exif.key == date_time {
                dateExif.date_time = exif.value
            }
            if exif.key == gps_date {
                dateExif.gps_date = exif.value
            }
            if exif.key == date_original {
                dateExif.date_original = exif.value
            }
            if exif.key == date_digitalized {
                dateExif.date_digitalized = exif.value
            }
        }
    }
    return dateExif
}

func printExif(_ path: String) {
    let newLines = "\n" * 10
    print(newLines)
    let url = URL(fileURLWithPath: path)
    let exifImage = SwiftExif.Image(imagePath: url)

    let exifDict = exifImage.Exif()

    if exifDict.isEmpty {
        print(Error(hint: "Check if the file name and the path are correct.", message: "Failed to load photo EXIF data."))
        return
    }

    print(exifDict: exifDict)
}