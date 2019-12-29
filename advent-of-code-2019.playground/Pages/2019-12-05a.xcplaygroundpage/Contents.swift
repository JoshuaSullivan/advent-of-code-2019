//: # Advent of Code 2019
//: ### Day 5: Sunny with a Chance of Asteroids
//: ### Question 1

import Foundation

//: Load the data.
guard
    let file = Bundle.main.url(forResource: "input", withExtension: "txt"),
    let data = try? String(contentsOf: file)
    else {
        fatalError("Can't load data.")
}

//: Convert the strings into Ints
let initialState = data.components(separatedBy: ",")
    .compactMap { Int($0) }

let diagnosticId = 1
let result = Solver.solve(for: initialState, withId: diagnosticId)
print("Result: \(result)")
