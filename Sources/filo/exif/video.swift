import Foundation
//kindly provided by: http://blog.larod.org/?p=310

class Video {
    // Instance variables here for easy access
    //let name: String
    //let ext: String
    let url: NSURL
    let size: NSNumber
    let dateAdded: NSDate
    // This dictionary holds all the metadata, is kept just in case we need more data later.
    let mediaItemDictionary: NSDictionary
    // This bool is here so to help our tags later on, we can retrieve all videos that are not tagged.
    var isTagged: Bool
    // I want to retrieve all dictionary data when I write someVideo.description,
    // for this we override the object description.
    var description: String {
        return mediaItemDictionary.description
    }
    init(fileURL: NSURL) {
        /* CoreServices MDItemCreate creates our mediaItem, this is still C and we need to allocate memory for our mediaItem, we use a CFAllocator for this, the second parameter is the fileURL as a string, we use the .path so that the URL is returned as a string. This mediaItem contains all the metadata we need. */
        let mediaItem = MDItemCreate(kCFAllocatorDefault, (fileURL.path! as CFString))
        // MDItemCopyAttributeNames returns a CFArray with data from the mediaItem object.
        let mediaItemAttributeNames = MDItemCopyAttributeNames(mediaItem)
        // Since we don't want to have to deal with CFArrays we create a dictionary with the attributes values
        // and attribute names.
        mediaItemDictionary = MDItemCopyAttributes(mediaItem, mediaItemAttributeNames)
        // You pretty much done, all this code does is copy some basic data to our variables for accessibility.
        //name = mediaItemDictionary.value(forKey: kMDItemDisplayName as String).stringByDeletingPathExtension! as! String
        //ext = mediaItemDictionary.value(forKey: kMDItemDisplayName as String)!.pathExtension! as! String
        url = fileURL
        size = mediaItemDictionary.value(forKey: kMDItemFSSize as String)! as! NSNumber
        dateAdded = mediaItemDictionary.value(forKey: kMDItemDateAdded as String)! as! NSDate
        isTagged = false
    }
}