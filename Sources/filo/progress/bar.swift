import Rainbow
import TSCBasic
import Foundation

func barr(type: BarType = .pac, total: Int = 100) -> (Int) -> Void {
    let sout     = stdoutStream as WritableByteStream
    let terminal = TerminalController(stream: sout)
    
    let w     = Double(TerminalController.self.terminalWidth()!) / 1.2
    let width = Int(w)
    
    return { step in
        let barString = barStringByType(type, width: width, step: step, total: total)
        terminal?.clearLine()
        terminal?.write(barString)
    }
}


func barrr(type: BarType = .pac, total: Int = 100) -> (update: (Int) -> Void, complete: () -> Void)  {
    let sout     = stdoutStream as WritableByteStream
    let terminal = TerminalController(stream: sout)
    
    let w     = Double(TerminalController.self.terminalWidth()!) / 1.2
    let width = Int(w)
    
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
    
    let w     = Double(terminalWidth) / 1.2
    let width = Int(w)
    
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

