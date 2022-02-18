import PathKit
import TSCBasic
import SwiftDate
import SwiftExif
import Foundation
import AVFoundation
import Photos
import ArgumentParser

struct Test: ParsableCommand {

    public static let configuration = conf("Testing stuff around.")

    func run() throws {
        let file = "/Users/nik/projects/cli/filo/Tests/src3/20220213_154429.mp4"
        print(Path(file).shortAbs)
        let url = URL(fileURLWithPath: "/Users/nik/projects/cli/filo/Tests/src3/20220213_154429.mp4")
        print("Is Movie: \(url.isMovie)")

        videoCreateDate(file) { creationTime in
            let info1 = VintageInfo(lineHead: "date", lineTails: creationTime, lineIcon: "📆 ")
            let info2 = VintageInfo(lineHead: "error", lineTails: "Crazy thing happened you ain't gonna believe it", lineIcon: "🔥 ")
            let info3 = VintageInfo(lineHead: "info", lineTails: "All went good, job well done", lineIcon: "👍 ")

            terminal.instance().vintagePrint([info1, info2, info3], header: "did we find a movie: \(url.isMovie)".uppercased())
        }

        /*
        let url = URL(fileURLWithPath: "/Users/nik/projects/cli/filo/Tests/src3/20220213_154429.mp4")

        let asset = AVURLAsset(url: url)

        asset.availableMetadataFormats.forEach { format in

            let metadata = asset.metadata(forFormat: format) //asset.commonMetadata
            print("Format: \(format)")

            [
                AVMetadataIdentifier.isoUserDataDate,
                AVMetadataIdentifier.id3MetadataDate,
                AVMetadataIdentifier.quickTimeUserDataCreationDate,
                AVMetadataIdentifier.id3MetadataRecordingDates,
                AVMetadataIdentifier.commonIdentifierCreationDate,
                AVMetadataIdentifier.commonIdentifierLastModifiedDate,
            ]
                    .forEach { identifier in
                        print(identifier)

                        let commonCreationDate = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: identifier)
                        if let creationDateItem = commonCreationDate.first {
                            if let creationDate = creationDateItem.dataValue {
                                print("creation date: \(creationDate)")
                            } else {
                                print("nothing")
                            }
                        }
                    }
        }
         */

        /*
        let commonCreationDate = AVMetadataItem.metadataItems(from: metadata,
                filteredByIdentifier: .isoUserDataDate)

        if let creationDateItem = commonCreationDate.first {
            if let creationDate = creationDateItem.dataValue {
                print("creation date: \(creationDate)")
            } else {
                print("nothing")
            }
        } else {
            print("no creation date item")
        }

        let lastModifiedDate = AVMetadataItem.metadataItems(from: metadata,
                filteredByIdentifier: .commonIdentifierLastModifiedDate)

        if let lastModifiedDateItem = lastModifiedDate.first {
            if let lastModifiedDate = lastModifiedDateItem.dataValue {
                print("lastModifiedDate: \(lastModifiedDate)")
            } else {
                print("nothing")
            }
        } else {
            print("no last date item")
        }
         */


        //backUp(url: url)
        Thread.sleep(forTimeInterval: 1)
    }

    private func backUp(url: URL) {
        let asset = AVAsset(url: url)
        let formatsKey = "availableMetadataFormats"
        let key = "availableMetadataFormats";

        asset.loadValuesAsynchronously(forKeys: [key]) {
            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: formatsKey, error: &error)
            if let error = error {
                print("Error occurred: \(error)")
            }
            print("Status: \(status.rawValue)")
            if (status == .loaded) {
                print(asset.metadata.count)
                /*
                [AVMetadataKeySpace.isoUserData,
                 AVMetadataKeySpace.iTunes,
                 AVMetadataKeySpace.quickTimeUserData,
                 AVMetadataKeySpace.quickTimeMetadata,
                 AVMetadataKeySpace.id3,
                 AVMetadataKeySpace.audioFile,
                 AVMetadataKeySpace.hlsDateRange,
                 AVMetadataKeySpace.common,
                 AVMetadataKeySpace.icy
                ].forEach { space in
                    print("\(space)")
                }
                 */

                if asset.metadata.count > 0 {
                    for item in asset.metadata {
                        print("Item key: \(item.key!)")
                        if let val = item.value {
                            if let key = item.keySpace {
                                print("\(key) : \(val.description)")
                            }
                        }
                    }
                }

                /*
                for format in asset.availableMetadataFormats {
                    print("Keyspace: \(format)")
                    let mdFormat = asset.metadata(forFormat: format)

                    let creationDate = AVMetadataIdentifier.commonIdentifierCreationDate
                    let metadata = AVMetadataItem.metadataItems(from: mdFormat, withKey: creationDate)
                    //let metadata = AVMetadataItem.metadataItems(from: mdFormat, withKey: key, keySpace: AVMetadataKeySpace.common)
                    print("MD Count: \(metadata.count)")
                    if (metadata.count > 0) {
                        let item = metadata[0];
                        print(item)
                    }
                }
                */
            }
        }
    }

}