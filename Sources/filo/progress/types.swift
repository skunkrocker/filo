import Rainbow
import Foundation


func barProgress(width: Int, count: Int, total: Int) -> String {
    let progress = Float(count) / Float(total)
    let numberOfBars = Int(floor(progress * Float(width)))
    let numberOfTicks = width - numberOfBars
    let bars = "🁢" * numberOfBars
    let ticks = "-" * numberOfTicks
    
    let percentage = Int(floor(progress * 100))
    return "[\(bars.green.bold)\(ticks.bold)] \(percentage)%"
}

func pacManProgress(width: Int, count: Int, total: Int) -> String {
    let progress = Float(count) / Float(total)
    let leftSideChars = Int(floor(progress * Float(width)))
    let rightSideChars = width - leftSideChars
    
    let pac = "ᗧ".yellow.bold
    
    var left = ""
    if leftSideChars - 1 > 0 {
       left = " " * leftSideChars
    }
    
    var right = "•" * rightSideChars
    right = right.red
    
    let percentage = Int(floor(progress * 100))
    
    return "[\(left)\(pac)\(right)] \(percentage)%"
}
