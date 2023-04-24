//
//  Part1Solver.swift
//  Advent of Code 2016 Day 5
//
//  Created by 0x1ac on 2023-04-24.
//

import Foundation
import CryptoKit

public class Solver {
    
    private func hash(doorID: String, index: Int) -> String {
        let text = "\(doorID)\(index)"
        let ascii: [UInt8] = Array(text.utf8)
        let hash = Insecure.MD5.hash(data: ascii)
        return String(hash.description.split(separator: " ")[2])
    }
    
    let doorID: String
    let prefix: String

    init(doorID: String, difficulty: Int) {
        self.doorID = doorID
        self.prefix = String(repeating: "0", count: difficulty)
    }
    
    public func solve(part1: (Int, Character, Bool) async -> Void,
                      part2: (Int, Character, Bool) async -> Void) async {

        let doorID = self.doorID
        
        var result: [Character?] = [nil, nil, nil, nil, nil, nil, nil, nil]
        var foundPart1 = 0
        var foundPart2 = 0
        
        var nonce = 0
        while (foundPart1 < 8 || foundPart2 < 8) {
            
            let hashStr = hash(doorID: doorID, index: nonce)
            if hashStr.starts(with: self.prefix) {
                
                // Part 1
                if (foundPart1 < 8) {
                    let char = hashStr[hashStr.index(hashStr.startIndex, offsetBy: 5)]
                    foundPart1 += 1
                    await part1(foundPart1 - 1, char, foundPart1 == 8)
                }
                
                // Part 2
                if (foundPart2 < 8) {
                    let positionIndicator = hashStr[hashStr.index(hashStr.startIndex, offsetBy: 5)]
                    if let i = Int(String(positionIndicator)) {
                        if i < 8 {
                            if result[i] == nil {
                                let char = hashStr[hashStr.index(hashStr.startIndex, offsetBy: 6)]
                                result[i] = char
                                foundPart2 += 1
                                await part2(i, char, foundPart2 == 8)
                            }
                        }
                    }
                }
                
            }
            
            nonce += 1
            
        }
        
    }
        
}
