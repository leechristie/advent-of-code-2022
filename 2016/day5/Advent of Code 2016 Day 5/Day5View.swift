//
//  ContentView.swift
//  Advent of Code 2016 Day 5
//
//  Created by 0x1ac on 2023-04-24.
//

import SwiftUI

struct Day5View: View {
    
    @ObservedObject var modelView: Day5ModelView = Day5ModelView()
    
    var body: some View {
        VStack {
            Text("Day 1:")
            Text(modelView.currentPart1).task {
                await modelView.solvePart1()
            }
            Text("Solution: \(modelView.part1SolutionSoFar)")
            Text("Day 2:")
            Text(modelView.currentPart2).task {
                await modelView.solvePart2()
            }
            Text("Solution: \(modelView.part2SolutionSoFar)")
            Button {
                modelView.buttonPressed()
            } label: {
                Text("Press Me")
            }
            Text("( \(modelView.pressCount) )")
            Text(modelView.errorText)
            Text("data: \"\(modelView.data)\" (\(modelView.dataSize) chars)")
        }
        .padding(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Day5View()
    }
}
