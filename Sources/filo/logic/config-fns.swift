import GRDB
import PathKit

private let libEntityDef = EntityDef(id: "id", name: "lib", columns: [
    DBColumn(name: "name"),
    DBColumn(name: "path")
])

func configLib(lib: Lib, initFlag: Bool, onDone: (DatabaseQueue) -> Void) -> Void {
    
    let absLib = Path(lib.path).absolute()
    
    connect { db in
        
        initEntity(in: db, entityDef: libEntityDef, initFlag: initFlag)
        
        findAll(
            in: db,
            type: lib.self,
            onSuccess: { libs in
                let hasEntry = libs.contains(where: { $0.name == lib.name })
                if !hasEntry {
                    storeLibConfig(dataBase: db, lib: Lib(path: absLib.string , name: lib.name))
                }
            },
            onNotFound: {
                storeLibConfig(dataBase: db, lib: Lib(path: absLib.string , name: lib.name))
            },
            onError: { error in
                print(error)
            })
          onDone(db)
    }
}

