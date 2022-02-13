import Rainbow
import TSCBasic
import Foundation

func barr(type: BarType = .pac, total: Int = 100) -> (Int) -> Void {
    let sout     = stdoutStream as WritableByteStream
    let terminal = TerminalController(stream: sout)
<<<<<<< HEAD
    
    let w     = Double(TerminalController.self.terminalWidth()!) / 1.2
    let width = Int(w)
    
=======
    let terminalWidth = TerminalController.self.terminalWidth()!

    let termWidth = terminalWidth.to_d() / 1.2
    let width = termWidth.to_i()

>>>>>>> feature/import-stuff
    return { step in
        let barString = barStringByType(type, width: width, step: step, total: total)
        terminal?.clearLine()
        terminal?.write(barString)
    }
}


func barrr(type: BarType = .pac, total: Int = 100) -> (update: (Int) -> Void, complete: () -> Void)  {
    let sout     = stdoutStream as WritableByteStream
    let terminal = TerminalController(stream: sout)
<<<<<<< HEAD
    
    let w     = Double(TerminalController.self.terminalWidth()!) / 1.2
    let width = Int(w)
=======
    let terminalWidth = TerminalController.self.terminalWidth()!

    let termWidth = terminalWidth.to_d() / 1.2
    let width = termWidth.to_i()
>>>>>>> feature/import-stuff
    
    return (
        update: { step in
            let barString = barStringByType(type, width: width, step: step, total: total)
            terminal?.clearLine()
            terminal?.write(barString)
        },
        complete: {
            terminal?.endLine()
            terminal?.write("Done".bold + " 🚀")
            terminal?.endLine()
        }
    )
}

func barz(type: BarType = .pac, total: Int = 100) -> (update: (Int, String?) -> Void, complete: () -> Void)  {
    let sout          = stdoutStream as WritableByteStream
    let terminal      = TerminalController(stream: sout)
    let terminalWidth = TerminalController.self.terminalWidth()!
    
<<<<<<< HEAD
    let w     = Double(terminalWidth) / 1.2
    let width = Int(w)
=======
    let termWidth = terminalWidth.to_d() / 1.2
    let width = termWidth.to_i()
>>>>>>> feature/import-stuff
    
    return (
        update: { (step, header) in
            
            let barString = barStringByType(type, width: width, step: step, total: total)
            
            if header != nil {
                terminal?.moveCursor(up: 1)
                terminal?.clearLine()
                terminal?.write(header!)
                terminal?.endLine()
            }
            
            terminal?.clearLine()
            terminal?.write(barString)
        },
        complete: {
            terminal?.endLine()
            terminal?.write("Done".bold + " 🚀")
            terminal?.endLine()
        }
    )
}

