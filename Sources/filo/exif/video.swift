import TSCBasic
import Foundation

func probe(_ file: String, success: (String) -> Void) -> Void {
    do {
        let ffprobe = Process(args: "ffprobe",
                              "-v",
                              "quiet",
                              "\(file)",
                              "-print_format",
                              "json",
                              "-show_entries",
                              "stream_tags:format_tags")
        try ffprobe.launch()
        let result = try ffprobe.waitUntilExit()
        success(try result.utf8Output())
    } catch {
        //do nothing
    }
}

func videoCreateDate(_ file: String, success: (String) -> Void) -> Void {
    probe(file) { output in
        do {
            let json = try JSON(string: output)
            if let format: JSON = try? json.get("format") {
                if let tags: JSON = try? format.get("tags") {
                    if let creationTime: String = tags.get("creation_time") {
                        success(creationTime)
                    }
                }
            }
        } catch {
            //do nothing
        }
    }
}

func exifTool(_ file: String, success: (Dictionary<String, String>) -> Void) -> Void {
    do {
        let tool = Process(args: "exiftool", "-time:all", "-j", "\(file)")
        try tool.launch()
        let result = try tool.waitUntilExit()
        
        let json =  try JSON(string: result.utf8Output()).getArray()
        
        if let fistElement: JSON = json.first {
            var exifDates = Dictionary<String, String>()
            tags(json: fistElement, { tag,value in
                exifDates[tag] = value
            })
            success(exifDates)
        }
        
    } catch {
        //do nothing
    }
}

let create_date = "CreateDate"
//let modify_date = "ModifyDate"
let track_create_date = "TrackCreateDate"
let media_create_date = "MediaCreateDate"
let dates_of_interest = [create_date, media_create_date, track_create_date]

func tags(json: JSON, _ tagValue: (String,String) -> Void) -> Void {
    dates_of_interest.forEach {
        let tag = $0
        if let value: String = json.get(tag) {
            tagValue(tag, value)
        }
    }
}
