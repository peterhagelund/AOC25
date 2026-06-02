//
//  PuzzleInput.swift
//  AOC25
//
//  Created by Peter Hagelund on 5/3/26.
//

import Foundation

/// The puzzle input.
class PuzzleInput {
    /// The raw contents of the puzzle input `.txt` file.
    let contents: String
    /// The puzzle input as lines.
    let lines: [String]
    /// The height of the puzzle input.
    let height: Int
    /// The width of the puzzle input.
    let width: Int
    
    /// Initializes the puzzle input from the specified path.
    /// - Parameter path: The path to the `.txt` input file.
    init?(path: String) {
        do {
            contents = try String(contentsOfFile: path, encoding: .utf8).trimmingCharacters(in: .newlines)
            lines = contents.components(separatedBy: .newlines)
            height = lines.count
            width = lines.map { $0.count }.max() ?? 0
        } catch {
            return nil
        }
    }
}
