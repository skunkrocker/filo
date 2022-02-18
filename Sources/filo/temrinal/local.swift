import TSCBasic
import Foundation

func localTerminal() -> (get: () -> TerminalController, width: () -> Int) {
    let std_out = stdoutStream as WritableByteStream
    let terminal = TerminalController(stream: std_out)
    let termWidth = TerminalController.self.terminalWidth()!.to_d() * 0.9

    let width = (termWidth / 1.2).to_i()

    return (
            get: { terminal! },
            width: { width }
    )
}

let terminal = localTerminal()

struct VintageInfo {
    let lineHead: String
    let lineTails: String
    let lineIcon: String
    var isPath = false
}

extension TerminalController {

    func vintagePrint(_ info: VintageInfo) {
        let message = self.vintageMessage(info)
        terminal.get().write(message + "\n")
    }

    func vintagePrint(_ infos: [VintageInfo]) {
        for info in infos {
            vintagePrint(info)
        }
    }

    func vintagePrint(_ infos: [VintageInfo], header: String) {
        let width = terminal.width()
        let boldHeader = header.uppercased().bold
        let widthWithoutHeader = (width - boldHeader.utf8.count) / 2
        let beforeHeader = " " * widthWithoutHeader

        terminal.get().write(beforeHeader + boldHeader + "\n")
        for info in infos {
            let message = self.vintageMessage(info)
            terminal.get().write(message + "\n")
        }
    }

    func vintageMessage(_ info: VintageInfo) -> String {
        let width = terminal.width()

        let lineHeadBold = info.lineHead.uppercased().bold
        let tails = info.isPath ? info.lineTails : info.lineTails.capitalized
        let lineTailsBold = " " + tails.bold
        let lineHeadBoldCount = lineHeadBold.utf8.count
        let lineTailBoldCount = lineTailsBold.utf8.count

        let paddingCount = width - lineTailBoldCount - lineHeadBoldCount + 2

        let message = info.lineIcon +
                lineHeadBold +
                " ".padding(toLength: paddingCount, withPad: "•", startingAt: 0) +
                lineTailsBold
        return message
    }
}