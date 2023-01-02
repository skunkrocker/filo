import GRDB
import PathKit
import ArgumentParser

struct Conf: ParsableCommand{
    
    public static let configuration = conf("Configure source and library folders.",
                                           subcommands: [Src.self, Lib.self, Setup.self])

    func run() throws {
        connect { db in
            printAllLib(in: db)
            printAllSrc(in: db)
        }
    }
}
