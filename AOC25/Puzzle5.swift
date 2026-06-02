//
//  Puzzle5.swift
//  AOC25
//
//  Created by Peter Hagelund on 5/25/26.
//

import Foundation

class Puzzle5: Puzzle {
    override func solveProblem1() throws -> Int {
        var answer = 0
        var ranges: [ClosedRange<Int>] = []
        for line in puzzleInput.lines {
            guard !line.isEmpty else {
                continue
            }
            if line.contains("-") {
                let ids = line.split(separator: "-", maxSplits: 2).map { Int($0)! }
                ranges.append(ids[0]...ids[1])
            } else {
                let id = Int(line)!
                for range in ranges {
                    if range ~= id {
                        answer += 1
                        break
                    }
                }
            }
        }
        return answer
    }
    
    override func solveProblem2() throws -> Int {
        var answer = 0
        var ranges: Set<ClosedRange<Int>> = Set()
        for line in puzzleInput.lines {
            guard !line.isEmpty else {
                break
            }
            let ids = line.split(separator: "-", maxSplits: 2).map { Int($0)! }
            ranges.insert(ids[0]...ids[1])
        }
        mergeRanges(ranges: &ranges)
        for range in ranges {
            answer += range.count
        }
        return answer
    }
    
    func mergeRanges(ranges: inout Set<ClosedRange<Int>>) {
        var merging: Bool
        repeat {
            merging = false
            for range1 in ranges {
                for range2 in ranges {
                    guard range1 != range2 else {
                        continue
                    }
                    guard range1.overlaps(range2) else {
                        continue
                    }
                    let range3 = min(range1.lowerBound, range2.lowerBound)...max(range1.upperBound, range2.upperBound)
                    ranges.remove(range1)
                    ranges.remove(range2)
                    ranges.insert(range3)
                    merging = true
                    break
                }
            }
        } while merging
    }
}
