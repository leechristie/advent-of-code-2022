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
    
    public var pressCount: Int {
        return model.presses
    }
    
    public func buttonPressed() {
        model.presses += 1
    }
    
    private func loadData() {
        do {
            model.data = try loadData(forDay: 5)
            model.solver = Solver(doorID: model.data!, difficulty: 5)
        } catch {
            model.error = "Data Load Failed"
            model.solver = nil
        }
    }
    
    public func solve() async {
        await MainActor.run {
            loadData()
        }
        if let solver = model.solver {
            await solver.solve(
                part1: { position, char, solved in
                    await MainActor.run {
                        model.part1SolutionSoFar[position] = char
                        model.part1Solved = solved
                    }
                },
                part2: { position, char, solved in
                    await MainActor.run {
                        model.part2SolutionSoFar[position] = char
                        model.part2Solved = solved
                    }
                }
            )
        }
    }
        
    public var part1SolutionSoFar: [Character?] {
        return model.part1SolutionSoFar
    }
    
    public var part2SolutionSoFar: [Character?] {
        return model.part2SolutionSoFar
    }
    
    public var part1Solved: Bool {
        return model.part1Solved
    }
    
    public var part2Solved: Bool {
        return model.part2Solved
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
