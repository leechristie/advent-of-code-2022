//
//  ContentView.swift
//  Advent of Code 2016 Day 5
//
//  Created by 0x1ac on 2023-04-24.
//

import SwiftUI

struct PotentialCharacter: Identifiable, CustomStringConvertible {
    var id: Int
    var description: String
    var locked: Bool
    var color: Color {
        if locked {
            return .green
        } else {
            return .red
        }
    }
}

struct SolutionTiles: View {
    
    let solution: [Character?]
    let solved: Bool
    
    var solutionString: String {
        var rv: String = ""
        for char in self.solution {
            if let char {
                rv.append(char)
            } else {
                rv += "?"
            }
        }
        return rv
    }
    
    var list: [PotentialCharacter] {
        var rv: [PotentialCharacter] = []
        for (index, char) in solution.enumerated() {
            if let char {
                rv.append(PotentialCharacter(id: index,
                                             description: String(char),
                                             locked: true))
            } else {
                rv.append(PotentialCharacter(id: index,
                                             description: "-",
                                             locked: false))
            }
        }
        return rv
    }
    
    var body: some View {
        HStack {
            ForEach(list) { character in
                if character.locked {
                    ZStack {
                        Rectangle().strokeBorder(
                            lineWidth: CGFloat(2.5),
                            antialiased: true)
                        Text(character.description)
                    }.foregroundColor(character.color)
                        .frame(width: 20.0, height: 20.0)
                } else {
                    ZStack {
                        Rectangle()
                    }.foregroundColor(character.color)
                        .frame(width: 20.0, height: 20.0)
                }
            }
        }
    }
    
}

struct SolutionView: View {
    
    let title: String
    let solution: [Character?]
    let solved: Bool
    
    var body: some View {
        Text(title)
        SolutionTiles(solution: solution, solved: solved)
    }
    
    init(title: String, solution: [Character?], solved: Bool) {
        self.title = title
        self.solution = solution
        self.solved = solved
    }
    
}

struct Day5View: View {
    
    @ObservedObject var modelView: Day5ModelView
    let disableSolver: Bool
    
    var body: some View {
        VStack {
            SolutionView(title: "Part 1",
                         solution: modelView.part1SolutionSoFar,
                         solved: modelView.part1Solved)
            SolutionView(title: "Part 2",
                         solution: modelView.part2SolutionSoFar,
                         solved: modelView.part2Solved)
        }
        .padding(.all)
        .task {
            await MainActor.run {
                print(".task started")
            }
            if !self.disableSolver {
                await modelView.solve()
            }
        }
    }
    
    init(disableSolver: Bool = false) {
        print("Day5View init")
        self.modelView = Day5ModelView()
        self.disableSolver = disableSolver
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Day5View(disableSolver: true)
    }
}
