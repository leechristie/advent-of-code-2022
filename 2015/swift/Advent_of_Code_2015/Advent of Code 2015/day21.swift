import Foundation

protocol Item {
    var name: String { get }
    var cost: Int { get }
    var damage: Int { get }
    var armor: Int { get }
}

struct Weapon: Item {
    let name: String
    let cost: Int
    let damage: Int
    let armor: Int = 0
    init(name: String, cost: Int, damage: Int) {
        precondition(cost >= 0, "cost = \(cost), expected >= 0")
        precondition(damage >= 0, "damage = \(damage), expected >= 0")
        self.name = name
        self.cost = cost
        self.damage = damage
    }
}

struct Armor: Item {
    let name: String
    let cost: Int
    let damage: Int = 0
    let armor: Int
    init(name: String, cost: Int, armor: Int) {
        precondition(cost >= 0, "cost = \(cost), expected >= 0")
        precondition(armor >= 0, "armor = \(armor), expected >= 0")
        self.name = name
        self.cost = cost
        self.armor = armor
    }
}

struct Ring: Item {
    let name: String
    let cost: Int
    let damage: Int
    let armor: Int
    init(name: String, cost: Int, damage: Int, armor: Int) {
        precondition(cost >= 0, "cost = \(cost), expected >= 0")
        precondition(damage >= 0 || armor >= 0, "damage = \(damage), armor = \(armor), at least one must be >= 0")
        self.name = name
        self.cost = cost
        self.damage = damage
        self.armor = armor
    }
}

enum Outcome {
    case win
    case lose
}

private func loadShopInventory() -> ([Weapon], [Armor], [Ring]) {

    var weapons = [Weapon]()

    weapons.append(Weapon(name: "Dagger", cost: 8, damage: 4))
    weapons.append(Weapon(name: "Shortsword", cost: 10, damage: 5))
    weapons.append(Weapon(name: "Warhammer", cost: 25, damage: 6))
    weapons.append(Weapon(name: "Longsword", cost: 40, damage: 7))
    weapons.append(Weapon(name: "Greataxe", cost: 74, damage: 8))

    var armors = [Armor]()

    armors.append(Armor(name: "Leather", cost: 13, armor: 1))
    armors.append(Armor(name: "Chainmail", cost: 31, armor: 2))
    armors.append(Armor(name: "Splintmail", cost: 53, armor: 3))
    armors.append(Armor(name: "Bandedmail", cost: 75, armor: 4))
    armors.append(Armor(name: "Platemail", cost: 102, armor: 5))

    var rings = [Ring]()

    rings.append(Ring(name: "Damage +1", cost: 25, damage: 1, armor: 0))
    rings.append(Ring(name: "Damage +2", cost: 50, damage: 2, armor: 0))
    rings.append(Ring(name: "Damage +3", cost: 100, damage: 3, armor: 0))
    rings.append(Ring(name: "Defense +1", cost: 20, damage: 0, armor: 1))
    rings.append(Ring(name: "Defense +2", cost: 40, damage: 0, armor: 2))
    rings.append(Ring(name: "Defense +3", cost: 80, damage: 0, armor: 3))

    return (weapons, armors, rings)

}

private func computeTotals(weapon: Weapon, armor: Armor?, ring: [Ring]) -> (Int, Int, Int) {

    var totalCost = 0
    var totalDamage = 0
    var totalArmor = 0

    totalCost += weapon.cost
    totalDamage += weapon.damage
    totalArmor += weapon.armor

    if let armor {
        totalCost += armor.cost
        totalDamage += armor.damage
        totalArmor += armor.armor
    }

    for r in ring {
        totalCost += r.cost
        totalDamage += r.damage
        totalArmor += r.armor
    }

    return (totalCost, totalDamage, totalArmor)

}

class Mob {

    var hp: Int
    var damage: Int
    var armor: Int

    init(hp: Int, damage: Int, armor: Int) {
        precondition(damage >= 0, "damage = \(damage), expected >= 0")
        precondition(armor >= 0, "armor = \(armor), expected >= 0")
        self.hp = hp
        self.damage = damage
        self.armor = armor
    }

    var isAlive: Bool {
        hp > 0
    }

}

func calculateDamageDealt(attacker: Mob, defender: Mob) -> Int {

    let rv = attacker.damage - defender.armor
    if rv < 1 {
        return 1
    }
    return rv

}

