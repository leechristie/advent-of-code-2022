printAOCHeader(year: 2015)

print("Choose Day", terminator: ": ")
let line = readLine()!
print()

if let day = Int(line) {
    if day < 1 || day > 25 {
        print("Invalid input. AOC day should be 1 to 25.")
    } else {
        var done = false
        let clock = ContinuousClock()
        let time = clock.measure {
            done = try! runSolution(day: day)
        }
        if done {
            print("Time taken: \(time)")
        }
    }
} else {
    print("Invalid input. AOC day should be 1 to 25.")
}
