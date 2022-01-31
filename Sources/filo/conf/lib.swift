
import ArgumentParser

struct Lib: ParsableCommand{
    
    public static let configuration = conf("Configure folders as library where the photos will be copied.")
    
    @Option(name: .shortAndLong, help: help_blue("Path to the library folder where the photos are imported."))
    private var lib: String?
    
    @Option(name: .shortAndLong,  help: help_green("The symbolic name for the library folder"))
    private var name: String = "MAIN"
    
    @Flag(name: .short, help: help_blue("Initialize filo db stored in '$HOME'/.filo' folder.\n This is needed only during the first usage."))
    private var initialize: Bool = false
    
    func run() throws {
        if lib != nil {
            let lib = LibraryConfig(path: lib!, name: name)
            configLib(lib: lib, initFlag: initialize) { db in
                printAllLib(in: db)
            }
        }
        
    }
}
