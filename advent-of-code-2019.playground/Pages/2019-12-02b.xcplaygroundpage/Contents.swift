//: # Advent of Code 2019
//: ### Day 2: 1202 Program Alarm
//: ### Question 2

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

let target = 19690720
let result = Solver.solve(program: initialState, for: target)
print("Result: \(result)")

