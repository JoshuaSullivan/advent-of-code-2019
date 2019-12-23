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

        print("Found \(intersectionPoints.count) intersections.")

        intersectionPoints.enumerated().forEach { (index, point) in
            print("[\(index)] \(point) - \(combinedSteps(for: point, in: plottedPaths[0], and: plottedPaths[1]))")
        }

        guard let minima = intersectionPoints.min(by: { (pointA, pointB) -> Bool in
            let stepsA = combinedSteps(for: pointA, in: plottedPaths[0], and: plottedPaths[1])
            let stepsB = combinedSteps(for: pointB, in: plottedPaths[0], and: plottedPaths[1])
            return stepsA < stepsB
        }) else {
            fatalError("Failed to find minimum result.")
        }

        return minima
    }

    private static func combinedSteps(for point: Vector, in listA: [Vector], and listB: [Vector]) -> Int {
        guard
            let indexA = listA.firstIndex(of: point),
            let indexB = listB.firstIndex(of: point)
        else {
            return Int.max
        }
        return Int(indexA) + Int(indexB)
    }
}
