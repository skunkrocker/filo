import Rainbow
import ArgumentParser


struct Filo: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: NL +
        "        ❤️  Organize your photos with love ❤️\n".red +
        "        " + TRAFIC_LIGHT + " Import photos from a source folder to destination library folder.\n".blue +
        "        " + TRAFIC_LIGHT + " The photos are structured in sub folders by year, month and day.\n".blue +
        "        " + TRAFIC_LIGHT + " The dates are taken from the EXIF date stored in the photo it self.\n".blue,
        subcommands: [Config.self, Import.self, Exif.self])
    
    init() { }
}

Filo.main()
