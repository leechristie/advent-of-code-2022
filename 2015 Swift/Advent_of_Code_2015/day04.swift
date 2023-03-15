import Foundation
import CryptoKit

private func compute_hash(secret: String, nonce: Int) -> String {
    let digest = Insecure.MD5.hash(data: "\(secret)\(nonce)".data(using: .utf8)!)
    return digest.map { String(format: "%02hhx", $0) }.joined()
}

private func count_zeros(hash: String) -> Int {
    var zeros = 0
    for char in hash {
        if char == "0" {
            zeros += 1
        } else {
            break
        }
    }
    return zeros
}

private func winning_hash(hash: String, target: Int) -> Bool {
    count_zeros(hash: hash) >= target
}

private func solve(string: String, target: Int) -> (Int, String) {
    var nonce = 1
    while (true) {
        let hash = compute_hash(secret: string, nonce: nonce)
        if winning_hash(hash: hash, target: target) {
            return (nonce, hash)
        }
        nonce += 1
    }
}

private func part1(string: String) {

    print("Part 1\n")

    let (nonce, hash) = solve(string: string, target: 5)

    print("The winning nonce for target 5 is \(nonce) with hash \(hash)\n")

}

private func part2(string: String) {

    print("Part 2\n")

    let (nonce, hash) = solve(string: string, target: 6)

    print("The winning nonce for target 6 is \(nonce) with hash \(hash)\n")

}

public func day04() throws {

    printAOCDayHeader(day: 4, title: "The Ideal Stocking Stuffer")

    let string = "bgvyzdsv"

    part1(string: string)
    part2(string: string)

}
