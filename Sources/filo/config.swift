import GRDB
import PathKit
import ArgumentParser

struct Config: ParsableCommand{
    
    public static let configuration = conf("Configure source and library folders.")
    
    @Option(name: .shortAndLong, help: help_blue("Path to the folder with the photo for importing."))
    private var src: String?
    
    @Option(name: .long,  help: help_green("The symbolic name for the source folder."))
    private var srcName: String = "MAIN"
    
    
    @Option(name: .shortAndLong, help: help_blue("Path to the library folder where the photos are imported."))
    private var lib: String?
    
    @Option(name: .long,  help: help_green("The symbolic name for the library folder"))
    private var libName: String = "MAIN"
    
    @Flag(name: .short, help: help_blue("Initialize filo db stored in '$HOME'/.filo' folder.\n This is needed only during the first usage."))
    private var initialize: Bool = false
    
    
    func run() throws {
        if src == nil || lib == nil {
            print("The source and library are mandatory".red)
            return
        }
        
        let db = openDb()
        
        if db != nil {
            if initialize {
                libConfInit(dataBase: db!)
            }
            var libs: [Lib] = findLibConfig(dataBase: db!)
            
            let absLib = Path(lib!).absolute()
            
            if libs.isEmpty {
                storeLibConfig(dataBase: db!, lib: Lib(path: absLib.string , name: libName))
            } else {
                let hasEntry = libs.contains(where: { $0.name == libName })
                if !hasEntry {
                    storeLibConfig(dataBase: db!, lib: Lib(path: absLib.string , name: libName))
                }
            }
            
            libs = findLibConfig(dataBase: db!)
            print(libs)
        }
    }
}
