import Darwin
import Darwin.sys.ttycom

func printTermViewPortSize() {
    var win = winsize()
    if ioctl(STDOUT_FILENO, TIOCGWINSZ, &win) == 0 {
        print("rows:", win.ws_row, "cols", win.ws_col)
    }
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
