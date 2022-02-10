import SwiftExif
import SwiftDate
import Foundation

struct DateExif {
    var gps_date: DateInRegion? = nil
    var date_time: DateInRegion? = nil
    var date_original: DateInRegion? = nil
    var date_digitalized: DateInRegion? = nil
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
                dateExif.date_time = date(of: exif.value) ?? nil
            }
            if exif.key == gps_date {
                dateExif.gps_date = date(of: exif.value) ?? nil
            }
            if exif.key == date_original {
                dateExif.date_original = date(of: exif.value) ?? nil
            }
            if exif.key == date_digitalized {
                dateExif.date_digitalized = date(of: exif.value) ?? nil
            }
        }
    }
    return dateExif
}

func date(of isoDate: String) -> DateInRegion? {
    if isoDate != nil && isoDate != "" {
        //print("isoDate: \(isoDate)")
        var newDate = isoDate.toDate("yyyy:MM:dd HH:mm:ss")
        if newDate == nil {
            newDate = isoDate.toDate("yyyy:MM:dd")
        }
        //print(newDate)
        return newDate
    }
    return nil
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