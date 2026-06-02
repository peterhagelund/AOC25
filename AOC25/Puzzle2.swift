//
//  Puzzle2.swift
//  AOC25
//
//  Created by Peter Hagelund on 5/3/26.
//

import Foundation

/// Implementation of puzzle 2.
class Puzzle2: Puzzle {
    override func solveProblem1() throws -> Int {
        var answer = 0
        let id_ranges = puzzleInput.contents.split(separator: ",")
        for id_range in id_ranges {
            let ids = id_range.split(separator: "-", maxSplits: 2).map { Int($0)! }
            for id in ids[0]...ids[1] {
                let digits = Int(log10(Double(id))) + 1
                let (quotient, remainder) = id.quotientAndRemainder(dividingBy: Int(pow(10, Double(digits >> 1))))
                if quotient == remainder {
                    answer += id
                }
            }
        }
        return answer
    }

    override func solveProblem2() throws -> Int {
        var answer = 0
        let id_ranges = puzzleInput.contents.split(separator: ",")
        for id_range in id_ranges {
            let ids = id_range.split(separator: "-", maxSplits: 2).map { Int($0)! }
            for id in ids[0]...ids[1] {
                guard id > 9 else {
                    continue
                }
                if isInvalid(id: String(id)) {
                    answer += id
                }
            }
        }
        return answer
    }

    func isInvalid(id: String) -> Bool {
        let count = id.count
        for size in 1...count / 2 {
            guard count % size == 0 else {
                continue
            }
            if id == String(repeating: String(id.prefix(size)), count: count / size) {
                return true
            }
        }
        return false
    }
}
