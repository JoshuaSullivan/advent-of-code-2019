import Foundation

public struct Solver {
    public static func solve(for range: CountableClosedRange<Int>) -> Int {
        return range.filter { index -> Bool in
            let digits = String(index)
                .map { String($0) }
                .compactMap { Int($0) }

            // Ensure that the digits are in ascending order.
            guard digits.sorted() == digits else { return false }

            // Test that we have at least 1 repeated digit.
            // A set will remove duplicates and, thus, have a lower count than the array.
            let digitSet = Set(digits)
            guard digitSet.count < digits.count else { return false }

            return true
        }.count
    }
}
