//
// Created by 0x1ac on 2023-03-21.
//

import Foundation

func forEachAdjacentPair(arr: [Int], callback: ((Int, Int)) -> ()) {
    for i in 0...arr.count-2 {
        callback((arr[i], arr[i + 1]))
    }
}


private func forEachEvaluatedPermutation(matrix: [[Int]], callback: ([Int], Int) -> ()) {

    let n = matrix.count
    forEachPermutation(n: n, callback: { (perm) -> () in

        var total = 0
        forEachAdjacentPair(arr: perm, callback: { (indices) -> () in
            let fromIndex = indices.0
            let toIndex = indices.1
            total += matrix[fromIndex][toIndex]
        })

        callback(perm, total)

    })

}

private func part1(matrix: [[Int]], timeOnly: Bool) throws {

    if !timeOnly {
        print("Part 1\n")
    }

    var minimum: Int?
    forEachEvaluatedPermutation(matrix: matrix, callback: { (permutation, totalCost) -> () in

        minimum = minimum.map { min($0, totalCost) } ?? totalCost

//        if minimum == nil || totalCost < minimum! {
//            minimum = totalCost
//        }

//        if let unwrappedMinimum = minimum {
//            if totalCost < unwrappedMinimum {
//                minimum = totalCost
//            }
//        } else {
//            minimum = totalCost
//        }

    })

    if !timeOnly {
        print("The best distance is \(minimum!).\n")
    }

}

private func part2(matrix: [[Int]], timeOnly: Bool) throws {

    if !timeOnly {
        print("Part 2\n")
    }

    var maximum: Int?
    forEachEvaluatedPermutation(matrix: matrix, callback: { (permutation, totalCost) -> () in

        maximum = maximum.map { max($0, totalCost) } ?? totalCost

//        if maximum == nil || totalCost > maximum! {
//            maximum = totalCost
//        }

//        if let unwrappedMaximum = maximum {
//            if totalCost > unwrappedMaximum {
//                maximum = totalCost
//            }
//        } else {
//            maximum = totalCost
//        }

    })

    if !timeOnly {
        print("The worst distance is \(maximum!).\n")
    }
}

private func getNames(string: String) -> [String] {

    var names = [String]()
    for line in string.split(whereSeparator: \.isNewline) {

        let tokens = line.split(separator: " ")
        assert(tokens.count == 5)
        assert(tokens[1] == "to", "tokens[1] = \(tokens[1]), expected \"to\"")
        assert(tokens[3] == "=", "tokens[3] = \(tokens[3]), expected \"=\"")

        let from = String(tokens[0])
        let to = String(tokens[2])

        if !names.contains(from) {
            names.append(from)
        }
        if !names.contains(to) {
            names.append(to)
        }

    }

    return names

}

private func getDistanceMatrix(string: String, names: [String]) -> [[Int]] {

    var rv = Array(repeating: Array(repeating: -1, count: names.count), count: names.count)
    for line in string.split(whereSeparator: \.isNewline) {

        let tokens = line.split(separator: " ")
        assert(tokens.count == 5)
        assert(tokens[1] == "to", "tokens[1] = \(tokens[1]), expected \"to\"")
        assert(tokens[3] == "=", "tokens[3] = \(tokens[3]), expected \"=\"")

        let from = String(tokens[0])
        let to = String(tokens[2])
        let cost = Int(tokens[4])!

        let fromIndex = names.index(of: from)!
        let toIndex = names.index(of: to)!
        precondition(rv[fromIndex][toIndex] == -1, "rv[\(fromIndex)][\(toIndex)] was set twice")
        rv[fromIndex][toIndex] = cost
        precondition(rv[toIndex][fromIndex] == -1, "rv[\(toIndex)][\(fromIndex)] was set twice")
        rv[toIndex][fromIndex] = cost

    }

    for index in 0..<names.count {
        rv[index][index] = 0
    }

    for i in 0..<rv.count {
        for j in 0..<rv[i].count {
            precondition(rv[i][j] >= 0, "rv[\(i)][\(j)] = \(rv[i][j]), expected >= 0")
        }
    }

    return rv

}

public func day09(timeOnly: Bool = false) throws {

    if !timeOnly {
        printAOCDayHeader(day: 9, title: "All in a Single Night")
    }

    let string = try loadAOCData(day: 9)
    let names = getNames(string: string)
    let matrix = getDistanceMatrix(string: string, names: names)

    try part1(matrix: matrix, timeOnly: timeOnly)
    try part2(matrix: matrix, timeOnly: timeOnly)

}
