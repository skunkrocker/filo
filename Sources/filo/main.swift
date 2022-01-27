import Rainbow
import ArgumentParser

struct Filo: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: " Organize your photos with love.\n".yellow.onLightBlue + "Import images from different sources to designated library folder structured by year, month and day.".blue,
        subcommands: [Import.self])
    
    init() { }
}

Filo.main()
