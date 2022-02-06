import Darwin
import Rainbow
import TSCBasic
import Foundation

enum BarType {
    case pac
    case bars
}

//from the cli it can be retreived by the command
//`tput cols 2>/dev/null`
//tty terminals also support
//`stty size 2>/dev/null`
func termWidth() -> Int {
    var win = winsize()
    if ioctl(STDOUT_FILENO, TIOCGWINSZ, &win) == 0 {
        return Int(win.ws_col)
    }
    return 80 //default
}

func barProgress(width: Int, count: Int, total: Int) -> String {
    let progress      = Float(count) / Float(total)
    let numberOfBars  = Int(floor(progress * Float(width)))
    let numberOfTicks = width - numberOfBars
    
    let bars  = "🁢" * numberOfBars
    let ticks = "-" * numberOfTicks
    
    let percentage = Int(floor(progress * 100))
    return "[\(bars.blue.bold)\(ticks.bold)] \(percentage)%"
}

func pacManProgress(width: Int, count: Int, total: Int) -> String {
    let logo = "Pᗣᗧ".yellow + "MᗣN".green
    
    let progress       = Float(count) / Float(total)
    let leftSideChars  = Int(floor(progress * Float(width - logo.count)))
    let rightSideChars = width - logo.count - leftSideChars
    
    var pac = "ᗧ"
    var left = ""
    if leftSideChars - 1 > 0 {
        left = " " * leftSideChars
    }
    
    var right = "•" * rightSideChars
    right     = right.red + logo
    
    if rightSideChars == 0 {
        pac  = "💥"
        left = " " * (left.count - 1)
    }
    
    let percentage = Int(floor(progress * 100))
    
    return "[\(left)\(pac.yellow.bold)\(right)] \(percentage)%"
}

func standardBar(type: BarType = .pac, total: Int = 100) -> (Int) -> Void {
    let sout = FileHandle.standardOutput
    
    let w = Double(termWidth()) / 1.2
    let width = Int(w)
    
    return { step in
        var barString = ""
        switch type {
            case .pac:
                barString = pacManProgress(width: width, count: step, total: total)
                break
            case .bars:
                barString = barProgress(width: width, count: step, total: total)
        }
        sout.clearLine()
        sout.write(string: barString)
    }
}

func barr(type: BarType = .pac, total: Int = 100) -> (Int) -> Void {
    let sout     = stdoutStream as WritableByteStream
    let terminal = TerminalController(stream: sout)
    
    let w     = Double(TerminalController.self.terminalWidth()!) / 1.2
    let width = Int(w)
    
    return { step in
        var barString = ""
        switch type {
            case .pac:
                barString = pacManProgress(width: width, count: step, total: total)
                break
            case .bars:
                barString = barProgress(width: width, count: step, total: total)
        }
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
            var barString = ""
            switch type {
                case .pac:
                    barString = pacManProgress(width: width, count: step, total: total)
                    break
                case .bars:
                    barString = barProgress(width: width, count: step, total: total)
            }
            /*
             terminal?.moveCursor(up: 1)
             terminal?.clearLine()
             terminal?.write("Hello world".bold)
             terminal?.endLine()
             */
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
            var barString = ""
            switch type {
                case .pac:
                    barString = pacManProgress(width: width, count: step, total: total)
                    break
                case .bars:
                    barString = barProgress(width: width, count: step, total: total)
            }
            
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

