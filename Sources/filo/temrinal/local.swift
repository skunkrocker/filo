import TSCBasic
import Foundation

func localTerminal() -> (instance: () -> TerminalController, width: () -> Int) {
    let std_out = stdoutStream as WritableByteStream
    let terminal = TerminalController(stream: std_out)
    let termWidth = TerminalController.self.terminalWidth()!.to_d() * 0.9

    let width = (termWidth / 1.2).to_i()

    return (
            instance: { terminal! },
            width: { width }
    )
}

let terminal = localTerminal()
