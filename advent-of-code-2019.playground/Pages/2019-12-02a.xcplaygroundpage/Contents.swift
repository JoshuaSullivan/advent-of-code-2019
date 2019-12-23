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

//: Convert the strings into Ints
var items = data.components(separatedBy: ",")
    .compactMap { Int($0) }

//: Perform the specified substitutions.
items[1] = 12
items[2] = 2

for index in stride(from: 0, to: items.count, by: 4) {
    let opCode = items[index]
    let dataAddress0 = items[index + 1]
    let dataAddress1 = items[index + 2]
    let storageAddress = items[index + 3]
    let data0 = items[dataAddress0]
    let data1 = items[dataAddress1]
    switch opCode {
    case 1: items[storageAddress] = data0 + data1
    case 2: items[storageAddress] = data0 * data1
    case 99: break
    default:
        fatalError("Unexpected opCode: \(opCode)")
    }
}
print(items)
