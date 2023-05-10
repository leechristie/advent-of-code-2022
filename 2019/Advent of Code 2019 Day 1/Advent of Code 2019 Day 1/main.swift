//
//  main.swift
//  Advent of Code 2019 Day 1
//
//  Created by 0x1ac on 2023-05-10.
//

import Foundation

let path = "/Users/0x1ac/Developer/advent-of-code/2019/data/input01.txt"
let data = try String(contentsOfFile: path)

func calcFuel(mass: Int) -> Int {
    let fuel = (mass / 3) - 2
    return fuel
}

var totalFuel = 0
for line in data.split(whereSeparator: \.isNewline) {
    let mass = Int(line)!
    totalFuel += calcFuel(mass: mass)
}

print("Part 1: \(totalFuel)")

func calcFuel2(mass: Int) -> Int {
    var rv = 0
    var mass = mass
    while mass > 0 {
        let currentFuel = (mass / 3) - 2
        if currentFuel > 0 {
            rv += currentFuel
            mass = currentFuel
        } else {
            break
        }
    }
    return rv
}

var totalFuel2 = 0
for line in data.split(whereSeparator: \.isNewline) {
    let mass = Int(line)!
    totalFuel2 += calcFuel2(mass: mass)
}

print("Part 2: \(totalFuel2)")
