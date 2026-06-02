//
//  Puzzle10.swift
//  AOC25
//
//  Created by Peter Hagelund on 5/31/26.
//

import Foundation
import Algorithms
import SwiftZ3

class Puzzle10: Puzzle {
    override func solveProblem1() throws -> Int {
        var answer = 0
        for line in puzzleInput.lines {
            var lights: [Bool] = []
            var buttons: [[Bool]] = []
            let parts = line.split(separator: " ")
            for (i, part) in parts.enumerated() {
                if i == 0 {
                    lights = part[part.index(after: part.startIndex)..<part.index(before: part.endIndex)].map { $0 == "#" }
                } else if part.starts(with: "("){
                    var button = Array(repeating: false, count: lights.count)
                    let wires = part[part.index(after: part.startIndex)..<part.index(before: part.endIndex)].split(separator: ",").map { Int($0)! }
                    for wire in wires {
                        button[wire] = true
                    }
                    buttons.append(button)
                } else {
                    break
                }
            }
            answer += determineMinimumPresses(lights: lights, buttons: buttons)
        }
        return answer
    }
    
    override func solveProblem2() throws -> Int {
        var answer = 0
        for line in puzzleInput.lines {
            var buttons: [[Int]] = []
            var joltages: [Int] = []
            let parts = line.split(separator: " ")
            for (i, part) in parts.enumerated() {
                if i == 0 {
                    continue
                } else if part.starts(with: "("){
                    let button = part[part.index(after: part.startIndex)..<part.index(before: part.endIndex)].split(separator: ",").map { Int($0)! }
                    buttons.append(button)
                } else {
                    joltages = part[part.index(after: part.startIndex)..<part.index(before: part.endIndex)].split(separator: ",").map { Int($0)! }
                }
            }
            answer += determineMinimumPresses(buttons: buttons, joltages: joltages)
        }
        return answer
    }

    func determineMinimumPresses(lights: [Bool], buttons: [[Bool]]) -> Int {
        var minimumPresses = Int.max
        for count in 1...buttons.count {
            for combination in buttons.combinations(ofCount: count) {
                var _lights = Array(repeating: false, count: lights.count)
                var presses = 0
                for button in combination {
                    for i in 0..<button.count {
                        if button[i] {
                            _lights[i].toggle()
                        }
                    }
                    presses += 1
                    if presses >= minimumPresses {
                        break
                    }
                }
                if presses >= minimumPresses {
                    break
                }
                if _lights == lights {
                    minimumPresses = min(minimumPresses, presses)
                }
            }
        }
        return minimumPresses
    }
    
    func determineMinimumPresses(buttons: [[Int]], joltages: [Int]) -> Int {
        let config = Z3Config()
        config.setParameter(name: "model", value: "true")
        let context = Z3Context(configuration: config)
        let optimize = context.makeOptimize()
        var constants: [Z3Int] = []
        for i in 0..<buttons.count {
            let n: Z3Int = context.makeConstant(name: "n\(i)")
            constants.append(n)
            optimize.assert(n >= 0)
        }
        for (i, joltage) in joltages.enumerated() {
            var equation: [Z3Int] = []
            for (j, button) in buttons.enumerated() {
                if button.contains(i) {
                    equation.append(constants[j])
                }
            }
            let addition = context.makeAdd(equation)
            optimize.assert(addition == context.makeInteger(Int32(joltage)))
        }
        let total = context.makeAdd(constants)
        let _ = optimize.minimize(total)
        guard optimize.check() == .satisfiable else {
            return 0
        }
        let result = Int(optimize.getModel().eval(total)!.numeralInt)
        return result
    }
}
