//
//  main.swift
//  Advent of Code 2017 Day 1
//
//  Created by 0x1ac on 2023-05-01.
//

import Foundation

func loadData(forDay day: Int) throws -> String {
    
    let fileName = day < 10 ? "input0\(day).txt" : "input\(day).txt"
    
    let path = "/Users/0x1ac/Developer/advent-of-code/2017/data/\(fileName)"
    
    let data = try String(contentsOfFile: path)
               .replacingOccurrences(of: "\n", with: "")
    
    return data
    
}

func toDigits(string: String) -> [Int] {
    
    var digits: [Int] = []

    for char in string {
        digits.append(Int(String(char))!)
    }
    
    return digits
    
}

func solve(_ digits: [Int], stepSize: Int) -> Int {
    
    var answer = 0
    
    for index in digits.indices {
        let nextIndex = (index + stepSize) % digits.count
        let digit = digits[index]
        if digit == digits[nextIndex] {
            answer += digit
        }
    }
    
    return answer
    
}

let data = try loadData(forDay: 1)

let digits = toDigits(string: data)

print("Part 1: \(solve(digits, stepSize: 1))")

print("Part 2: \(solve(digits, stepSize: digits.count / 2))")
