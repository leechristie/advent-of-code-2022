//
//  main.swift
//  Advent of Code 2016
//
//  Created by 0x1ac on 2023-04-13.
//

import Foundation

print("Advent of Code 2016\n\n")

let solvers = [
    day01,
    day02,
    day03,
    day04,
    //day05,
    day06,
    day07
]

for solver in solvers {
    
    let clock = ContinuousClock()
    
    let time = try clock.measure {
        try solver()
    }
    
    print(time)
    print()
    print()
    
}
