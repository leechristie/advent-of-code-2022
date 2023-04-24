//
//  Day5Model.swift
//  Advent of Code 2016 Day 5
//
//  Created by 0x1ac on 2023-04-24.
//

import Foundation

public struct Day5Model {
    
    public var presses = 0
    
    public var part1SolutionSoFar: [Character?] = Array(repeating: nil, count: 8)
    public var part2SolutionSoFar: [Character?] = Array(repeating: nil, count: 8)
    public var part1Solved = false
    public var part2Solved = false
    
    public var data: String? = nil
    public var solver: Solver? = nil
    public var error: String? = nil
    
}
