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

//: Recursive function to determine total fuel cost.
func calculateFuelRequrement(for mass: Int) -> Int {
    // Calculate the fuel using the simple formula.
    let fuel = mass / 3 - 2

    // If the result is 0 or less, the answer is 0.
    guard fuel > 0 else { return 0 }

    // Otherwise, calculate how much fuel is needed for the fuel you just added.
    return fuel + calculateFuelRequrement(for: fuel)
}

//: Convert the strings into Ints
let rows = data.components(separatedBy: "\n")
    .filter { !$0.isEmpty }
let masses = rows.compactMap { Int($0) }
guard masses.count == rows.count else {
    fatalError("Some rows could not be converted.")
}

//: Calculate the per-item fuel requirements
let fuelRequirements = masses.map { calculateFuelRequrement(for: $0) }

//: Sum the individual requirements
let totalFuel = fuelRequirements.reduce(0, +)

//: Print out the result
print("Trip will require \(totalFuel) units of fuel.")


