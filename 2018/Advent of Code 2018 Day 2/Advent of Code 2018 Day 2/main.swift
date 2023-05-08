//
//  main.swift
//  Advent of Code 2018 Day 2
//
//  Created by 0x1ac on 2023-05-08.
//

import Foundation

func charSet(line: Substring) -> Set<Character> {
    
    var chars: Set<Character> = []
    
    for char in line {
        chars.insert(char)
    }
    
    return chars
    
}

func charCount(line: Substring, char: Character) -> Int {
    
    var rv = 0
    
    for stringChar in line {
        
        if char == stringChar {
            rv += 1
        }
        
    }
    
    return rv
    
}

func score(line: Substring) -> (Int, Int) {
    
    var has2 = false
    var has3 = false
    
    for char in charSet(line: line) {
        
        let charCount = charCount(line: line, char: char)
        
        if charCount == 2 {
            has2 = true
        }
        
        if charCount == 3 {
            has3 = true
        }
        
    }
    
    return (has2 ? 1 : 0, has3 ? 1 : 0)
    
}

let path = "/Users/0x1ac/Developer/advent-of-code/2018/data/input02.txt"
let data = try String(contentsOfFile: path)

var answer1: Int = 0
let time1 = ContinuousClock().measure {
        
    var answer2 = 0
    var answer3 = 0
    
    for line in data.split(separator: "\n") {
        
        let (score2, score3) = score(line: line)
        
        answer2 += score2
        answer3 += score3
        
    }
    
    answer1 = answer2 * answer3
    
}

print("Part 1: \(answer1) (\(time1))")

func chars(x: Substring) -> [Character] {
    var chars: [Character] = []
    for char in x {
        chars.append(char)
    }
    return chars
}

func differences(a: Substring, b: Substring) -> Int {
    let chars1 = chars(x: a)
    let chars2 = chars(x: b)
    precondition(chars1.count == chars2.count)
    var rv = 0
    for i in chars1.indices {
        if chars1[i] != chars2[i] {
            rv += 1
        }
    }
    return rv
}

func common(a: Substring, b: Substring) -> String {
    var rv = ""
    let chars1 = chars(x: a)
    let chars2 = chars(x: b)
    precondition(chars1.count == chars2.count)
    for i in chars1.indices {
        if chars1[i] == chars2[i] {
            rv.append(chars1[i])
        }
    }
    return rv
}

var answer2: String = ""
let time2 = ContinuousClock().measure {
    
    for a in data.split(separator: "\n") {
        for b in data.split(separator: "\n") {
            if differences(a: a, b: b) == 1 {
                answer2 = common(a: a, b: b)
            }
        }
    }
    
}

print("Part 2: \(answer2) (\(time2))")
