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

public func runSolution(day: Int) throws -> Bool {
    switch day {
    case 1:
        try day01()
    case 2:
        try day02()
    default:
        print("No solution file in Swift for 2015 Day \(day) yet.")
        return false
    }
    return true
}
