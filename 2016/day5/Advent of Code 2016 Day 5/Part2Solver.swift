//
//  Part2Solver.swift
//  Advent of Code 2016 Day 5
//
//  Created by 0x1ac on 2023-04-24.
//

import Foundation
import CryptoKit

public class Part2Solver {
    
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
    
}
