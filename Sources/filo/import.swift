
import ArgumentParser

struct Import: ParsableCommand{
    
    public static let configuration = conf(" Imports the images from the source folder in to the library folder.")
    
    @Option(name: .shortAndLong, help: help("Path to the folder with the images for importing."))
    private var source: String?
    
    
    @Option(name: .shortAndLong, help: help("Path to the library folder where the images are imported."))
    private var library: String?
    
    
    func run() throws {
        if source == nil || library == nil {
            print("The source and library are mandatory".red)
            return
        }
        print("Source folder: \(source!) -> library: \(library!)")
    }
}
