import GRDB

struct EntityDef {
    let id: String
    let name: String
    let columns: [DBColumn]
}

struct DBColumn {
    let name: String
    let type: Database.ColumnType? = .text
}

func connect(onSuccess: (DatabaseQueue) -> Void, onError: (Error) -> Void, after: (DatabaseQueue) -> Void) -> Void {
    var dbConnect: DatabaseQueue? = nil
    do {
        dbConnect = try DatabaseQueue(path: filoConf())
        onSuccess(dbConnect!)
    } catch {
        onError(Error(hint: "Write access to the home folder is needed.", message: "Could not connect to the DB under '~/{userName}/.filo'"))
    }
    if dbConnect != nil {
        after(dbConnect!)
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
