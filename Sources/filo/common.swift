import ArgumentParser


func help(_ desc: String) -> ArgumentHelp {
    return ArgumentHelp(stringLiteral: desc.blue)
}

func conf(_ desc:  String) -> CommandConfiguration {
    return CommandConfiguration(abstract: desc.blue)
}
