//
//  Puzzle.swift
//  AOC25
//
//  Created by Peter Hagelund on 5/3/26.
//

import Foundation

/// The possible errors thrown by the puzzles.
enum PuzzleError: Error {
    case unableToLoadInput
}

/// The puzzle base class.
class Puzzle: NSObject {
    /// The day.
    let day: Int
    // The puzzle input.
    let puzzleInput: PuzzleInput!
    
    /// Creates and returns the puzzle for the specified day.
    /// - Parameter day: The day (1 to 12).
    /// - Returns: The puzzle, if implemented.
    static func forDay(day: Int) -> Puzzle? {
        guard let cls = NSClassFromString("AOC25.Puzzle\(day)") as? Puzzle.Type else {
            return nil
        }
        return cls.init(day: day)
    }
    
    /// Initializes the puzzle.
    /// - Parameter day: The day (1 to 12).
    required init?(day: Int) {
        self.day = day
        let path = "/Users/peter/Documents/Xcode/AOC25/AOC25/Puzzles/puzzle_input\(self.day).txt"
        puzzleInput = PuzzleInput(path: path)
        super.init()
    }
    
    /// Solves the specified problem.
    /// - Parameter problem: The problem (1 or 2).
    /// - Returns: The answer to the problem.
    func solve(problem: Int) throws -> Int {
        var answer: Int
        switch problem {
        case 1:
            answer = try solveProblem1()
        case 2:
            answer = try solveProblem2()
        default:
            fatalError("Unable to solve problem \(problem)")
        }
        return answer
    }
    
    
    /// Solves problem 1.
    /// - Returns: The answer to problem 1.
    func solveProblem1() throws -> Int {
        print("No logic for solving problem 1")
        return 0
    }
    
    
    /// Solves problem 2.
    /// - Returns: The answer to problem 2.
    func solveProblem2() throws -> Int {
        print("No logic for solving problem 2")
        return 0
    }
}
