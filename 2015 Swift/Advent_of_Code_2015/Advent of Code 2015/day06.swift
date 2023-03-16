import Foundation

@frozen enum Command {
    case turnOn
    case turnOff
    case toggle
}

private func splitCommand(_ string: String) -> (Command, String) {
    if string.starts(with: "turn on") {
        let substring = string.substring(from: string.index(string.startIndex, offsetBy: "turn on".count + 1))
        return (Command.turnOn, substring)
    }
    if string.starts(with: "turn off") {
        let substring = string.substring(from: string.index(string.startIndex, offsetBy: "turn off".count + 1))
        return (Command.turnOff, substring)
    }
    assert(string.starts(with: "toggle"), "unknown prefix in string \(string)")
    let substring = string.substring(from: string.index(string.startIndex, offsetBy: "toggle".count + 1))
    return (Command.toggle, substring)
}

private func part1() {

    print("Part 1\n")

    var lights = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)

    for i in 0..<lights.count {
        for j in 0..<lights[i].count {

        }
    }

    print("TODO.\n")

}

private func part2() {

    print("Part 2\n")

    print("TODO\n")

}

public func day06() throws {

    printAOCDayHeader(day: 6, title: "Probably a Fire Hazard")

    let string = try loadAOCData(day: 6)

    for line in string.split(whereSeparator: \.isNewline) {
        print(line, splitCommand(String(line)))
    }

    part1()
    part2()

}
