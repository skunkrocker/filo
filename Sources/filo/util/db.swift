import GRDB
import Foundation

//###########################################
//          library config  table           #
//###########################################

let manager = FileManager.default

protocol DBConfig: Codable, FetchableRecord, PersistableRecord  {
    var path: String { get }
    var name: String { get }
}

struct LibraryConfig:  DBConfig  {
    let path: String
    let name: String
}

struct SourceConfig: DBConfig {
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
struct EntityDef {
    let id: String
    let name: String
    let columns: [DBColumn]
}

struct DBColumn {
    let name: String
    let type: Database.ColumnType? = .text
}


func connect(onSuccess: (DatabaseQueue) -> Void) -> Void {
    var dbConnect: DatabaseQueue? = nil
    do {
        dbConnect = try DatabaseQueue(path: filoConf())
        onSuccess(dbConnect!)
    } catch {
        print(Error(hint: "Write access to the home folder is needed.", message: "Could not connect to the DB under '~/{userName}/.filo'"))
    }
}

func initEntity(in dataBase: DatabaseQueue, entityDef: EntityDef, initFlag: Bool) -> Void {
    if initFlag {
        do {
            try dataBase.write { db in
                try db.create(table: entityDef.name) { t in
                    t.autoIncrementedPrimaryKey(entityDef.id)
                    for col in entityDef.columns {
                        t.column(col.name, col.type).notNull()
                    }
                }
            }
        } catch {
            print(Error(hint: "Check if write access is available to '$HOME/.filo/' folder", message: "Failed to initialize filo config."))
        }
    }
}

func findAll<T: Codable & FetchableRecord & PersistableRecord>(in dataBase: DatabaseQueue,
                                                               type: T,
                                                               onSuccess: ([T]) -> Void,
                                                               onNotFound: () -> Void,
                                                               onError: (Error) -> Void
)  {
    do {
        let entityList = try dataBase.read { db in
            try (T).fetchAll(db)
        }
        if entityList.isEmpty {
            onNotFound()
        } else {
            onSuccess(entityList)
        }
        
    } catch {
        //TODO: print pretty
        //print("could not read lib")
        onError(Error(hint: "Call config command with '-i' flag.", message: "Failed to read library."))
    }
}

func printAllLib(in dataBase: DatabaseQueue) {
    do {
        let entityList = try dataBase.read { db in
            try LibraryConfig.fetchAll(db)
        }
        if !entityList.isEmpty {
            print(entityList)
        }
    } catch {
        print(Error(hint: "Call config command with '-i' flag.", message: "Failed to print entries."))
    }
}

func storeLibConfig(dataBase: DatabaseQueue?, lib: LibraryConfig) -> Void {
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
