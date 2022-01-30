import GRDB
import Foundation

//###########################################
//          library config  table           #
//###########################################

let manager = FileManager.default

struct Lib:  Codable, FetchableRecord, PersistableRecord  {
    let path: String
    let name: String
}

struct Src: Codable, FetchableRecord, PersistableRecord  {
    let path: String
    let name: String
}

func filoConf() -> String {
    let filoDir = manager.homeDirectoryForCurrentUser.path + "/.filo"
    let sqlDB   = filoDir + "/filo.sqlite"
    
    var isDir : ObjCBool = true
    let filoConfigDir = manager.fileExists(atPath: sqlDB, isDirectory: &isDir)
    
    if !filoConfigDir {
        do{
            try manager.createDirectory(atPath: filoDir , withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(Error(hint: "Consider creating the folder '~/.filo'.", message: "Could not create the folder under $HOME directory."))
        }
    }
    
    return sqlDB
}


//###########################################
//             open db connection           #
//             in the $HOME/.filo           #
//                   folder                 #
//###########################################
func openDb() -> DatabaseQueue? {
    do {
        return try DatabaseQueue(path: filoConf())
    } catch {
        print(Error(hint: "Write access to the home folder is needed.", message: "Could not connect to the DB under '~/{userName}/.filo'"))
    }
    return nil
}

func libConfInit(dataBase:  DatabaseQueue?) -> Void {
    if dataBase == nil {
        return
    }
    do {
        try dataBase!.write { db in
            try db.create(table: "lib") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("name", .text).notNull()
                t.column("path", .text).notNull()
            }
        }
    } catch {
        print(Error(hint: "Check if write access is available to '$HOME/.filo/' folder", message: "Failed to initialize filo config."))
    }
    
}

func storeLibConfig(dataBase: DatabaseQueue?, lib: Lib) -> Void {
    if dataBase == nil {
        return
    }
    do {
        try dataBase!.write { db in
            try lib.insert(db)
        }
    } catch {
        print(Error(hint: "Check if write access is available to '$HOME/.filo/' folder" , message: "Failed to store library: \(lib.name)"))
        
        print("Error info: \(error)")
    }
}

func findLibConfig(dataBase: DatabaseQueue?) -> [Lib] {
    if dataBase == nil {
        return []
    }
    //var libs: [Lib] = []
    do {
        return try dataBase!.read { db in
            try Lib.fetchAll(db)
        }
    } catch {
        //TODO: print pretty
        print("could not read lib")
    }
    return []
}
