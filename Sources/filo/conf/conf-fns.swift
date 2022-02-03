import GRDB
import PathKit

private let libEntityDef = EntityDef(id: "id", name: "LibraryConfig", columns: [
    DBColumn(name: "name"),
    DBColumn(name: "path")
])

func configLib(lib: LibraryConfig, initFlag: Bool, onDone: (DatabaseQueue) -> Void) -> Void {
    
    let absLib = Path(lib.path).absolute()
    
    connect { db in
        
        initEntity(in: db, entityDef: libEntityDef, initFlag: initFlag)
        
        findAll(
            in: db,
            type: lib.self,
            onSuccess: { libs in
                let hasEntry = libs.contains(where: { $0.name == lib.name })
                if !hasEntry {
                    storeLibConfig(dataBase: db, lib: LibraryConfig(path: absLib.string , name: lib.name))
                }
            },
            onNotFound: {
                storeLibConfig(dataBase: db, lib: LibraryConfig(path: absLib.string , name: lib.name))
            },
            onError: { error in
                print(error)
            })
          onDone(db)
    }
}

private let srcEntityDef = EntityDef(id: "id", name: "SourceConfig", columns: [
    DBColumn(name: "name"),
    DBColumn(name: "path")
])


func configSrc(src: SourceConfig, initFlag: Bool, onDone: (DatabaseQueue) -> Void) -> Void {
    
    let absSrc = Path(src.path).absolute()
    
    connect { db in
        
        initEntity(in: db, entityDef: srcEntityDef, initFlag: initFlag)
        
        findAll(
            in: db,
            type: src.self,
            onSuccess: { srcs in
                let hasEntry = srcs.contains(where: { $0.name == src.name })
                if !hasEntry {
                    storeSrcConfig(dataBase: db, src: SourceConfig(path: absSrc.string , name: src.name))
                }
            },
            onNotFound: {
                storeSrcConfig(dataBase: db, src: SourceConfig(path: absSrc.string , name: src.name))
            },
            onError: { error in
                print(error)
            })
          onDone(db)
    }
}

