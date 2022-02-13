
import ArgumentParser

struct Import: ParsableCommand{
    
    public static let configuration = conf("Import media from the source to the library folder.")

    func run() throws {
       forAllSrcAndLibs()
    }
}
