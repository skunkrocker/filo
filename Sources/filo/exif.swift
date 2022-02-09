import PathKit
import TSCBasic
import SwiftExif
import Foundation
import ArgumentParser

struct Exif: ParsableCommand {

    public static let configuration = conf("Extract the EXIF Data of a single image and prints it out.")

    @Argument(help: help_blue("Path to the EXIF data photo."))
    private var path: String

    func run() throws {
        printExif(path)
    }
}
