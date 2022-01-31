import ArgumentParser

let NL = "\n"
let TWO_TABS = "        "

func help_blue(_ desc: String, cmdOpt: CmdOpt = .opt) -> ArgumentHelp {
    return ArgumentHelp(stringLiteral: cmdOpt.rawValue.green + desc.blue)
}

func help_red(_ desc: String, cmdOpt: CmdOpt = .opt) -> ArgumentHelp {
    return ArgumentHelp(stringLiteral: cmdOpt.rawValue.yellow + desc.red)
}

func help_green(_ desc: String, cmdOpt: CmdOpt = .opt) -> ArgumentHelp {
    return ArgumentHelp(stringLiteral: cmdOpt.rawValue.blue + desc.green)
}


func conf(_ desc:  String, cmdOpt: CmdOpt = .cmd) -> CommandConfiguration {
    return CommandConfiguration(abstract: NL + TWO_TABS + cmdOpt.rawValue.green + desc.blue)
}

func conf(_ desc:  String, cmdOpt: CmdOpt = .cmd, subcommands: [ParsableCommand.Type]) -> CommandConfiguration {
    return CommandConfiguration(abstract: NL + TWO_TABS + cmdOpt.rawValue.green + desc.blue, subcommands: subcommands)
}


func conf_disc(_ desc:  String, disc: String, cmdOpt: CmdOpt = .cmd) -> CommandConfiguration {
    return CommandConfiguration(abstract: NL + TWO_TABS + cmdOpt.rawValue.green + desc.blue, discussion: disc)
}


enum CmdOpt: String {
   case opt = "⌥ "
   case cmd = "⌘ "
}
