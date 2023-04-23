import Foundation

private func updateFloor(floor: Int, char: Character) -> Int {
    if char == "(" {
        return floor + 1
    }
    assert(char == ")", "unknown character \"\(char)\"!")
    return floor - 1
}

private func part1(string: String, timeOnly: Bool = false) {

    if !timeOnly {
        print("Part 1\n")
    }

    var currentFloor = 0
    for char in string {
        currentFloor = updateFloor(floor: currentFloor, char: char)
    }

    if !timeOnly {
        print("The instructions end at floor \(currentFloor).\n")
    }

}

private func part2(string: String, timeOnly: Bool = false) {

    if !timeOnly {
        print("Part 2\n")
    }

    var currentFloor = 0
    let targetFloor = -1
    var found = -1

    for (index, char) in string.enumerated() {
        currentFloor = updateFloor(floor: currentFloor, char: char)
        if currentFloor == targetFloor {
            found = index + 1
            break
        }
    }

    assert(found >= 0, "Error! Did not find the target floor!")
    if !timeOnly {
        print("The instructions reach the basement at position \(found).\n")
    }

}

public func day01(timeOnly: Bool = false) throws {

    if !timeOnly {
        printAOCDayHeader(day: 1, title: "Not Quite Lisp")
    }

    let string = try loadAOCData(day: 1)

    part1(string: string, timeOnly: timeOnly)
    part2(string: string, timeOnly: timeOnly)

}