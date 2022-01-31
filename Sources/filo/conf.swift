import GRDB
import PathKit
import ArgumentParser

struct Conf: ParsableCommand{
    
    public static let configuration = conf("Configure source and library folders.",
                                           subcommands: [Lib.self])
    
    @Option(name: .shortAndLong, help: help_blue("Path to the folder with the photo for importing."))
    private var src: String?
    
    @Option(name: .long,  help: help_green("The symbolic name for the source folder."))
    private var srcName: String = "MAIN"

    func run() throws {

    }
}
