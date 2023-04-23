import Foundation

printAOCHeader(year: 2015)

print("Choose Day (leave blank to time all)", terminator: ": ")
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
    for day in 1...25 {
        var done = false
        var time: ContinuousClock.Instant.Duration? = nil
        do {
            let clock = ContinuousClock()
            time = try clock.measure {
                print(day, terminator: "\t")
                done = try runSolution(day: day, timeOnly: true)
            }
        } catch {
            done = false
        }
        if done {
            print("\(time!)")
        } else {
            print("fail")
        }
    }
}
