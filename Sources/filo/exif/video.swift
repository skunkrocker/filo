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
        let tool = Process(args: "exiftool",
                           "-j",
                           "\(file)"
        )
        try tool.launch()
        let result = try tool.waitUntilExit()
        
        var exifDates = Dictionary<String, String>()
        let output = try result.utf8Output()
        
        let json =  try JSON(string: output).getArray()
        
        if let fistElement: JSON = json.first {
            tags(json: fistElement, { tag,value in
                exifDates[tag] = value
            })
            
            success(exifDates)
        }
        
        
    } catch {
        print(error)
    }
}

func tags(json: JSON, _ tagValue: (String,String) -> Void) -> Void {
    ["CreateDate","ModifyDate"].forEach {
        let tag = $0
        if let value: String = json.get(tag) {
            tagValue(tag, value)
        }
    }
}
