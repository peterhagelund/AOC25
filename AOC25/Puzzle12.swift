//
//  Puzzle12.swift
//  AOC25
//
//  Created by Peter Hagelund on 5/29/26.
//

import Foundation

class Puzzle12: Puzzle {
    override func solveProblem1() throws -> Int {
        var partCounts: [Int] = []
        var partCount = 0
        var answer = 0
        for line in puzzleInput.lines {
            if line.isEmpty {
                if partCount > 0 {
                    partCounts.append(partCount)
                    partCount = 0
                }
            } else if line.hasSuffix(":") {
                continue
            } else if line.contains("#") {
                partCount += line.count { $0 == "#" }
            } else {
                let parts = line.split(separator: ":", maxSplits: 2)
                let sizes = parts[0].split(separator: "x", maxSplits: 2).map { Int($0)! }
                let area = sizes[0] * sizes[1]
                let counts = parts[1].split(separator: " ").map { Int($0)! }
                var needed = 0
                for i in 0..<counts.count {
                    needed += counts[i] * partCounts[i]
                }
                if needed <= area {
                    answer += 1
                }
            }
        }
        return answer
    }
}
