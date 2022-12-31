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

func aeon(_ type: AeonType, _ message: String = " Loading".bold, _ completeMessage: String = " Completed".bold ) -> (start: () -> Void, complete: () -> Void){
     let iterm = terminal.get()
    var isRunning = true
    var currentIndex = 0
    let charsByType = aeonBarType(type)
    let start: () -> () = {
        while isRunning {
            let bars = currentIndex == charsByType.count ? charsByType.reversed() : charsByType
            for sygnalBar in bars {
                iterm.clearLine()
                iterm.write(message + " " + sygnalBar.blue + "  ")
                currentIndex = currentIndex < charsByType.count ? currentIndex + 1 : currentIndex - 1
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
    let longNumber = 10000 * 10000
    while i < longNumber {
        i += 1
    }
    
}
