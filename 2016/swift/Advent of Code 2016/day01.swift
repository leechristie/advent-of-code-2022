//
//  day01.swift
//  Advent of Code 2016
//
//  Created by 0x1ac on 2023-04-15.
//

import Foundation

private func forEachInstruction(from data: String, callback: (TurnDirection, Int) -> Signal) {
    
    let tokens = data.replacingOccurrences(of: ",", with: "")
                     .replacingOccurrences(of: "\n", with: "")
                     .split(separator: " ")
    
    for token in tokens {
        let turnDirection = TurnDirection(rawValue: token[token.index(token.startIndex, offsetBy: 0)])!
        let travelDistance = Int(token[token.index(token.startIndex, offsetBy: 1)...])!
        if callback(turnDirection, travelDistance) == .Break {
            return
        }
    }
    
}

private func part1(_ data: String) -> Int {
    
    var facing = Direction.up
    var position = Position(x: 0, y: 0)
    
    print()
    
    forEachInstruction(from: data) { turnDirection, travelDistance in
        facing = facing.turn(direction: turnDirection)
        position.move(facing: facing, distance: travelDistance)
        return .Continue
    }
    
    return position.manhattan
    
}

private func part2(_ data: String) -> Int {
    
    var facing = Direction.up
    var position = Position(x: 0, y: 0)
    
    var log: Set<Position> = [position]
    var result: Int? = nil
    
    forEachInstruction(from: data) { turnDirection, travelDistance in
        facing = facing.turn(direction: turnDirection)
        for _ in 0..<travelDistance {
            position.move(facing: facing)
            if log.contains(position) {
                result = position.manhattan
                return .Break
            }
            log.insert(position)
        }
        return .Continue
    }
    
    return result!
    
}

func day01() throws {
    
    print("Day 1\n")
    
    let data = try loadData(forDay: 1)
    
    print("Part 1: \(part1(data))")
    print("Part 2: \(part2(data))")
    print()
    
}
