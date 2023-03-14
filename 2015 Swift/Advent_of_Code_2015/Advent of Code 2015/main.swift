import Foundation

print("Advent of Code 2015")
print("Day 1: Not Quite Lisp")
print("Solution by Lee A. Christie")
print()

print("Part 1")
print()

let path = "/Users/0x1ac/GitHub/leechristie/advent-of-code/2015/data/input01.txt"
let string = try String(contentsOfFile: path, encoding: String.Encoding.utf8)

var currentFloor = 0

for char in string {
    if char == "(" {
        currentFloor += 1
    } else {
        assert(char == ")", "unknown character \"\(char)\"!")
        currentFloor -= 1
    }
}

print("The instructions end at floor \(currentFloor).")
print()

print("Part 2")
print()

currentFloor = 0
let targetFloor = -1
var found = -1

for (index, char) in string.enumerated() {
    if char == "(" {
        currentFloor += 1
    } else {
        assert(char == ")", "unknown character \"\(char)\"!")
        currentFloor -= 1
    }
    if currentFloor == targetFloor {
        found = index + 1
        break
    }
}

if found >= 0 {
    print("The instructions reach the basement at position \(found).")
} else {
    print("Error! Did not find the target floor!")
}
print()
