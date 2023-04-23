//
//  day06.swift
//  Advent of Code 2016
//
//  Created by 0x1ac on 2023-04-17.
//

import Foundation

private func countByColumn(_ data: String) -> [Counter<Character>] {
        
    var counters: [Counter<Character>] = []
    
    data.lines { line in
        
        if counters.count == 0 {
            for _ in 0..<line.count {
                counters.append(Counter())
            }
        }
        
        precondition(counters.count == line.count)
        
        for i in 0..<line.count {
            let char = line[line.index(line.startIndex, offsetBy: i)]
            counters[i].increment(char)
        }
        
    }
    
    return counters
    
}

private func part1(_ counters: [Counter<Character>]) {
    print("Part 1: ", terminator: "")
    for counter in counters {
        print(counter.uniqueMostCommon!, terminator: "")
    }
    print()
}

private func part2(_ counters: [Counter<Character>]) {
    print("Part 2: ", terminator: "")
    for counter in counters {
        print(counter.uniqueLeastCommon!, terminator: "")
    }
    print()
}

func day06() throws {
    
    print("Day 6\n")
    
    let data = try loadData(forDay: 6)
    let counters = countByColumn(data)
    
    part1(counters)
    part2(counters)
    print()
    
}
