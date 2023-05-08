//
//  main.swift
//  Advent of Code 2017 Day 2
//
//  Created by 0x1ac on 2023-05-03.
//

import Foundation

func updateMinMax(minimum: inout Int?,
                  maximum: inout Int?,
                  value: Int) {
    if minimum == nil || value < minimum! {
        minimum = value
    }
    if maximum == nil || value > maximum! {
        maximum = value
    }
}

func rowMinMax(row: Substring) -> (Int, Int)? {
    var minimum: Int? = nil
    var maximum: Int? = nil
    for cell in row.split(separator: "\t") {
        updateMinMax(minimum: &minimum,
                     maximum: &maximum,
                     value: Int(cell)!)
    }
    guard let minimum, let maximum else {
        return nil
    }
    return (minimum, maximum)
}

func rowRange(row: Substring) -> Int {
    if let (minimum, maximum) = rowMinMax(row: row) {
        return maximum - minimum
    }
    return 0
}

func solvePart1(data: String) -> Int {
    var checksum = 0
    for row in data.split(separator: "\n") {
        checksum += rowRange(row: row)
    }
    return checksum
}

func evensInRow(row: Substring) -> [Int] {
    var rv: Set<Int> = []
    for cell in row.split(separator: "\t") {
        let value = Int(cell)!
        if value % 2 == 0 {
            rv.insert(value)
        }
    }
    return Array(rv)
}

func onlyTwoEvenlyDivisableInRow(row: Substring) -> (Int, Int)? {
    for cell1 in row.split(separator: "\t") {
        let value1 = Int(cell1)!
        for cell2 in row.split(separator: "\t") {
            let value2 = Int(cell2)!
            if value1 != value2 {
                if value1 % value2 == 0 || value2 % value1 == 0 {
                    if value1 < value2 {
                        return (value1, value2)
                    } else {
                        return (value2, value1)
                    }
                }
            }
        }
    }
    return nil
}

func evenDiffRange(row: Substring) -> Int {
    let (minimum, maximum) = onlyTwoEvenlyDivisableInRow(row: row)!
    return maximum / minimum
}

func solvePart2(data: String) -> Int {
    var checksum = 0
    for row in data.split(separator: "\n") {
        checksum += evenDiffRange(row: row)
    }
    return checksum
}

let path = "/Users/0x1ac/Developer/advent-of-code/2017/data/input02.txt"
let data = try String(contentsOfFile: path)

var part1 = solvePart1(data: data)
print("Part 1: \(part1)")

var part2 = solvePart2(data: data)
print("Part 2: \(part2)")
