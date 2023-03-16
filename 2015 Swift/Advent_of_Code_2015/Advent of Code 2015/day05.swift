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

private func part1(data: [String]) {

    print("Part 1\n")

    var niceCount = 0
    for line in data {
        if isNice(line) {
            niceCount += 1
        }
    }

    print("The number of nice strings is \(niceCount).\n")

}

private func part2(data: [String]) {

    print("Part 2\n")

    print("TODO\n")

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

public func day05() throws {

    printAOCDayHeader(day: 5, title: "Doesn't He Have Intern-Elves For This?")

    let string = try loadAOCData(day: 5)
    let data = parseData(string: string)

    part1(data: data)
    part2(data: data)

}
