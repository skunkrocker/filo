
import ArgumentParser

struct Src: ParsableCommand{
    
    public static let configuration = conf("Configure folders as source of photos to be imported.")
    
    @Option(name: .shortAndLong, help: help_blue("Path to the source folder where the importing images are stored."))
    private var src: String?
    
    @Option(name: .shortAndLong,  help: help_green("The symbolic name for the source folder"))
    private var name: String = "MAIN"
    
    @Flag(name: .short, help: help_blue("Initialize filo db stored in '$HOME'/.filo' folder.\n This is needed only during the first usage."))
    private var initialize: Bool = false
    
    func run() throws {
        if src != nil {
            let source = SourceConfig(path: src!, name: name)
            configSrc(src: source, initFlag: initialize) { db in
                printAllSrc(in: db)
            }
        }
        
    }
}

