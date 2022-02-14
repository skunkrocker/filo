import TSCBasic
import Foundation

func ffProbe(success: (String) -> Void) -> Void {
    let ffprobe = Process(args: "ffprobe",
            "-v",
            "quiet",
            "./Tests/src3/20220213_154429.mp4",
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

func createDate(success: (String) -> Void) -> Void {
    ffProbe { output in
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