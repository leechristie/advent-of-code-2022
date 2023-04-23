//
//  day04.swift
//  Advent of Code 2016
//
//  Created by 0x1ac on 2023-04-16.
//

import Foundation

private func split(string: String) -> (String, Int, String) {
    let tokens = string.split(separator: "[")
    assert(tokens.count == 2)
    let name = tokens[0]
    let code = tokens[1].split(separator: "]")[0]
    let tokens2 = name.split(separator: "-")
    let nameSplit = tokens2[0..<(tokens2.count - 1)]
    let number = Int(tokens2[tokens2.count - 1])!
    return (nameSplit.joined(separator: "-"), number, String(code))
}

private func count(_ string: String) -> [Character:Int] {
    var counts = [Character:Int]()
    for char in string {
        if char != "-" {
            if let current = counts[char] {
                counts[char] = current + 1
            } else {
                counts[char] = 1
            }
        }
    }
    return counts
}

private func select(counts: [Character:Int], count currentCount: Int) -> [Character] {
    var result = [Character]()
    for (char, charCount) in counts {
        if charCount == currentCount {
            result.append(char)
        }
    }
    result.sort()
    return result
}

private func group(counts: [Character:Int], callback: (Int, [Character]) -> Void) {
    var currentCount = counts.values.max()!
    while currentCount >= 1 {
        callback(currentCount, select(counts: counts, count: currentCount))
        currentCount -= 1
    }
}

private func computeCode(name: String) -> String {
    let counts = count(name)
    var topFive = ""
    group(counts: counts) {count, characters in
        for char in characters {
            if topFive.count < 5 {
                topFive += String(char)
            }
        }
    }
    return topFive
}

private func isReal(name: String, code: String) -> Bool {
    return computeCode(name: name) == code
}

private func decrypt(_ cypherText: String, withKey: Int) -> String {
    
    var plainText = ""
    let a = Int(Character("a").asciiValue!)
    
    for character in cypherText {
        if character == "-" {
            plainText += " "
        } else {
            let asInt = Int(character.asciiValue!) - a
            let decodedInt = (asInt + withKey) % 26
            let decodedChar = Character(UnicodeScalar(decodedInt + a)!)
            plainText += String(decodedChar)
        }
    }
    
    return plainText
    
}

private func part1(_ data: String) -> Int {
    var total = 0
    for line in data.split(separator: "\n") {
        let (name, number, code) = split(string: String(line))
        if isReal(name: name, code: code) {
            total += number
        }
    }
    return total
}

private func part2(_ data: String) -> Int {
    
    var result: Int? = nil
    
    for line in data.split(separator: "\n") {
        let (name, number, code) = split(string: String(line))
        if isReal(name: name, code: code) {
            if decrypt(name, withKey: number) == "northpole object storage" {
                result = number
                break
            }
        }
    }

    return result!
    
}

func day04() throws {
    
    print("Day 4\n")
    
    let data = try loadData(forDay: 4)
    
    print("Part 1: \(part1(data))")
    print("Part 2: \(part2(data))")
    print()
    
}
