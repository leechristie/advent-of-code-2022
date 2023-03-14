import Foundation

private func updateFloor(floor: Int, char: Character) -> Int {
    if char == "(" {
        return floor + 1
    }
    assert(char == ")", "unknown character \"\(char)\"!")
    return floor - 1
}

private func part1(string: String) {

    print("Part 1\n")

    var currentFloor = 0
    for char in string {
        currentFloor = updateFloor(floor: currentFloor, char: char)
    }

    print("The instructions end at floor \(currentFloor).\n")

}

private func part2(string: String) {

    print("Part 2\n")

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
    print("The instructions reach the basement at position \(found).")
    print()

}

public func day01() throws {

    printAOCDayHeader(day: 1, title: "Not Quite Lisp")

    let path = "\(PATH)/input01.txt"
    let string = try String(contentsOfFile: path, encoding: String.Encoding.utf8)

    part1(string: string)
    part2(string: string)

}