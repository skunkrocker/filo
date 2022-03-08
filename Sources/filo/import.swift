import ArgumentParser

struct Import: ParsableCommand {

    public static let configuration = conf("Import media from the source to the library folder.")

    @Flag(name: .shortAndLong, help: help_blue("Print out the files that are copied with their destination."))
    private var verbose: Bool = false

    func run() throws {
        forAllSrcAndLibs(verbose)
    }
}
