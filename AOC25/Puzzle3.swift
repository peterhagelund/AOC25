//
//  Puzzle3.swift
//  AOC25
//
//  Created by Peter Hagelund on 5/24/26.
//

import Foundation

class Puzzle3: Puzzle {
    override func solveProblem1() throws -> Int {
        var answer = 0
        for line in puzzleInput.lines {
            let bank = line.map { $0.wholeNumberValue! }
            let index1 = bank.firstIndex(of: bank[0..<bank.count - 1].max()!)!
            let index2 = bank.firstIndex(of: bank[index1.advanced(by: 1)..<bank.count].max()!)!
            answer += bank[index1] * 10 + bank[index2]
        }
        return answer
    }
    
    override func solveProblem2() throws -> Int {
        var answer = 0
        for line in puzzleInput.lines {
            let bank = line.map { $0.wholeNumberValue! }
            answer += determineMaxJoltage(bank: bank)
        }
        return answer
    }
    
    func determineMaxJoltage(bank: [Int]) -> Int {
        var joltage = 0
        var start = bank.startIndex
        for remainder in (0...11).reversed() {
            let value = bank[start..<bank.count - remainder].max()!
            joltage = joltage * 10 + value
            start = bank[start..<bank.count - remainder].firstIndex(of: value)! + 1
        }
        return joltage
    }
}
