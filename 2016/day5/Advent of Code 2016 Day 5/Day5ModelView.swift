//
//  Day5ModelView.swift
//  Advent of Code 2016 Day 5
//
//  Created by 0x1ac on 2023-04-24.
//

import Foundation

public class Day5ModelView: ObservableObject {
    
    @Published var model = Day5Model()
    
    func loadData(forDay day: Int, test: Bool = false) throws -> String {
        let dataPath = "/Users/0x1ac/Developer/advent-of-code/2016/data/"
        let namePrefix = test ? "test" : "input"
        let fileName = day < 10 ? "\(namePrefix)0\(day).txt" : "\(namePrefix)\(day).txt"
        let data = try String(contentsOfFile: dataPath + fileName,
                              encoding: .utf8)
        return String(data.replacing("\n", with: ""))
    }
    
    public var currentPart1: String {
        return "TODO 1"
    }
    
    public var currentPart2: String {
        return "TODO 2"
    }
    
    public var pressCount: Int {
        return model.presses
    }
    
    public func buttonPressed() {
        model.presses += 1
    }
    
    private func loadData() {
        do {
            model.data = try loadData(forDay: 5)
        } catch {
            model.error = "Data Load Failed"
        }
    }
    
    public func solvePart1() async {
        await MainActor.run {
            loadData()
        }
        if let data = model.data {
            let solver = Part1Solver(doorID: data, difficulty: 5)
            await solver.solvePart1 { position, char in
                await MainActor.run {
                    model.part1SolutionSoFar[position] = char
                }
            }
        }
    }
    
    public func solvePart2() async {
        await MainActor.run {
            loadData()
        }
        if let data = model.data {
            let solver = Part2Solver(doorID: data, difficulty: 5)
            await solver.solvePart2 { position, char in
                await MainActor.run {
                    model.part2SolutionSoFar[position] = char
                }
            }
        }
    }
    
    public var part1SolutionSoFar: String {
        var rv: String = ""
        for char in model.part1SolutionSoFar {
            if let char {
                rv.append(char)
            } else {
                rv += "?"
            }
        }
        return rv
    }
    
    public var part2SolutionSoFar: String {
        var rv: String = ""
        for char in model.part2SolutionSoFar {
            if let char {
                rv.append(char)
            } else {
                rv += "?"
            }
        }
        return rv
    }
        
    public var errorText: String {
        if let error = model.error {
            return error
        } else {
            return "no error yet"
        }
    }
    
    public var dataSize: Int {
        if let data = model.data {
            return data.count
        } else {
            return 0
        }
    }
    
    public var data: String {
        if let data = model.data {
            return data
        } else {
            return ""
        }
    }
    
}
