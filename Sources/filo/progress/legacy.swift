
import Darwin
import Foundation

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
            case .pac2:
                barString = pacMan2Progress(width: width, count: step, total: total)
                break
            case .bars:
                barString = barProgress(width: width, count: step, total: total)
        }
        sout.clearLine()
        sout.write(string: barString)
    }
}
