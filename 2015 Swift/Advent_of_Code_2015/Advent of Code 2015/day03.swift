import Foundation

private func part1(string: String) {

    print("Part 1\n")

    var visited = Set<Point>()

    var point = Point(x: 0, y: 0)
    for char in string {
        point = addArrowToPoint(point: point, char: char)
        visited.insert(point)
    }

    print("\(visited.count) houses receive at least 1 present.\n")

}

private func part2(string: String) {

    print("Part 2\n")

    var visited = Set<Point>()

    var point1 = Point(x: 0, y: 0)
    var point2 = Point(x: 0, y: 0)
    var even = false
    for char in string {
        if even {
            point1 = addArrowToPoint(point: point1, char: char)
            visited.insert(point1)
        } else {
            point2 = addArrowToPoint(point: point2, char: char)
            visited.insert(point2)
        }
        even = !even
    }

    print("\(visited.count) houses receive at least 1 present.\n")

}

public func day03() throws {

    printAOCDayHeader(day: 3, title: "Perfectly Spherical Houses in a Vacuum")

    let string = try loadAOCData(day: 3)

    part1(string: string)
    part2(string: string)

}
