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
    let traficLight: String
}

private let exifTable = TextTable<EXIF> {
    [
        Column(title: "", value: $0.traficLight),
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
                let exif = EXIF(key: meta.key.green, value: meta.value.green, traficLight: TRAFIC_LIGHT_OPAQUE)
                data.append(exif)
            } else {
                let exif = EXIF(key: meta.key.blue, value: meta.value.blue, traficLight: TRAFIC_LIGHT)
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

private let errorTable = TextTable<Error> {
    [
        Column(title: "", value: TRAFIC_LIGHT + " ⚠️  " +  $0.message.red)
    ]
}
private let hintTable = TextTable<Error> {
    [
        Column(title: "", value: TRAFIC_LIGHT_OPAQUE +  " 💡 " + $0.hint.green)
    ]
}

func print(_ error: Error) {
    errorTable.print([error], style: Style.plain)
    hintTable.print([error], style: Style.plain)
}

private let libTable = TextTable<LibraryConfig> {
    [
        Column(title: "", value: "📚" +  "  " + $0.name.uppercased().blue + " " + TRAFIC_LIGHT + "  "),
        Column(title: "", value: $0.path.green)
    ]
}

func print(_ libs: [LibraryConfig]) {
    libTable.print(libs, style: Style.plain)
}
