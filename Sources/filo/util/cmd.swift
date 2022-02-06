
import Foundation

func lineUp() {
    let cmd = Process()
    cmd.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    cmd.arguments = ["tput", "cuu1"]
    do{
        try cmd.run()
    } catch {
        //TODO: write catch for executing command}
    }
}

func cmd(_ args: [String], after: () -> Void) {
     let cmd = Process()
    cmd.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    cmd.arguments = args
    do{
        try cmd.run()
        after()
    } catch {
        //TODO: write catch for executing command}
    }

}
