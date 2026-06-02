//
//  Puzzle8.swift
//  AOC25
//
//  Created by Peter Hagelund on 5/25/26.
//

import Foundation

struct Box: Hashable {
    let x: Int
    let y: Int
    let z: Int
    
    func distance(to box: Box) -> Double {
        let dx = x - box.x
        let dy = y - box.y
        let dz = z - box.z
        return sqrt(Double(dx * dx) + Double(dy * dy) + Double(dz * dz))
    }
}

struct Connection {
    let box1: Box
    let box2: Box
    let distance: Double
}

class Puzzle8: Puzzle {
    override func solveProblem1() throws -> Int {
        var boxes: [Box] = []
        var circuits: [Set<Box>] = []
        for line in puzzleInput.lines {
            let values = line.split(separator: ",").map { Int($0)! }
            let box = Box(x: values[0], y: values[1], z: values[2])
            boxes.append(box)
            var circuit = Set<Box>()
            circuit.insert(box)
            circuits.append(circuit)
        }
        var connections: [Connection] = []
        for i in 0..<boxes.count {
            for j in i + 1..<boxes.count {
                let box1 = boxes[i]
                let box2 = boxes[j]
                let distance = box1.distance(to: box2)
                let connection = Connection(box1: box1, box2: box2, distance: distance)
                connections.append(connection)
            }
        }
        connections.sort { $0.distance < $1.distance }
        for index in 0..<1000 {
            let circuit1Index = circuits.firstIndex(where: { $0.contains(connections[index].box1) })!
            let circuit2Index = circuits.firstIndex(where: { $0.contains(connections[index].box2) })!
            if circuit1Index != circuit2Index {
                circuits[circuit1Index].formUnion(circuits[circuit2Index])
                circuits.remove(at: circuit2Index)
            }
        }
        circuits.sort { $0.count > $1.count }
        let answer = circuits[0].count * circuits[1].count * circuits[2].count
        return answer
    }
    
    override func solveProblem2() throws -> Int {
        var boxes: [Box] = []
        var circuits: [Set<Box>] = []
        for line in puzzleInput.lines {
            let values = line.split(separator: ",").map { Int($0)! }
            let box = Box(x: values[0], y: values[1], z: values[2])
            boxes.append(box)
            var circuit = Set<Box>()
            circuit.insert(box)
            circuits.append(circuit)
        }
        var connections: [Connection] = []
        for i in 0..<boxes.count {
            for j in i + 1..<boxes.count {
                let box1 = boxes[i]
                let box2 = boxes[j]
                let distance = box1.distance(to: box2)
                let connection = Connection(box1: box1, box2: box2, distance: distance)
                connections.append(connection)
            }
        }
        connections.sort { $0.distance < $1.distance }
        var answer = 0
        for connection in connections {
            let circuit1Index = circuits.firstIndex(where: { $0.contains(connection.box1) })!
            let circuit2Index = circuits.firstIndex(where: { $0.contains(connection.box2) })!
            if circuit1Index != circuit2Index {
                if circuits.count == 2 {
                    answer = connection.box1.x * connection.box2.x
                    break
                }
                circuits[circuit1Index].formUnion(circuits[circuit2Index])
                circuits.remove(at: circuit2Index)
            }
        }
        return answer
    }
}
