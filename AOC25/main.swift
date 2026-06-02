//
//  main.swift
//  AOC25
//
//  Created by Peter Hagelund on 5/3/26.
//

import Foundation

let answers: [[Int]] = [
    [1147, 6789],
    [28844599675, 48778605167],
    [17311, 171419245422055],
    [1384, 8013],
    [789, 343329651880509],
    [6343365546996, 11136895955912],
    [1711, 36706966158365],
    [52668, 1474050600],
    [4761736832, 1452422268],
    [498, 17133],
    [696, 473741288064360],
    [485, 0],
]

func solveProblem(day: Int, problem: Int) throws -> Int {
    guard let puzzle = Puzzle.forDay(day: day) else {
        print("No puzzle for day \(day)")
        return 0
    }
    let begin = Date()
    let answer = try puzzle.solve(problem: problem)
    let end = Date()
    let duration = Int(end.timeIntervalSince(begin) * 1000)
    let correctAnswer = answers[day - 1][problem - 1]
    if answer == correctAnswer{
        print("Answer \(answer) is correct (\(duration) ms)")
    } else {
        let wrongness = if answer < correctAnswer { "small" } else { "large" }
        print("Answer \(answer) is NOT correct - it's too \(wrongness), should be \(correctAnswer)")
    }
    return answer
}

func solveAllProblems() throws {
    var puzzleCount = 0
    var correctCount = 0
    var incorrectCount = 0
    for day in 1...12 {
        guard let puzzle = Puzzle.forDay(day: day) else {
            print("No puzzle for day \(day)")
            continue
        }
        puzzleCount += 1
        for problem in 1...2 {
            print("Solving puzzle \(day) problem \(problem)...")
            let begin = Date()
            let answer = try puzzle.solve(problem: problem)
            let end = Date()
            let duration = Int(end.timeIntervalSince(begin) * 1000)
            let correctAnswer = answers[day - 1][problem - 1]
            if answer == correctAnswer{
                correctCount += 1
                print("Answer \(answer) is correct (\(duration) ms)")
            } else {
                incorrectCount += 1
                let wrongness = if answer < correctAnswer { "small" } else { "large" }
                print("Answer \(answer) is NOT correct - it's too \(wrongness), should be \(correctAnswer)")
            }
        }
    }
    print("Number of puzzles............: \(puzzleCount)")
    print("Number of correct answers....: \(correctCount)")
    print("Number of incorrect answers..: \(incorrectCount)")
}

func main() {
    if CommandLine.arguments.count < 2 {
        do {
            try solveAllProblems()
        } catch {
            print("Error occurred: \(error)")
        }
    } else {
        guard let day = Int(CommandLine.arguments[1]) else {
            print("Error: Argument '\(CommandLine.arguments[1])' is not a valid unsigned integer")
            exit(1)
        }
        guard 1...12 ~= day else {
            print("Error: Argument '\(CommandLine.arguments[1])' is not a valid AOC 2025 day (1 -> 12)")
            exit(1)
        }
        var problem: Int? = nil
        if CommandLine.arguments.count > 2 {
            problem = Int(CommandLine.arguments[2])
            if problem == nil {
                print("Error: Argument '\(CommandLine.arguments[2])' is not a valid unsigned integer")
                exit(1)
            }
            guard 1...2 ~= problem! else {
                print("Error: Argument '\(CommandLine.arguments[2])' is not a valid problem (1 or 2)")
                exit(1)
            }
        }
        do {
            if problem == nil {
                _ = try solveProblem(day: day, problem: 1)
                _ = try solveProblem(day: day, problem: 2)
            } else {
                _ = try solveProblem(day: day, problem: problem!)
            }
        } catch {
            print("Error occurred: \(error)")
        }
    }
}

main()
