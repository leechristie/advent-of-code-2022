import Foundation

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
        try day06(timeOnly: timeOnly)
    case 9:
        try day09(timeOnly: timeOnly)
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

class IntMatcher {

    let regex: NSRegularExpression
    let count: Int

    init(pattern: String) {
        regex = try! NSRegularExpression(pattern: pattern.replacingOccurrences(of: "*", with: "(\\d+)"), options: [])
        count = pattern.filter { $0 == "*" }.count
    }

    func match(string: String) -> [Int] {
        let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
        assert(matches.count == 1)
        var rv = [Int]()
        for index in 1...count {
            let match: NSRange = matches[0].range(at: index)
            let range = Range(match, in: string)!
            rv.append(Int(string[range])!)
        }
        return rv
    }

}

// testing matcher
//print(IntMatcher(pattern: "*,* through *,*")
//      .match(string: "68,358 through 857,453"))

private func withoutIndex(arr: [Int], index: Int) -> [Int] {
    var rv = [Int]()
    for i in 0..<arr.count {
        if i != index {
            rv.append(arr[i])
        }
    }
    return rv
}

private func permSub(visited: [Int], notVisited: [Int], callback: ([Int]) -> ()) {
    if notVisited.count < 1 {
        callback(visited)
    }
    for index in 0..<notVisited.count {
        let newVisited = visited + [notVisited[index]]
        let newNotVisited = withoutIndex(arr: notVisited, index: index)
        permSub(visited: newVisited, notVisited: newNotVisited, callback: callback)
    }
}

public func forEachPermutation(n: Int, callback: ([Int]) -> ()) {
    var set = [Int]()
    for i in 0..<n {
        set.append(i)
    }
    permSub(visited: [Int](), notVisited: set, callback: callback)
}
