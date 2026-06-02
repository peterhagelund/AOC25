//
//  Puzzle11.swift
//  AOC25
//
//  Created by Peter Hagelund on 5/30/26.
//

import Foundation
import Graphs

class Puzzle11: Puzzle {
    override func solveProblem1() throws -> Int {
        var graph: InlineGraph<String, SimpleEdge<String>> = InlineGraph()
        for line in puzzleInput.lines {
            let parts = line.split(separator: ":")
            let source = String(parts[0])
            if !graph.vertices().contains(source) {
                graph.addVertex(source)
            }
            let destinations = parts[1].split(separator: " ").map { String($0) }
            for destination in destinations {
                if !graph.vertices().contains(destination) {
                    graph.addVertex(destination)
                }
                graph.addEdge(from: source, to: destination)
            }
        }
        let paths = graph.allPaths(from: "you", to: "out")
        let answer = paths.reduce(0) { count, _ in count + 1 }
        return answer
    }
    
    override func solveProblem2() throws -> Int {
        var answer = 0
        let fftToDac = numberOfPathsBetweenVertices(source: "fft", target: "dac")
        if fftToDac != 0 {
            let svrToFft = numberOfPathsBetweenVertices(source: "svr", target: "fft")
            let dacToOut = numberOfPathsBetweenVertices(source: "dac", target: "out")
            answer += fftToDac * svrToFft * dacToOut
        }
        let dacToFft = numberOfPathsBetweenVertices(source: "dac", target: "fft")
        if dacToFft != 0 {
            let svrToDac = numberOfPathsBetweenVertices(source: "svr", target: "dac")
            let fftToOut = numberOfPathsBetweenVertices(source: "fft", target: "out")
            answer += dacToFft * svrToDac * fftToOut
        }
        return answer
    }
    
    func numberOfPathsBetweenVertices(source: String, target: String) -> Int {
        var (graph, vertices) = createGraph()
        let sourceVertex = vertices[source]!
        let targetVertex = vertices[target]!
        var ancestors: Set<AdjacencyMatrix.Vertex> = Set()
        graph.findAncestors(of: targetVertex, ancestors: &ancestors)
        ancestors.insert(sourceVertex)
        ancestors.insert(targetVertex)
        for vertex in graph.vertices() {
            if !ancestors.contains(vertex) {
                graph.remove(vertex: vertex)
            }
        }
        let paths = graph.allPaths(from: sourceVertex, to: targetVertex)
        return paths.reduce(0) { count, _ in count + 1 }
    }
    
    func createGraph() -> (AdjacencyMatrix, Dictionary<String, AdjacencyMatrix.Vertex>) {
        var vertices: Dictionary<String, AdjacencyMatrix.Vertex> = Dictionary()
        var graph = AdjacencyMatrix()
        for line in puzzleInput.lines {
            let parts = line.split(separator: ":")
            let source = String(parts[0])
            var sourceVertex: AdjacencyMatrix.Vertex
            if vertices.keys.contains(source) {
                sourceVertex = vertices[source]!
            } else {
                sourceVertex = graph.addVertex()
                vertices[source] = sourceVertex
            }
            let destinations = parts[1].split(separator: " ").map { String($0) }
            for destination in destinations {
                var destinationVertex: AdjacencyMatrix.Vertex
                if vertices.keys.contains(destination) {
                    destinationVertex = vertices[destination]!
                } else {
                    destinationVertex = graph.addVertex()
                    vertices[destination] = destinationVertex
                }
                graph.addEdge(from: sourceVertex, to: destinationVertex)
            }
        }
        return (graph, vertices)
    }
}

extension AdjacencyMatrix {
    func findAncestors(of vertex: AdjacencyMatrix.Vertex, ancestors: inout Set<AdjacencyMatrix.Vertex>) {
        let predecessors = predecessors(of: vertex)
        for predecessor in predecessors {
            if !ancestors.contains(predecessor) {
                ancestors.insert(predecessor)
                findAncestors(of: predecessor, ancestors: &ancestors)
            }
        }
    }
}
