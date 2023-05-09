//
//  main.swift
//  Advent of Code 2018 Day 3
//
//  Created by 0x1ac on 2023-05-09.
//

import Foundation

struct Position: Hashable {

    let x: Int
    let y: Int

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    init(fromXYTuple tuple: (Int, Int)) {
        self.x = tuple.0
        self.y = tuple.1
    }
    
}

struct Size: Hashable {

    let width: Int
    let height: Int

    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
    
    init(fromWidthHeightTuple tuple: (Int, Int)) {
        self.width = tuple.0
        self.height = tuple.1
    }
    
}

struct Claim {
    
    let ID: Int
    let position: Position
    let size: Size
    
    static func parseClaimID(_ string: Substring) -> Int {
        precondition(string.starts(with: "#"))
        return Int(string.replacing("#", with: ""))!
    }
    
    static func parsePair(_ string: Substring, withSeparator separator: Character) -> (Int, Int) {
        let split = string.split(separator: separator)
        precondition(split.count == 2)
        let x = Int(split[0])!
        let y = Int(split[1])!
        return (x, y)
    }
    
    init(ID: Int, position: Position, size: Size) {
        self.ID = ID
        self.position = position
        self.size = size
    }
    
    init(fromString string: Substring) {
        let split = string.replacing(" ", with: "")
            .split(separator: "@")
        precondition(split.count == 2)
        let split2 = split[1].split(separator: ":")
        precondition(split.count == 2)
        self.ID = Claim.parseClaimID(split[0])
        self.position = Position(fromXYTuple: Claim.parsePair(split2[0], withSeparator: ","))
        self.size = Size(fromWidthHeightTuple: Claim.parsePair(split2[1], withSeparator: "x"))
    }
    
    func forEachInch(_ callback: (Position) -> Void) {
        for y in self.position.y ..< self.position.y + self.size.height {
            for x in self.position.x ..< self.position.x + self.size.width {
                callback(Position(x: x, y: y))
            }
        }
    }
    
    static func forEachParsedClaim(inFile path: String, _ callback: (Claim) -> Void) throws {
        let data = try String(contentsOfFile: path)
        forEachParsedClaim(inString: data, callback)
    }
    
    static func forEachParsedClaim(inString data: String, _ callback: (Claim) -> Void) {
        for line in data.split(whereSeparator: \.isNewline) {
            callback(Claim(fromString: line))
        }
    }
    
}

let path = "/Users/0x1ac/Developer/advent-of-code/2018/data/input03.txt"

var claimed: Set<Position> = []
var disputed: Set<Position> = []

try Claim.forEachParsedClaim(inFile: path) { claim in
    
    claim.forEachInch { position in
        
        if claimed.contains(position) {
            disputed.insert(position)
        } else {
            claimed.insert(position)
        }
        
    }

}

print("Part 1: \(disputed.count)")

try Claim.forEachParsedClaim(inFile: path) { claim in
    
    var hasDisputed = false
    
    claim.forEachInch { position in
        
        if disputed.contains(position) {
            hasDisputed = true
        }
        
    }
    
    if !hasDisputed {
        print("Part 2: \(claim.ID)")
    }

}

