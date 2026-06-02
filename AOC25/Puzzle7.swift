//
//  Puzzle7.swift
//  AOC25
//
//  Created by Peter Hagelund on 5/25/26.
//

import Foundation

class Puzzle7: Puzzle {
    override func solveProblem1() throws -> Int {
        var manifold = puzzleInput.lines.map { Array<Character>($0) }
        let ys = 0..<manifold.count
        let xs = 0..<manifold[0].count
        var answer = 0
        for y in ys {
            for x in xs {
                switch manifold[y][x] {
                case "S":
                    manifold[y + 1][x] = "|"
                case "^":
                    if manifold[y - 1][x] == "|" {
                        manifold[y][x - 1] = "|"
                        manifold[y][x + 1] = "|"
                        answer += 1
                    }
                default:
                    if y > 0 && manifold[y - 1][x] == "|" {
                        manifold[y][x] = "|"
                    }
                }
            }
        }
        return answer
    }
    
    override func solveProblem2() throws -> Int {
        var splitters: Set<Location> = Set()
        let manifold = puzzleInput.lines.map { Array<Character>($0) }
        let ys = 0..<manifold.count
        let xs = 0..<manifold[0].count
        var start = 0
        for y in ys {
            for x in xs {
                switch manifold[y][x] {
                case "S":
                    start = x
                case "^":
                    splitters.insert(Location(y: y, x: x))
                default:
                    continue
                }
            }
        }
        var cache: Dictionary<Location, Int> = Dictionary()
        let answer = doBeam(location: Location(y: 0, x: start), height: ys.upperBound, splitters: splitters, cache: &cache)
        return answer
    }
    
    func doBeam(location: Location, height: Int, splitters: Set<Location>, cache: inout Dictionary<Location, Int>) -> Int {
        if let count = cache[location] {
            return count
        }
        if location.y == height - 1 {
            cache[location] = 1
            return 1
        }
        if splitters.contains(location) {
            let count = doBeam(location: Location(y: location.y + 1, x: location.x - 1), height: height, splitters: splitters, cache: &cache) + doBeam(location: Location(y: location.y + 1, x: location.x + 1), height: height, splitters: splitters, cache: &cache)
            cache[location] = count
            return count
        }
        let count = doBeam(location: Location(y: location.y + 1, x: location.x), height: height, splitters: splitters, cache: &cache)
        cache[location] = count
        return count
    }
}
