//
//  day03.swift
//  Advent of Code 2016
//
//  Created by 0x1ac on 2023-04-15.
//

import Foundation

private func tokenize(_ line: Substring) -> (Int, Int, Int) {
    
    var result: [Int] = []
    
    for token in line.split(separator: " ") {
        if let value = Int(token) {
            result.append(value)
        }
    }
    
    assert(result.count == 3)
    return (result[0], result[1], result[2])
    
}

private func isTrangle(_ side1: Int, _ side2: Int, _ side3: Int) -> Bool {
    if side1 + side2 <= side3 {
        return false
    }
    if side2 + side3 <= side1 {
        return false
    }
    if side1 + side3 <= side2 {
        return false
    }
    return true
}

private func forEachRow(_ data: String, callback: (Int, Int, Int) -> Void) {
    for line in data.split(separator: "\n") {
        let (side1, side2, side3) = tokenize(line)
        callback(side1, side2, side3)
    }
}

private func forEachColumn(_ data: String, callback: (Int, Int, Int) -> Void) {
    var queue: [(Int, Int, Int)] = []
    for line in data.split(separator: "\n") {
        queue.append(tokenize(line))
        if queue.count == 3 {
            let (tri1side1, tri2side1, tri3side1) = queue[0]
            let (tri1side2, tri2side2, tri3side2) = queue[1]
            let (tri1side3, tri2side3, tri3side3) = queue[2]
            queue = []
            callback(tri1side1, tri1side2, tri1side3)
            callback(tri2side1, tri2side2, tri2side3)
            callback(tri3side1, tri3side2, tri3side3)
        }
    }
    assert(queue.isEmpty)
}

private func solve(_ data: String, _ iterator: (String, (Int, Int, Int) -> Void) -> Void) -> Int {
    var answer = 0
    iterator(data) { side1, side2, side3 in
        if isTrangle(side1, side2, side3) {
            answer += 1
        }
    }
    return answer
}

private func part1(_ data: String) -> Int {
    return solve(data, forEachRow)
}

private func part2(_ data: String) -> Int {
    return solve(data, forEachColumn)
}

func day03() throws {
    
    print("Day 3\n")
    
    let data = try loadData(forDay: 3)
    
    print("Part 1: \(part1(data))")
    print("Part 2: \(part2(data))")
    print()
    
}
