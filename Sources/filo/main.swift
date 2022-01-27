import Rainbow
import ArgumentParser

struct Filo: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract:
        "\n ❤️  Organize your photos with love ❤️\n".red +
        " →".green + " Import images from a source folder to destination library folder\n" +
        " →".yellow + " The images are structured in sub folders by year, month and day\n" +
        " →".red + " The dates are taken from the EXIF date stored in the image it self\n",
        subcommands: [Import.self])
    
    init() { }
}

Filo.main()
