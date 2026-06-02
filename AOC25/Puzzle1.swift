//
//  Puzzle1.swift
//  AOC25
//
//  Created by Peter Hagelund on 5/3/26.
//

import Foundation

/// Implementation of puzzle 1.
class Puzzle1: Puzzle {
    override func solveProblem1() throws -> Int {
        var answer = 0
        var dial = 50
        for line in puzzleInput.lines {
            dial = (dial + Int(line.replacingOccurrences(of: "R", with: "+").replacingOccurrences(of: "L", with: "-"))!) % 100
            answer += dial == 0 ? 1 : 0
        }
        return answer
    }

    override func solveProblem2() throws -> Int {
        var answer = 0
        var dial = 50
        for line in puzzleInput.lines {
            let delta = if line[line.startIndex] == "R" { 1 } else { -1 }
            let distance = Int(line[line.index(after: line.startIndex)...])!
            for _ in 1...distance {
                dial += delta % 100
                if dial == -1 {
                    dial = 99
                } else if dial == 100 {
                    dial = 0
                }
                if dial == 0 {
                    answer += 1
                }
            }
        }
        return answer
    }
}
