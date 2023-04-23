//
//  aoc.swift
//  Advent of Code 2016
//
//  Created by 0x1ac on 2023-04-15.
//

import Foundation

func loadData(forDay day: Int, test: Bool = false) throws -> String {
    
    let dataPath = "/Users/0x1ac/Developer/advent-of-code-2016/data/"
    
    let namePrefix = test ? "test" : "input"
    
    let fileName = day < 10 ? "\(namePrefix)0\(day).txt" : "\(namePrefix)\(day).txt"
    
    let data = try String(contentsOfFile: dataPath + fileName,
                          encoding: .utf8)
    
    return data
    
}

enum TurnDirection: Character, Hashable, CaseIterable {
    case left = "L"
    case right = "R"
}

enum Direction: Character, Hashable, CaseIterable {
    
    case up = "U"
    case right = "R"
    case down = "D"
    case left = "L"
    
    func turn(direction turn: TurnDirection) -> Direction {
        switch turn {
        case .left:
            switch self {
            case .up:
                return .left
            case .right:
                return .up
            case .down:
                return .right
            case .left:
                return .down
            }
        case .right:
            switch self {
            case .up:
                return .right
            case .right:
                return .down
            case .down:
                return .left
            case .left:
                return .up
            }
        }
    }
    
}

struct Position: Hashable {
    
    var x: Int
    var y: Int
    
    var manhattan: Int {
        return abs(self.x) + abs(self.y)
    }
    
    mutating func move(facing direction: Direction, distance: Int = 1) {
        switch direction {
        case .up:
            self.y -= distance
        case .right:
            self.x += distance
        case .down:
            self.y += distance
        case .left:
            self.x -= distance
        }
    }
    
}

enum Signal {
    case Continue
    case Break
}

extension String {
    func lines(_ callback: (Substring) -> Void) {
        for line in self.split(separator: "\n") {
            callback(line)
        }
    }
}

struct Counter<Key> where Key: Hashable {
    
    var counts: [Key:Int] = Dictionary()
    
    mutating func increment(_ key: Key) {
        if let current = self.counts[key] {
            self.counts[key] = current + 1
        } else {
            self.counts[key] = 1
        }
    }
    
    var uniqueMostCommon: Key? {
        var highestKey: Key?
        var highestValue: Int?
        var highestFrequency: Int = 0
        for (key, value) in self.counts {
            if let highestValueCurrent = highestValue {
                if value == highestValueCurrent {
                     highestFrequency += 1
                } else if value > highestValueCurrent {
                    highestKey = key
                    highestValue = value
                    highestFrequency = 1
                }
            } else {
                highestKey = key
                highestValue = value
                highestFrequency = 1
            }
        }
        if highestFrequency == 1 {
            return highestKey
        }
        return nil
    }
    
    var uniqueLeastCommon: Key? {
        var lowestKey: Key?
        var lowestValue: Int?
        var lowestFrequency: Int = 0
        for (key, value) in self.counts {
            if let lowestValueCurrent = lowestValue {
                if value == lowestValueCurrent {
                    lowestFrequency += 1
                } else if value < lowestValueCurrent {
                    lowestKey = key
                    lowestValue = value
                    lowestFrequency = 1
                }
            } else {
                lowestKey = key
                lowestValue = value
                lowestFrequency = 1
            }
        }
        if lowestFrequency == 1 {
            return lowestKey
        }
        return nil
    }
    
}
