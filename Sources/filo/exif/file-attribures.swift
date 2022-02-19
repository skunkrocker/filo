import TSCBasic
import Foundation

//########################################################################
//      use ffprobe utility to extract the create date of a video file   #
//########################################################################
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

//########################################################################
//          extract the create date from the ffprobe json output         #
//########################################################################
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

//########################################################################
//      extract the file modification date with the file manager         #
//########################################################################
func fileModificationDate(url: URL, success: (Date) -> Void) -> Void {
    do {
        let attr = try FileManager.default.attributesOfItem(atPath: url.path)
         success(attr[FileAttributeKey.modificationDate] as! Date)
    } catch {
        //do nothing
    }
}

//########################################################################
//          extract the file creation date with the file manager         #
//########################################################################
func fileCreationDate(url: URL, success: (Date) -> Void) -> Void {
    do {
        let attr = try FileManager.default.attributesOfItem(atPath: url.path)
        success(attr[FileAttributeKey.modificationDate] as! Date)
    } catch {
        //do nothing
    }
}
