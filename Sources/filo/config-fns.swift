import PathKit

private let entity = EntityDef(id: "id", name: "lib", columns: [
    DBColumn(name: "name"),
    DBColumn(name: "path")
])

func configLib(lib: Lib, initFlag: Bool) -> Void {
    
    let absLib = Path(lib.path).absolute()
    
    connect(
        onSuccess: { db in
            
            initEntity(in: db, entityDef: entity, initFlag: initFlag)
            
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
        },
        onError: { error in
            print(error)
        },
        after: { db in
            findAll(
                in: db,
                type: lib.self,
                onSuccess: { libs in
                    print(libs)
                },
                onNotFound: {
                    print("not found")
                },
                onError: { error in
                    print(error)
                })
        }
    )
}

