import Foundation

public struct Solver {
    public static func solve(for input: [Int], withId id: Int) -> Int {
        let computer = IntCodeComputer(program: input, diagnosticId: id)
        let outputs = computer.execute()
        print("Program Output: \(outputs.map { String($0) }.joined(separator: ", "))")
        return outputs.last!
    }
}
