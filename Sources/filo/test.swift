import PathKit
import TSCBasic
import SwiftDate
import SwiftExif
import Foundation
import ArgumentParser

struct Test: ParsableCommand {

    public static let configuration = conf("Testing stuff around.")

    func run() throws {
        forAllSrcAndLibs()
        /*
        let progress = barz(type: .pac2, total: 100)

        for i in 0...100 {
            progress.update(i, "File: \(i)")
            Thread.sleep(forTimeInterval: 0.2)
        }
        progress.complete()
         */
    }
}
