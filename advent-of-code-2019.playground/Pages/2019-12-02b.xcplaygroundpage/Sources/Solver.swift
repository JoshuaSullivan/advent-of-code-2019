import Foundation

public struct Solver {

    public static func solve(program: [Int], for target: Int) -> Int {
        for noun in 0...99 {
            for verb in 0...99 {
                var items = program
                items[1] = noun
                items[2] = verb
                if calculateValue(for: items) == target {
                    return noun * 100 + verb
                }
            }
        }
        fatalError("Failed to find solution.")
    }

    private static func calculateValue(for items: [Int]) -> Int {
        var items = items
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
        return items[0]
    }
}
