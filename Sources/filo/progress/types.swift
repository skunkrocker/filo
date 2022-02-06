import Rainbow
import TSCBasic
import Foundation

enum BarType {
    case pac
    case pac2
    case bars
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
