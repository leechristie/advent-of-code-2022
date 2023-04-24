//
//  Day5ModelView.swift
//  Advent of Code 2016 Day 5
//
//  Created by 0x1ac on 2023-04-24.
//

import Foundation

public class Day5ModelView: ObservableObject {
    
    @Published var model = Day5Model()
    
    public var pressCount: Int {
        return model.presses
    }
    
    public func buttonPressed() {
        model.presses += 1
    }
    
    private func loadData() {
        model.solver = Solver(doorID: "reyedfim", difficulty: 5)
    }
    
    public func solve() async {
        await MainActor.run {
            loadData()
        }
        if let solver = model.solver {
            await solver.solve(
                part1: { position, char, solved in
                    await MainActor.run {
                        print("Part 1: got char for index \(position)")
                        model.part1SolutionSoFar[position] = char
                        model.part1Solved = solved
                    }
                },
                part2: { position, char, solved in
                    await MainActor.run {
                        print("Part 2: got char for index \(position)")
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
    
}
