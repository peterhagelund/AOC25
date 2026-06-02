//
//  Puzzle6.swift
//  AOC25
//
//  Created by Peter Hagelund on 5/25/26.
//

import Foundation

class Puzzle6: Puzzle {
    override func solveProblem1() throws -> Int {
        var numbers: [[Int]] = []
        var operators: [Character] = []
        for line in puzzleInput.lines {
            if line.contains("1") {
                numbers.append(line.split(separator: " ").map { Int($0)! })
            } else {
                operators = line.split(separator: " ").map { Character(String($0)) }
            }
        }
        var answer = 0
        for index in 0..<operators.count {
            var result = if operators[index] == "+" { 0 } else { 1 }
            for row in numbers {
                if operators[index] == "+" {
                    result += row[index]
                } else {
                    result *= row[index]
                }
            }
            answer += result
        }
        return answer
    }
    
    override func solveProblem2() throws -> Int {
        var numbers: [[Character]] = []
        var operators: [Character] = []
        var answer = 0
        for line in puzzleInput.lines {
            if line.contains("1") {
                numbers.append(Array(line))
            } else {
                operators = Array(line)
            }
        }
        let ranges = buildRanges(operators: operators)
        for range in ranges {
            var result = if operators[range.lowerBound] == "+" { 0 } else { 1 }
            for x in range {
                var number: [Character] = []
                for y in 0..<numbers.count {
                    let c = numbers[y][x]
                    if c != " " {
                        number.append(c)
                    }
                }
                let value = Int(String(number))!
                if operators[range.lowerBound] == "+" {
                    result += value
                } else {
                    result *= value
                }
            }
            answer += result
        }
        return answer
    }
    
    func buildRanges(operators: [Character]) -> [ClosedRange<Int>] {
        var ranges: [ClosedRange<Int>] = []
        var lowerBound = 0
        for upperBound in 1..<operators.count {
            if operators[upperBound] != " " {
                ranges.append(lowerBound...upperBound - 2)
                lowerBound = upperBound
            }
        }
        ranges.append(lowerBound...operators.count - 1)
        return ranges
    }
}
