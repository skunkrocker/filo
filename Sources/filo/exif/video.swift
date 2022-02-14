import TSCBasic
import Foundation

func probe(_ file: String, success: (String) -> Void) -> Void {
    let ffprobe = Process(args: "ffprobe",
            "-v",
            "quiet",
            "\(file)",
            "-print_format",
            "json",
            "-show_entries",
            "stream_tags:format_tags")
    do {
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