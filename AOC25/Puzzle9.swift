//
//  Puzzle9.swift
//  AOC25
//
//  Created by Peter Hagelund on 5/25/26.
//

import Foundation
import DequeModule

struct Tile: Hashable {
    let x: Int
    let y: Int
    
    func tile(offsetBy delta: (x: Int, y: Int)) -> Tile {
        return Tile(x: x + delta.x, y: y + delta.y)
    }
}

struct Line: Hashable {
    let tile1: Tile
    let tile2: Tile
}

struct Rectangle: Hashable {
    let tile1: Tile
    let tile2: Tile
    let area: Int
}

fileprivate let deltas = [
    (x: -1, y: 0),
    (x: 1, y: 0),
    (x: 0, y: -1),
    (x: 0, y: 1),
]

class Puzzle9: Puzzle {
    override func solveProblem1() throws -> Int {
        var tiles: [Tile] = []
        for line in puzzleInput.lines {
            let values = line.split(separator: ",").map { Int($0)! }
            tiles.append(Tile(x: values[0], y: values[1]))
        }
        var answer = 0
        for i in 0..<tiles.count {
            for j in i + 1..<tiles.count {
                let dx = abs(1 + tiles[i].x - tiles[j].x)
                let dy = abs(1 + tiles[i].y - tiles[j].y)
                let area = dx * dy
                answer = max(answer, area)
            }
        }
        return answer
    }
    
    override func solveProblem2() throws -> Int {
        var tiles: [Tile] = []
        for line in puzzleInput.lines {
            let values = line.split(separator: ",").map { Int($0)! }
            tiles.append(Tile(x: values[0], y: values[1]))
        }
        let xs = Set(tiles.map { $0.x }).sorted()
        let ys = Set(tiles.map { $0.y }).sorted()
        let floor = createCompressedFloor(tiles: tiles, xs: xs, ys: ys)
        var rectangles: [Rectangle] = []
        for i in 0..<tiles.count {
            for j in 0..<i {
                let tile1 = tiles[i]
                let tile2 = tiles[j]
                if isValid(tile1: tile1, tile2: tile2, xs: xs, ys: ys, floor: floor) {
                    let area = (abs(tile1.x - tile2.x) + 1) * (abs(tile1.y - tile2.y) + 1)
                    rectangles.append(Rectangle(tile1: tile1, tile2: tile2, area: area))
                }
            }
        }
        rectangles.sort { $0.area > $1.area}
        let rectangle = rectangles[0]
        return rectangle.area
    }
    
    func createCompressedFloor(tiles: [Tile], xs: [Int], ys: [Int]) -> [[Int]] {
        var floor = Array(repeating: Array(repeating: 0, count: ys.count * 2 - 1), count: xs.count * 2 - 1)
        let lines = createLines(tiles: tiles)
        var count = 0
        for line in lines {
            let (compressedX1, compressedX2) = getCompressedXs(tile1: line.tile1, tile2: line.tile2, xs: xs)
            let (compressedY1, compressedY2) = getCompressedYs(tile1: line.tile1, tile2: line.tile2, ys: ys)
            for x in compressedX1...compressedX2 {
                for y in compressedY1...compressedY2 {
                    floor[x][y] = 1
                    count += 1
                }
            }
        }
        let seed = [Tile(x: -1, y: -1)]
        var queue = Deque(seed)
        var outside = Set(seed)
        while !queue.isEmpty {
            let tile = queue.popFirst()!
            for delta in deltas {
                let newTile = tile.tile(offsetBy: delta)
                guard -1...floor.count ~= newTile.x, -1...floor[0].count ~= newTile.y else {
                    continue
                }
                if 0..<floor.count ~= newTile.x && 0..<floor[0].count ~= newTile.y && floor[newTile.x][newTile.y] == 1 {
                    continue
                }
                if outside.contains(newTile) {
                    continue
                }
                outside.insert(newTile)
                queue.append(newTile)
            }
        }
        for x in 0..<floor.count {
            for y in 0..<floor[0].count {
                guard floor[x][y] == 0 else {
                    continue
                }
                let tile = Tile(x: x, y: y)
                if outside.contains(tile) {
                    continue
                }
                floor[x][y] = 1
            }
        }
        return floor
    }

    func createLines(tiles: [Tile]) -> [Line] {
        var lines: [Line] = []
        for i in 0..<tiles.count {
            var j = i + 1
            if j == tiles.count {
                j = 0
            }
            lines.append(Line(tile1: tiles[i], tile2: tiles[j]))
        }
        return lines
    }
    
    func isValid(tile1: Tile, tile2: Tile, xs: [Int], ys: [Int], floor: [[Int]]) -> Bool {
        let (compressedX1, compressedX2) = getCompressedXs(tile1: tile1, tile2: tile2, xs: xs)
        let (compressedY1, compressedY2) = getCompressedYs(tile1: tile1, tile2: tile2, ys: ys)
        for x in compressedX1..<compressedX2 {
            for y in compressedY1..<compressedY2 {
                guard floor[x][y] == 1 else {
                    return false
                }
            }
        }
        return true
    }
    
    func getCompressedXs(tile1: Tile, tile2: Tile, xs: [Int]) -> (compressedX1: Int, compressedX2: Int) {
        let x1 = xs.firstIndex(of: tile1.x)! * 2
        let x2 = xs.firstIndex(of: tile2.x)! * 2
        let compressedX1 = min(x1, x2)
        let compressedX2 = max(x1, x2)
        return (compressedX1: compressedX1, compressedX2: compressedX2)
    }
    
    func getCompressedYs(tile1: Tile, tile2: Tile, ys: [Int]) -> (compressedY1: Int, compressedY2: Int) {
        let y1 = ys.firstIndex(of: tile1.y)! * 2
        let y2 = ys.firstIndex(of: tile2.y)! * 2
        let compressedY1 = min(y1, y2)
        let compressedY2 = max(y1, y2)
        return (compressedY1: compressedY1, compressedY2: compressedY2)
    }
}
