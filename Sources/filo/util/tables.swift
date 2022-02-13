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

func print(_ error: Error) {
    print(TRAFIC_LIGHT + " ⚠️  " + error.message.red)
    print(TRAFIC_LIGHT_OPAQUE +  " 💡 " + error.hint.green.bold)
}


//########################################################
//          print library in the formated table          #
//########################################################

struct TableLibraryConfig {
    let separator: String
    let lib: LibraryConfig
}

private let libTable = TextTable<TableLibraryConfig> {
    [
        Column(title: "", value: "📚" +  "  " + $0.lib.name.uppercased().blue + "  "),
        Column(title: "", value: $0.separator),
        Column(title: "", value: $0.lib.path.green)
    ]
}

func print(_ libs: [LibraryConfig]) {
    print("\n    Media Library".bold )
    var i = 0
    let tableSourceConfig = libs.map { (lib) -> TableLibraryConfig in
        let separator = i % 2 == 0 ? TRAFIC_LIGHT : TRAFIC_LIGHT_OPAQUE
        i += 1
        return TableLibraryConfig(separator: separator, lib: lib)
    }
    libTable.print(tableSourceConfig, style: Style.plain)
}

//########################################################
//          print source in the formatted table          #
//########################################################

struct TableSourceConfig {
    let separator: String
    let src: SourceConfig
}

private let srcTable = TextTable<TableSourceConfig> {
    [
        Column(title: "", value: "📷" +  "  " + $0.src.name.uppercased().blue + "   "),
        Column(title: "", value: $0.separator),
        Column(title: "", value: $0.src.path.green)
    ]
}

func print(_ srcs: [SourceConfig]) {
    print("\n    Media source".bold )
    var i = 0

    let tableSourceConfig = srcs.map { (src) -> TableSourceConfig in
        let separator = i % 2 == 0 ? TRAFIC_LIGHT : TRAFIC_LIGHT_OPAQUE
        i += 1
        return TableSourceConfig(separator: separator, src: src)
    }

    srcTable.print(tableSourceConfig, style: Style.plain)
}

func noFilesFound() {
    print("💡 " +  "Nothing found in the source folders".yellow.bold)
}