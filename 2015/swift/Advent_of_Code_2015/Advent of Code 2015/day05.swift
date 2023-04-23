import Foundation

private func doesNotHaveBannedSubstring(_ string: String) -> Bool {
    for bannedString in ["ab", "cd", "pq", "xy"] {
        if string.contains(bannedString) {
            return false
        }
    }
    return true
}

private func hasLetterPair(_ string: String) -> Bool {
    let bound = string.count-1
    for i in 0..<bound {
        let j = i + 1
        if string[string.index(string.startIndex, offsetBy: i)]
                   == string[string.index(string.startIndex, offsetBy: j)] {
            return true
        }
    }
    return false
}

private func hasThreeVowels(_ string: String) -> Bool {
    var vowel_count = 0
    for v in "aeiou" {
        for c in string {
            if c == v {
                vowel_count += 1
            }
        }
        if vowel_count >= 3 {
            return true
        }
    }
    return false
}

private func isNice(_ string: String) -> Bool {
    doesNotHaveBannedSubstring(string) && hasLetterPair(string) && hasThreeVowels(string)
}

private func containsPairAtLeastTwice(_ string: String) -> Bool {
    let bound = string.count-3
    for i in 0..<bound {
        let left0 = string[string.index(string.startIndex, offsetBy: i)]
        let left1 = string[string.index(string.startIndex, offsetBy: i + 1)]
        for j in (i + 2)..<(string.count-1) {
            let right0 = string[string.index(string.startIndex, offsetBy: j)]
            let right1 = string[string.index(string.startIndex, offsetBy: j + 1)]
            if left0 == right0 && left1 == right1 {
                return true
            }
        }
    }
    return false
}

private func containsRepeatWithOneBetween(_ string: String) -> Bool {
    let bound = string.count-2
    for i in 0..<bound {
        let j = i + 2
        if string[string.index(string.startIndex, offsetBy: i)]
                   == string[string.index(string.startIndex, offsetBy: j)] {
            return true
        }
    }
    return false
}

private func isNicer(_ string: String) -> Bool {
    containsPairAtLeastTwice(string) && containsRepeatWithOneBetween(string)
}

private func part1(data: [String], timeOnly: Bool = false) {

    if !timeOnly {
        print("Part 1\n")
    }

    var niceCount = 0
    for line in data {
        if isNice(line) {
            niceCount += 1
        }
    }

    if !timeOnly {
        print("The number of nice strings is \(niceCount).\n")
    }

}

private func part2(data: [String], timeOnly: Bool = false) {

    if !timeOnly {
        print("Part 2\n")
    }

    var niceCount = 0
    for line in data {
        if isNicer(line) {
            niceCount += 1
        }
    }

    if !timeOnly {
        print("The number of nicer strings is \(niceCount).\n")
    }

}

private func parseData(string: String, limit: Int? = nil) -> [String] {
    let lines = string.split(whereSeparator: \.isNewline)
    var data = [String]()
    var count = 0
    for line in lines {
        if let unwrappedLimit = limit {
            if count >= unwrappedLimit {
                break
            }
        }
        data.append(String(line))  // line is of type Substring
        count += 1
    }
    return data
}

public func day05(timeOnly: Bool = false) throws {

    if !timeOnly {
        printAOCDayHeader(day: 5, title: "Doesn't He Have Intern-Elves For This?")
    }

    let string = try loadAOCData(day: 5)
    let data = parseData(string: string)

    part1(data: data, timeOnly: timeOnly)
    part2(data: data, timeOnly: timeOnly)

}
