import Foundation

private func parseData(string: String) -> [(Int, Int, Int)] {
    let lines = string.split(whereSeparator: \.isNewline)
    var data = [(Int, Int, Int)]()
    for line in lines {
        let tokens = line.split(separator: "x")
        assert(tokens.count == 3, "expected 3 tokens")
        let l = Int(tokens[0])!
        let w = Int(tokens[1])!
        let h = Int(tokens[2])!
        data.append((l, w, h))
    }
    return data
}

private func part1(data: [(Int, Int, Int)], timeOnly: Bool = false) {

    if !timeOnly {
        print("Part 1\n")
    }

    var total_area = 0
    for (l, w, h) in data {
        let side1 = l * w
        let side2 = w * h
        let side3 = h * l
        let surface_area = 2 * side1 + 2 * side2 + 2 * side3
        let slack = min(side1, side2, side3)
        total_area += surface_area + slack
    }

    if !timeOnly {
        print("They should order \(total_area) square feet of wrapping paper.\n")
    }

}

private func part2(data: [(Int, Int, Int)], timeOnly: Bool = false) {

    if !timeOnly {
        print("Part 2\n")
    }

    var total_length = 0

    for (l, w, h) in data {

        let perimeter1 = 2*l + 2*w
        let perimeter2 = 2*w + 2*h
        let perimeter3 = 2*h + 2*l

        let ribbon_length = min(perimeter1, perimeter2, perimeter3)
        let bow_length = l * w * h

        total_length += ribbon_length + bow_length

    }

    if !timeOnly {
        print("They should order \(total_length) feet of ribbon.\n")
    }

}

public func day02(timeOnly: Bool = false) throws {

    if !timeOnly {
        printAOCDayHeader(day: 2, title: "I Was Told There Would Be No Math")
    }

    let string = try loadAOCData(day: 2)
    let data = parseData(string: string)

    part1(data: data, timeOnly: timeOnly)
    part2(data: data, timeOnly: timeOnly)

}
