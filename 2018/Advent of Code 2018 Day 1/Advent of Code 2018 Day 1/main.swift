//
//  main.swift
//  Advent of Code 2018 Day 1
//
//  Created by 0x1ac on 2023-05-07.
//

import Foundation

let data = try String(contentsOfFile: "/Users/0x1ac/Developer/advent-of-code/2018/data/input01.txt")

var frequency = 0
for line in data.split(separator: "\n") {
    let number: Int
    if line.starts(with: "+") {
        number = Int(line[line.index(after: line.startIndex)...])!
    } else {
        number = Int(line)!
    }
    frequency += number
}
print("Part 1: \(frequency)")

frequency = 0
var part2Answer: Int?
var history: Set<Int> = [0]
while part2Answer == nil {
    for line in data.split(separator: "\n") {
        let number: Int
        if line.starts(with: "+") {
            number = Int(line[line.index(after: line.startIndex)...])!
        } else {
            number = Int(line)!
        }
        frequency += number
        if part2Answer == nil && history.contains(frequency) {
            part2Answer = frequency
            break
        }
        history.insert(frequency)
    }
}
print("Part 2: \(part2Answer!)")
