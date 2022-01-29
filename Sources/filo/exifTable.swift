import TextTable
import Foundation

let TRAFIC_LIGHT        = "❯".green + "❯".yellow + "❯".red
let TRAFIC_LIGHT_OPAQUE = "❯".red + "❯".yellow + "❯".green

//########################################################
//          print exif data in a formatted table         #
//           the rows are in alternating colors          #
//########################################################

struct EXIF {
    let key: String
    let value: String
    let separator: String
}

let exifTable = TextTable<EXIF> {
    [
        Column(title: "", value: $0.separator),
        Column(title: "", value: $0.key),
        Column(title: "", value: $0.value),
    ]
}


func print(exifDict: [String: [String: String]] ) {
    
    var data: [EXIF] = []
    
    for dc in exifDict {
        var i = 0
        for meta in dc.value {
            if i % 2 == 0{
                let exif = EXIF(key: meta.key.green, value: meta.value.green, separator: TRAFIC_LIGHT_OPAQUE)
                data.append(exif)
            } else {
                let exif = EXIF(key: meta.key.blue, value: meta.value.blue, separator: TRAFIC_LIGHT)
                data.append(exif)
            }
            i += 1
        }
        i = 0
    }
    exifTable.print(data, style: Style.plain)
}

//########################################################
//          print errors in a formatted table            #
//########################################################

struct Error {
    let hint: String
    let message: String
}

let errorTable = TextTable<Error> {
    [
        Column("" <- $0.message),
        Column("" <- $0.hint)
    ]
}

func print(_ error: Error) {
    let colorError: Error = Error(hint: "⚠️  " + error.hint.green, message: TRAFIC_LIGHT + " " + error.message.red)
    errorTable.print([colorError], style: Style.plain)
}
