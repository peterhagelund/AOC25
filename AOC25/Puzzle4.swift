//
//  Puzzle4.swift
//  AOC25
//
//  Created by Peter Hagelund on 5/25/26.
//

import Foundation

fileprivate let deltas = [
    (y: -1, x: -1),
    (y: -1, x: 0),
    (y: -1, x: 1),
    (y: 0, x: -1),
    (y: 0, x: 1),
    (y: 1, x: -1),
    (y: 1, x: 0),
    (y: 1, x: 1),
]

class Puzzle4: Puzzle {
    override func solveProblem1() throws -> Int {
        let floor = puzzleInput.lines.map { Array<Character>($0) }
        let ys = 0..<floor.count
        let xs = 0..<floor[0].count
        var answer = 0
        for y in ys {
            for x in xs {
                guard floor[y][x] == "@" else {
                    continue
                }
                var count = 0
                for delta in deltas {
                    let dy = y + delta.y
                    let dx = x + delta.x
                    guard ys ~= dy, xs ~= dx, floor[dy][dx] == "@" else {
                        continue
                    }
                    count += 1
                }
                if count < 4 {
                    answer += 1
                }
            }
        }
        return answer
    }
    
    override func solveProblem2() throws -> Int {
        var floor = puzzleInput.lines.map { Array<Character>($0) }
        let ys = 0..<floor.count
        let xs = 0..<floor[0].count
        var answer = 0
        while true {
            var rolls: [(y: Int, x: Int)] = []
            for y in ys {
                for x in xs {
                    guard floor[y][x] == "@" else {
                        continue
                    }
                    var count = 0
                    for delta in deltas {
                        let dy = y + delta.y
                        let dx = x + delta.x
                        guard ys ~= dy, xs ~= dx, floor[dy][dx] == "@" else {
                            continue
                        }
                        count += 1
                    }
                    if count < 4 {
                        rolls.append((y: y, x: x))
                    }
                }
            }
            if rolls.isEmpty {
                break
            }
            for roll in rolls {
                floor[roll.y][roll.x] = "."
            }
            answer += rolls.count
        }
        return answer
    }
}
