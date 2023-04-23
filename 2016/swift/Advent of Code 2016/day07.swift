//
//  day07.swift
//  Advent of Code 2016
//
//  Created by 0x1ac on 2023-04-17.
//

import Foundation

private func split(_ line: Substring) -> ([Character], [Character]) {
    
    var outside: [Character] = []
    var inside: [Character] = []
    
    var currentlyInside = false
    for char in line {
        if char == "[" {
            assert (!currentlyInside)
            outside.append(" ")
            currentlyInside = true
        } else if char == "]" {
            assert (currentlyInside)
            inside.append(" ")
            currentlyInside = false
        } else {
            if currentlyInside {
                inside.append(char)
            } else {
                outside.append(char)
            }
        }
    }
    
    return (inside, outside)
    
}

private func isAbba(_ chars: ArraySlice<Character>) -> Bool {
    return chars[chars.startIndex] == chars[chars.startIndex+3]
           && chars[chars.startIndex+1] == chars[chars.startIndex+2]
           && chars[chars.startIndex] != chars[chars.startIndex+1]
}

private func isAba(_ chars: ArraySlice<Character>) -> Bool {
    return chars[chars.startIndex] == chars[chars.startIndex+2]
           && chars[chars.startIndex+1] != " "
           && chars[chars.startIndex] != chars[chars.startIndex+1]
}

private func hasAbba(_ chars: [Character]) -> Bool {
    
    let start = 0
    let end = chars.count - 4
    
    for i in start...end {
        if isAbba(chars[i..<i+4]) {
            return true
        }
    }
    
    return false
    
}

private func containsBab(sequence: [Character], a: Character, b: Character) -> Bool {
    
    let start = 0
    let end = sequence.count - 3
    
    for i in start...end {
        if sequence[i] == b && sequence[i+1] == a && sequence[i+2] == b {
            return true
        }
    }

    return false
    
}

private func hasAbaWithMatchingBab(outside: [Character], inside: [Character]) -> Bool {
    
    let start = 0
    let end = outside.count - 3
    
    for i in start...end {
        if isAba(outside[i..<i+3]) {
            let aba = outside[i..<i+3]
            if containsBab(sequence: inside, a: aba[aba.startIndex], b: aba[aba.startIndex+1]) {
                return true
            }
        }
    }
    
    return false
    
}

private func part1(_ data: String) {
    
    print("Part 1: ", terminator: "")
    
    var count = 0
    data.lines { line in
        let (inside, outside) = split(Substring(line))
        if hasAbba(outside) && !hasAbba(inside) {
            count += 1
        }
    }

    print(count)
    
}

private func part2(_ data: String) {
    
    print("Part 2: ", terminator: "")
    
    var count = 0
    data.lines { line in
        let (inside, outside) = split(Substring(line))
        if hasAbaWithMatchingBab(outside: outside, inside: inside) {
            count += 1
        }
    }

    print(count)
    
}

func day07() throws {
    
    print("Day 7\n")
    
    let data = try loadData(forDay: 7)
    
    part1(data)
    part2(data)
    print()
    
}