private func simulateBattle(weapon: Weapon, armor: Armor?, ring: [Ring],
                            bossMaxHP: Int, bossDamage: Int, bossArmor: Int,
                            playerMaxHP: Int) -> (Int, Outcome) {

    let (shopCost, playerDamage, playerArmor) = computeTotals(weapon: weapon, armor: armor, ring: ring)

    var player = Mob(hp: playerMaxHP, damage: playerDamage, armor: playerArmor)
    var boss = Mob(hp: bossMaxHP, damage: bossDamage, armor: bossArmor)

    var attacker = player
    var defender = boss

    while (attacker.isAlive && defender.isAlive) {

        let damageDealt = calculateDamageDealt(attacker: attacker, defender: defender)
        defender.hp -= damageDealt
        (attacker, defender) = (defender, attacker)

    }

    if player.isAlive {
        return (shopCost, Outcome.win)
    }
    return (shopCost, Outcome.lose)

}

private func forEachBuildOutcome(weapons: [Weapon], armors: [Armor], rings: [Ring], bossMaxHP: Int, bossDamage: Int, bossArmor: Int, playerMaxHP: Int, callback: (Int, Outcome) -> ()) {

    var armorsOrNil: [Armor?] = armors
    armorsOrNil.append(nil)

    var shopCost: Int
    var outcome: Outcome

    for weapon in weapons {

        for armor in armorsOrNil {

            // no rings
            (shopCost, outcome) = simulateBattle(weapon: weapon, armor: armor, ring: [], bossMaxHP: bossMaxHP, bossDamage: bossDamage, bossArmor: bossArmor, playerMaxHP: playerMaxHP)
            callback(shopCost, outcome)

            // one ring
            for ring in rings {
                (shopCost, outcome) = simulateBattle(weapon: weapon, armor: armor, ring: [ring], bossMaxHP: bossMaxHP, bossDamage: bossDamage, bossArmor: bossArmor, playerMaxHP: playerMaxHP)
                callback(shopCost, outcome)
            }

            // two rings
            for i in 0..<rings.count-1 {
                for j in i+1..<rings.count {
                    (shopCost, outcome) = simulateBattle(weapon: weapon, armor: armor, ring: [rings[i], rings[j]], bossMaxHP: bossMaxHP, bossDamage: bossDamage, bossArmor: bossArmor, playerMaxHP: playerMaxHP)
                    callback(shopCost, outcome)
                }
            }

        }

    }
}

private func part1(weapons: [Weapon], armors: [Armor], rings: [Ring], timeOnly: Bool = false) throws {

    if !timeOnly {
        print("Part 1\n")
    }

    var lowestWinCost: Int? = nil

    forEachBuildOutcome(weapons: weapons, armors: armors, rings: rings,
            bossMaxHP: 109, bossDamage: 8, bossArmor: 2, playerMaxHP: 100,
            callback: { (shopCost, outcome) -> () in
                if outcome == Outcome.win {
                    if let lowestWinCostUnwrapped = lowestWinCost {
                        if shopCost < lowestWinCostUnwrapped {
                            lowestWinCost = shopCost
                        }
                    } else {
                        lowestWinCost = shopCost
                    }
                }
            })

    if !timeOnly {
        print("The minimum amount paid but still winning is \(lowestWinCost!) gold.\n")
    }

}

private func part2(weapons: [Weapon], armors: [Armor], rings: [Ring], timeOnly: Bool = false) throws {

    if !timeOnly {
        print("Part 2\n")
    }

    var highestLoseCost: Int? = nil

    forEachBuildOutcome(weapons: weapons, armors: armors, rings: rings,
            bossMaxHP: 109, bossDamage: 8, bossArmor: 2, playerMaxHP: 100,
            callback: { (shopCost, outcome) -> () in
                if outcome == Outcome.lose {
                    if let highestLoseCostUnwrapped = highestLoseCost {
                        if shopCost > highestLoseCostUnwrapped {
                            highestLoseCost = shopCost
                        }
                    } else {
                        highestLoseCost = shopCost
                    }
                }
            })

    if !timeOnly {
        print("The maximum amount paid but still losing is \(highestLoseCost!) gold.\n")
    }

}

public func day21(timeOnly: Bool = false) throws {

    if !timeOnly {
        printAOCDayHeader(day: 21, title: "RPG Simulator 20XX")
    }

    let (weapons, armors, rings) = loadShopInventory()

    try part1(weapons: weapons, armors: armors, rings: rings, timeOnly: timeOnly)
    try part2(weapons: weapons, armors: armors, rings: rings, timeOnly: timeOnly)

}