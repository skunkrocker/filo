//
//  File.swift
//  
//
//

import ArgumentParser

struct Import: ParsableCommand{
    
    public static let configuration = CommandConfiguration(
        abstract: "Imports the images from the source folder in to the library folder."
    )
    
    @Option(name: .shortAndLong, help: "The folder that holds the images that are to be imported.")
    private var source: String?
    
    
    @Option(name: .shortAndLong, help: "The folder is the library where the images are to be imported.")
    private var library: String?
    
    
    func run() throws {
        print("Source folder: \(source!) -> library: \(library!)")
    }
}
