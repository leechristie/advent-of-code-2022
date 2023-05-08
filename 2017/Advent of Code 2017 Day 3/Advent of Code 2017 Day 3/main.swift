//
//  main.swift
//  Advent of Code 2017 Day 3
//
//  Created by 0x1ac on 2023-05-04.
//

import Foundation

func locateRing(containingAccessPort accessPort: Int)
        -> (Int, (Int, Int), (Int, Int, Int, Int)) {
    precondition(accessPort >= 2)
    var num = 2
    var currentRingSize = 8
    var x = 1
    var toFirstCorner = 1
    var betweenCorners = 2
    while accessPort >= num + currentRingSize {
        num += currentRingSize
        currentRingSize += 8
        x += 1
        toFirstCorner += 2
        betweenCorners = toFirstCorner + 1
    }
    let y = x - 1
    let corner1 = num + toFirstCorner
    let corner2 = corner1 + betweenCorners
    let corner3 = corner2 + betweenCorners
    let terminator = corner3 + betweenCorners
    return (num, (x, y), (corner1, corner2, corner3, terminator))
}

func location(ofAccessPort accessPort: Int) -> (Int, Int) {
    precondition(accessPort >= 1)
    if accessPort == 1 {
        return (0, 0)
    }
    let (first, (firstX, firstY), (corner1, corner2, corner3, terminator))
            = locateRing(containingAccessPort: accessPort)
    var current = first
    var x = firstX
    var y = firstY
    while current < corner1 {
        if current == accessPort {
            return (x, y)
        }
        y -= 1
        current += 1
    }
    while current < corner2 {
        if current == accessPort {
            return (x, y)
        }
        x -= 1
        current += 1
    }
    while current < corner3 {
        if current == accessPort {
            return (x, y)
        }
        y += 1
        current += 1
    }
    while current < terminator {
        if current == accessPort {
            return (x, y)
        }
        x += 1
        current += 1
    }
    assert(current == accessPort)
    return (x, y)
}

func numSteps(toAccessPort accessPort: Int) -> Int {
    precondition(accessPort >= 1)
    if accessPort == 1 {
        return 0
    }
    let (x, y) = location(ofAccessPort: accessPort)
    return abs(x) + abs(y)
}

struct Point: Hashable {
    let x: Int
    let y: Int
    func toTuple() -> (Int, Int) {
        return (x, y)
    }
    static func fromTuple(tuple: (Int, Int)) -> Point {
        return Point(x: tuple.0, y: tuple.1)
    }
    func neighbours() -> [Point] {
        return [
            Point(x: x-1, y: y-1),
            Point(x: x-1, y: y),
            Point(x: x-1, y: y+1),
            Point(x: x, y: y-1),
            Point(x: x, y: y+1),
            Point(x: x+1, y: y-1),
            Point(x: x+1, y: y),
            Point(x: x+1, y: y+1),
        ]
    }
}

func solvePart2(input: Int) -> Int {
    
    var locationToValue: [Point:Int] = [:]
    
    locationToValue[Point.fromTuple(tuple: location(ofAccessPort: 1))] = 1
    
    for accessPort in 2... {
        var value = 0
        let position = Point.fromTuple(tuple: location(ofAccessPort: accessPort))
        for neighbour in position.neighbours() {
            if let neighbourValue = locationToValue[neighbour] {
                value += neighbourValue
            }
        }
        locationToValue[position] = value
        if value > input {
            return value
        }
    }
    
    assert(false)
    
}

assert(numSteps(toAccessPort: 1) == 0)
assert(numSteps(toAccessPort: 12) == 3)
assert(numSteps(toAccessPort: 23) == 2)
assert(numSteps(toAccessPort: 1024) == 31)

let input = 312051

print("Part 1: \(numSteps(toAccessPort: input))")

print("Part 2: \(solvePart2(input: input))")
