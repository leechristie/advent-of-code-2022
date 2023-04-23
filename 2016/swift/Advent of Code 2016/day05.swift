//
//  day05.swift
//  Advent of Code 2016
//
//  Created by 0x1ac on 2023-04-16.
//

import Foundation
import CryptoKit


private func hash(doorID: String, index: Int) -> String {
    let text = "\(doorID)\(index)"
    let ascii: [UInt8] = Array(text.utf8)
    let hash = Insecure.MD5.hash(data: ascii)
    return String(hash.description.split(separator: " ")[2])
}

private func part1(_ data: String) {
        
    print("Part 1: ", terminator: "")
    
    let doorID = String(data.replacingOccurrences(of: "\n", with: ""))
    
    var found = 0
    
    var index = 0
    while (found < 8) {
        let hashStr = hash(doorID: doorID, index: index)
        if hashStr.starts(with: "00000") {
            let char = hashStr[hashStr.index(hashStr.startIndex, offsetBy: 5)]
            print(char, terminator: "")
            found += 1
        }
        index += 1
    }
    
    print()
    
}

private func toString(result: [Character?]) -> String {
    var rv = ""
    for e in result {
        if let e {
            rv += String(e)
        } else {
            rv += "?"
        }
    }
    return rv
}

private func part2(_ data: String) {
    
    print("Part 2: ", terminator: "")
    
    let doorID = String(data.replacingOccurrences(of: "\n", with: ""))
    
    var result: [Character?] = [nil, nil, nil, nil, nil, nil, nil, nil]
    var found = 0
    
    var index = 0
    while (found < 8) {
        let hashStr = hash(doorID: doorID, index: index)
        if hashStr.starts(with: "00000") {
            let positionIndicator = hashStr[hashStr.index(hashStr.startIndex, offsetBy: 5)]
            if let i = Int(String(positionIndicator)) {
                if i < 8 {
                    if result[i] == nil {
                        let char = hashStr[hashStr.index(hashStr.startIndex, offsetBy: 6)]
                        result[i] = char
                        found += 1
                    }
                }
            }
        }
        index += 1
    }
    
    print(toString(result: result))
    
}

func day05() throws {
    
    print("Day 5\n")
    
    let data = try loadData(forDay: 5)
    
    part1(data)
    part2(data)
    print()
    
}
