import Rainbow
import ArgumentParser

struct Filo: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: " Organize your photos with love.\n".yellow.onLightBlue +
        " Import images from a source folder to destination library folder.\n".green +
        " The images are structured in sub folders by year, month and day.\n".yellow +
        " The dates are taken from the EXIF date stored in the image it self.\n".red,
        subcommands: [Import.self])
    
    init() { }
}

Filo.main()
