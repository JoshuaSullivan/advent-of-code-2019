import Foundation

public struct Solver {
    public static func solve(input: String) -> Vector {
        let pathStrings = input.components(separatedBy: "\n").filter { !$0.isEmpty }
        guard pathStrings.count == 2 else {
            fatalError("Expected exactly 2 paths in the input.")
        }
        let paths = pathStrings.map { Path(pathData: $0) }
        let plottedPaths = paths.map { $0.plotPath() }
        let pointsA = Set<Vector>(plottedPaths[0])
        let pointsB = Set<Vector>(plottedPaths[1])

        let intersectionPoints = pointsA.intersection(pointsB)
            .filter({ $0 != .zero })

        guard !intersectionPoints.isEmpty else {
            fatalError("Found no points of intersection.")
        }

        guard let minima = intersectionPoints.min() else {
            fatalError("Failed to find minimum result.")
        }

        return minima
    }
}
