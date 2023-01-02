import Rainbow
import TSCBasic
import Foundation

enum BarType {
    case pac
    case pac2
    case bars
}

enum AeonType {
    case led
    case led2
    case moon
    case signal
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

func pacMan2Progress(width: Int, count: Int, total: Int) -> String {
    let logo = "Pᗣᗧ".yellow + "MᗣN".green
    
    let progress       = Float(count) / Float(total)
    let leftSideChars  = Int(floor(progress * Float(width)))
    let rightSideChars = width - leftSideChars
    
    let pac = "ᗧ"
    var left = ""
    if leftSideChars - 1 > 0 {
        left = " " * leftSideChars
    }
    
    let right      = "•" * rightSideChars
    let percentage = Int(floor(progress * 100))
    
    return "\(logo.blink)[\(left)\(pac.yellow.bold)\(right)] \(percentage)%"
}


func barStringByType(_ type: BarType, width: Int, step: Int, total: Int) -> String {
    switch type {
        case .pac:
            return pacManProgress(width: width, count: step, total: total)
        case .pac2:
            return pacMan2Progress(width: width, count: step, total: total)
        case .bars:
            return barProgress(width: width, count: step, total: total)
    }
}

///Led bars
fileprivate let ledBars = ["⣀","⣄","⣤","⣦","⣶","⣷","⣿"]
///Led bars 2
fileprivate let ledBars2 = ["⣀","⣄","⣆","⣇","⣧","⣷","⣿"]
///Signal bars
fileprivate let sygnalBars = ["▁","▂","▃", "▄","▅","▆","▇","█"]
///Moon phases for the endless progress
fileprivate let moonBars = ["\u{e3e3}", "\u{e3e2}", "\u{e3e1}", "\u{e3e0}", "\u{e3df}", "\u{e3de}", "\u{e3dd}", "\u{e3dc}", "\u{e3db}", "\u{e3da}", "\u{e3d9}", "\u{e3d8}", "\u{e3d7}", "\u{e3d6}", "\u{e38d}"]

func aeonBarType(_ type: AeonType) -> [String] {
    switch type {
        case .led:
            return ledBars
        case .led2:
            return ledBars2
        case .moon:
            return moonBars
        case .signal:
            return sygnalBars
    }
}
