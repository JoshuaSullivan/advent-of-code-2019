import Foundation

public struct Solver {
    public static func solve(for range: CountableClosedRange<Int>) -> Int {
        return range.filter { index -> Bool in
            let digits = String(index)
                .map { String($0) }
                .compactMap { Int($0) }

            // Ensure that the digits are in ascending order.
            guard digits.sorted() == digits else { return false }

            // Count the occurrance of each digit in the number.
            // A match will have at least one value of "2".
            let digitMap: [Int: Int] = digits.reduce(into: [:]) { (result, value) in
                result[value, default: 0] += 1
            }
            return digitMap.values.contains(2)
        }.count
    }
}
