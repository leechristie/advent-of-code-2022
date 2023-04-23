//
//  day02.swift
//  Advent of Code 2016
//
//  Created by 0x1ac on 2023-04-15.
//

import Foundation

private struct KeyPadLayout {
    
    let graph: [Character:[Direction:Character]]
    
    private static func decodePositions(_ encoded: [String]) -> ([Position:Character],
                                                                 [Character:Position]) {
        var posToChar = [Position:Character]()
        var charToPos = [Character:Position]()
        for (r, row) in encoded.enumerated() {
            for (c, character) in row.enumerated() {
                if character != " " {
                    let position = Position(x: c, y: r)
                    posToChar[position] = character
                    charToPos[character] = position
                }
            }
        }
        return (posToChar, charToPos)
    }
    
    private static func convertToGraph(posToChar: [Position:Character],
                                       charToPos: [Character:Position]) -> [Character:[Direction:Character]] {
        var graph = [Character:[Direction:Character]]()
        for (character, position) in charToPos {
            graph[character] = Dictionary()
            for direction in Direction.allCases {
                var neighbourPosition = position
                neighbourPosition.move(facing: direction)
                if let neighbour = posToChar[neighbourPosition] {
                    graph[character]![direction] = neighbour
                }
            }
        }
        return graph
    }
    
    init(_ encoded: [String]) {
        let (posToChar, charToPos) = KeyPadLayout.decodePositions(encoded)
        self.graph = KeyPadLayout.convertToGraph(posToChar: posToChar,
                                                 charToPos: charToPos)
    }
    
    func move(from currentCharacter: Character, by direction: Direction) -> Character {
        if let newCharacter = self.graph[currentCharacter]![direction] {
            return newCharacter
        } else {
            return currentCharacter
        }
    }
    
}

private func solve(_ data: String, layout: KeyPadLayout, start: Character) -> String {
    
    var current = start
    var answer = ""
    
    for char in data {
        if let direction = Direction(rawValue: char) {
            current = layout.move(from: current, by: direction)
        } else {
            assert(char == "\n")
            answer = answer + String(current)
        }
    }
    
    return answer
    
}

private func part1(_ data: String) -> String {
    
    let layout = KeyPadLayout([
        "123",
        "456",
        "789"
    ])
    
    return solve(data, layout: layout, start: "5")
    
}

private func part2(_ data: String) -> String {
    
    let layout = KeyPadLayout([
        "  1",
        " 234",
        "56789",
        " ABC",
        "  D"
    ])
    
    return solve(data, layout: layout, start: "5")
    
}

func day02() throws {
    
    print("Day 2\n")
    
    let data = try loadData(forDay: 2)
    
    print("Part 1: \(part1(data))")
    print("Part 2: \(part2(data))")
    print()
    
}
