import Foundation

@frozen enum Command {
    case turnOn
    case turnOff
    case toggle
}

struct Point2D: CustomStringConvertible {
    var description: String {
        "(\(self.x), \(self.y))"
    }
    let x: Int
    let y: Int
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

struct Rect2D: CustomStringConvertible {
    var description: String {
        "\(self.topLeft) to \(self.bottomRight)"
    }
    let topLeft: Point2D
    let bottomRight: Point2D
    init(topLeft: Point2D, bottomRight: Point2D) {
        self.topLeft = topLeft
        self.bottomRight = bottomRight
    }
}

private func toPoint2D(_ string: String) -> Point2D {
    let tokens: [Substring] = string.split(separator: ",")
    precondition(tokens.count == 2)
    let x: Int = Int(tokens[0])!
    let y: Int = Int(tokens[1])!
    return Point2D(x: x, y: y)
}

private func toRect2D(_ string: String) -> Rect2D {
    let tokens: [Substring] = string.split(separator: " ")
    precondition(tokens.count == 3)
    precondition(tokens[1] == "through")
    let topLeft = toPoint2D(String(tokens[0]))
    let bottomRight = toPoint2D(String(tokens[2]))
    return Rect2D(topLeft: topLeft, bottomRight: bottomRight)
}

private func splitCommand(_ string: String) -> (Command, Rect2D) {
    if string.starts(with: "turn on") {
        let substring = string.substring(from: string.index(string.startIndex, offsetBy: "turn on".count + 1))
        return (Command.turnOn, toRect2D(substring))
    }
    if string.starts(with: "turn off") {
        let substring = string.substring(from: string.index(string.startIndex, offsetBy: "turn off".count + 1))
        return (Command.turnOff, toRect2D(substring))
    }
    assert(string.starts(with: "toggle"), "unknown prefix in string \(string)")
    let substring = string.substring(from: string.index(string.startIndex, offsetBy: "toggle".count + 1))
    return (Command.toggle, toRect2D(substring))
}

private func part1(data: [(Command, Rect2D)], timeOnly: Bool = false) throws {

    if !timeOnly {
        print("Part 1\n")
    }

    var lights = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)

    for (command, rect) in data {
        for y in rect.topLeft.y...rect.bottomRight.y {
            for x in rect.topLeft.x...rect.bottomRight.x {
                if command == Command.turnOff {
                    lights[y][x] = 0
                } else if command == Command.turnOn {
                    lights[y][x] = 1
                } else if command == Command.toggle {
                    lights[y][x] = 1 - lights[y][x]
                } else {
                    assert(false)
                }
            }
        }
    }

    var count = 0
    for y in 0..<lights.count {
        for x in 0..<lights[y].count {
            count += lights[y][x]
        }
    }

    if !timeOnly {
        print("The number of lights on is \(count).")
        print()
    }

}

private func part2(data: [(Command, Rect2D)], timeOnly: Bool = false) throws {

    if !timeOnly {
        print("Part 2\n")
    }

    var lights = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)

    for (command, rect) in data {
        for y in rect.topLeft.y...rect.bottomRight.y {
            for x in rect.topLeft.x...rect.bottomRight.x {
                if command == Command.turnOff {
                    lights[y][x] -= 1
                    if lights[y][x] < 0 {
                        lights[y][x] = 0
                    }
                } else if command == Command.turnOn {
                    lights[y][x] += 1
                } else if command == Command.toggle {
                    lights[y][x] += 2
                } else {
                    assert(false)
                }
            }
        }
    }

    var count = 0
    for y in 0..<lights.count {
        for x in 0..<lights[y].count {
            count += lights[y][x]
        }
    }

    if !timeOnly {
        print("The number of lights on this time is \(count).")
        print()
    }

}

public func day06(timeOnly: Bool = false) throws {

    if !timeOnly {
        printAOCDayHeader(day: 6, title: "Probably a Fire Hazard")
    }

    let string = try loadAOCData(day: 6)
    var data = [(Command, Rect2D)]()
    for line in string.split(whereSeparator: \.isNewline) {
        data.append(splitCommand(String(line)))
    }

    try part1(data: data, timeOnly: timeOnly)
    try part2(data: data, timeOnly: timeOnly)

}
