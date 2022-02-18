import Rainbow
import TSCBasic
import Foundation

func barr(type: BarType = .pac, total: Int = 100) -> (Int) -> Void {

    let width = terminal.width()
    let iterm = terminal.get()

    return { step in
        let barString = barStringByType(type, width: width, step: step, total: total)
        iterm.clearLine()
        iterm.write(barString)
    }
}


func barrr(type: BarType = .pac, total: Int = 100) -> (update: (Int) -> Void, complete: () -> Void) {

    let width = terminal.width()
    let iterm = terminal.get()

    return (
            update: { step in
                let barString = barStringByType(type, width: width, step: step, total: total)
                iterm.clearLine()
                iterm.write(barString)
            },
            complete: {
                iterm.endLine()
                iterm.write("Done".bold + " 🚀")
                iterm.endLine()
            }
    )
}

func barz(type: BarType = .pac, total: Int = 100) -> (update: (Int, String?) -> Void, complete: () -> Void) {

    let width = terminal.width()
    let iterm = terminal.get()

    let update: (Int, String?) -> () = { (step, header) in

        let barString = barStringByType(type, width: width, step: step, total: total)

        if header != nil {
            iterm.moveCursor(up: 1)
            iterm.clearLine()
            iterm.write(header!)
            iterm.endLine()
        }

        iterm.clearLine()
        iterm.write(barString)
    }
    return (
            update: update,
            complete: {
                update(total, " Awesome".bold + " 🔥")

                iterm.endLine()
                iterm.write(" Done".bold + " 🚀")
                iterm.endLine()
            }
    )
}
