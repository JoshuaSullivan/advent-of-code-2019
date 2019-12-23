//: # Advent of Code 2019
//: ### Day 2: 1202 Program Alarm
//: ### Question 1

import Foundation

//: Load the data.
guard
    let file = Bundle.main.url(forResource: "input", withExtension: "txt"),
    let data = try? String(contentsOf: file)
    else {
        fatalError("Can't load data.")
}

let result = Solver.solve(input: data)
print("\(result) with a distance of: \(result.manhattanDistance)")

//: [Next](@next)
