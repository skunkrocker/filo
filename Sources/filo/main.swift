import Rainbow
import ArgumentParser


struct Filo: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract:
        "\n ❤️  Organize your photos with love ❤️\n".red +
        " " + TRAFIC_LIGHT + " Import images from a source folder to destination library folder\n".blue +
        " " + TRAFIC_LIGHT + " The images are structured in sub folders by year, month and day\n".blue +
        " " + TRAFIC_LIGHT + " The dates are taken from the EXIF date stored in the image it self\n".blue,
        subcommands: [Import.self, Exif.self])
    
    init() { }
}

Filo.main()
