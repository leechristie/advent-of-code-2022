//
//  Dijkstra.swift
//  Advent of Code 2015 Day 22
//
//  Created by 0x1ac on 2023-05-06.
//

import Foundation


func dijkstra(graph: Fight, source: State) -> State? {
    var dist: [State:Int] = [:]
    var prev: [State:State] = [:]
    var frontier = MinHeap<State>()
    dist[source] = 0
    frontier.add(element: source, withKey: 0);
    while let current: State = frontier.deleteMinimum() {
        let currentDist: Int = dist[current]!
        if current.isGoal {
            return current
        }
        for neighbour in graph.neighbours(ofState: current) {
            let edgeCost = graph.costOfEdge(fromVertex: current, toVertex: neighbour)
            let alt = currentDist + edgeCost
            let known: Int? = dist[neighbour]
            if let known {
                if alt < known {
                    dist[neighbour] = alt
                    frontier.decreaseKey(ofElement: neighbour, toNewKey: alt)
                    prev[neighbour] = current
                }
            } else {
                dist[neighbour] = alt
                frontier.add(element: neighbour, withKey: alt)
                prev[neighbour] = current
            }
        }
    }
    return nil;
}
