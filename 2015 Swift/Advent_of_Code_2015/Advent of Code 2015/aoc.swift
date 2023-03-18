let PATH = "/Users/0x1ac/GitHub/leechristie/advent-of-code/2015/data"

public func printAOCHeader(year: Int) {

    print("Advent of Code \(year)")
    print("Solution by Lee A. Christie")
    print()

}

public func printAOCDayHeader(day: Int, title: String) {

    print("Day \(day): \(title)")
    print()

}

public func runSolution(day: Int, timeOnly: Bool = false) throws -> Bool {
    switch day {
    case 1:
        try day01(timeOnly: timeOnly)
    case 2:
        try day02(timeOnly: timeOnly)
    case 3:
        try day03(timeOnly: timeOnly)
    case 4:
        try day04(timeOnly: timeOnly)
    case 5:
        try day05(timeOnly: timeOnly)
    case 6:
        try day06(timeOnly: timeOnly)  // unfinished swift conversion
    case 21:
        try day21(timeOnly: timeOnly)
    default:
        return false
    }
    return true
}

public struct Point: Hashable {
    let x: Int
    let y: Int
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

public func addArrowToPoint(point: Point, char: Character) -> Point {
    switch char {
    case "^":
        return Point(x: point.x, y: point.y + 1)
    case "v":
        return Point(x: point.x, y: point.y - 1)
    case "<":
        return Point(x: point.x - 1, y: point.y)
    case ">":
        return Point(x: point.x + 1, y: point.y)
    default:
        return point
    }
}

public func loadAOCData(day: Int) throws -> String {
    assert(day >= 1 && day <= 25, "day = \(day), expected 1 to 25")
    if day < 10 {
        return try String(contentsOfFile: "\(PATH)/input0\(day).txt", encoding: String.Encoding.utf8)
    } else {
        return try String(contentsOfFile: "\(PATH)/input\(day).txt", encoding: String.Encoding.utf8)
    }
}

enum AOCError: Error {
    case unimplemented
    case wrongSolution
}
