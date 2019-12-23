//: # Advent of Code 2019
//: ### Day 1: The Tyranny of the Rocket Equation
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
let rows = data.components(separatedBy: "\n")
    .filter { !$0.isEmpty }
let masses = rows.compactMap { Int($0) }
guard masses.count == rows.count else {
    fatalError("Some rows could not be converted.")
}

//: Calculate the per-item fuel requirements
let fuelRequirements = masses.map { $0 / 3 - 2 }

//: Sum the individual requirements
let totalFuel = fuelRequirements.reduce(0, +)

//: Print out the result
print("Trip will require \(totalFuel) units of fuel.")
