//
//  Fight.swift
//  Advent of Code 2015 Day 22
//
//  Created by 0x1ac on 2023-05-06.
//

import Foundation

struct State: Hashable {
    
    let time: Int
    let manaSpent: Int
    
    let playerHealth: Int
    let playerMana: Int
    let bossHealth: Int
    
    var isGoal: Bool {
        return bossHealth <= 0
    }
    
}

struct Fight {
    
    func neighbours(ofState state: State) -> [State] {
        return []
    }
    
    func costOfEdge(fromVertex: State, toVertex: State) -> Int {
        return toVertex.manaSpent - fromVertex.manaSpent
    }
    
}

// Magic Missile costs 53 mana. It instantly does 4 damage.

// Drain costs 73 mana. It instantly does 2 damage and heals you for 2 hit points.

// Shield costs 113 mana. It starts an effect that lasts for 6 turns. While it is active, your armor is increased by 7.

// Poison costs 173 mana. It starts an effect that lasts for 6 turns. At the start of each turn while it is active, it deals the boss 3 damage.

// Recharge costs 229 mana. It starts an effect that lasts for 5 turns. At the start of each turn while it is active, it gives you 101 new mana.

//struct Effect {
//    var duration
//    var armorBuff = 0
//    var
//}
//
//enum Spell {
//    case magicMissile
//    case drain
//    case shield
//    case poison
//    case recharge
//}
//
//struct Player {
//    var health: Int
//    var mana: Int
//    var armor: Int {
//        return 0
//    }
//}
//
//struct Boss {
//    var health: Int
//    var damage: Int
//}
//
//var player = Player(health: 50, mana: 500)
//var boss = Boss(health: 58, damage: 9)
//
//let startState = State(time: 0,
//                       manaSpent: 0,
//                       playerHealth: 50,
//                       playerMana: 500,
//                       bossHealth: 58)
//
//let fight = Fight()
//
//let endState = dijkstra(graph: fight, source: startState)
//
//print("Part 1: \(endState!.manaSpent)")
