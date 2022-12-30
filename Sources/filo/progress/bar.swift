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
///moon phases for the endless progress
fileprivate let moons = ["\u{e3e3}", "\u{e3e2}", "\u{e3e1}", "\u{e3e0}", "\u{e3df}", "\u{e3de}", "\u{e3dd}", "\u{e3dc}", "\u{e3db}", "\u{e3da}", "\u{e3d9}", "\u{e3d8}", "\u{e3d7}", "\u{e3d6}", "\u{e38d}"]

func moon(_ message: String = " Loading".bold, completeMessage: String = " Completed".bold ) -> (start: () -> Void, complete: () -> Void){
    
    let iterm = terminal.get()
    var isRunning = true
    var currentIndex = 0
    let start: () -> () = {
        while isRunning {
            let phases = currentIndex == moons.count ? moons.reversed() : moons
            for phase in phases {
                iterm.clearLine()
                iterm.write(message + " " + phase.blue + "  ")
                currentIndex = currentIndex < moons.count ? currentIndex + 1 : currentIndex - 1
                sleep()
            }
        }
        iterm.clearLine()
        iterm.write(completeMessage + " 🚀")
        iterm.endLine()
        sleep()
    }
    return (
        start: start,
        complete: {
            isRunning = false
        }
    )
}
///Sleep without thread blocking
func sleep() {
    var i = 0
    let longNumber = 1000 + 10000 * 10000
    while i < longNumber {
        i += 1
    }
    
}
