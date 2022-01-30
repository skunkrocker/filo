
import ArgumentParser

struct Import: ParsableCommand{
    
    public static let configuration = conf("Import photos from the source to the library folder.")
    
    @Option(name: .shortAndLong, help: help_blue("Path to the folder with the images for importing."))
    private var src: String?
    
    
    @Option(name: .shortAndLong, help: help_blue("Path to the library folder where the images are imported."))
    private var lib: String?
    
    
    func run() throws {
        if src == nil || lib == nil {
            print("The source and library are mandatory".red)
            return
        }
        print("Source folder: \(src!) -> library: \(lib!)")
    }
}
