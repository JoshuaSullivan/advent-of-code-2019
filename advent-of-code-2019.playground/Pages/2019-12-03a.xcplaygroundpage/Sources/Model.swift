import Foundation

public struct Vector: Hashable, Equatable, Comparable, CustomStringConvertible {

    public static let zero = Vector(x: 0, y: 0)

    public let x: Int
    public let y: Int

    public var manhattanDistance: Int { abs(x) + abs(y) }

    public func adding(other vector: Vector) -> Vector {
        return Vector(x: self.x + vector.x, y: self.y + vector.y)
    }

    public func scaled(by factor: Int) -> Vector {
        return Vector(x: x * factor, y: y * factor)
    }

    public static func < (lhs: Vector, rhs: Vector) -> Bool {
        return lhs.manhattanDistance < rhs.manhattanDistance
    }

    public var description: String {
        return "Vector[x: \(x), y: \(y)]"
    }

    public var shortDescription: String { "(\(x), \(y))" }
}

public struct Path: CustomStringConvertible {

    public struct PathComponent: CustomStringConvertible {

        public enum Direction: String {
            case up = "U"
            case down = "D"
            case left = "L"
            case right = "R"

            public init?(char: Character) {
                let rawValue = String(char)
                guard let newCase = Direction(rawValue: rawValue) else { return nil }
                self = newCase
            }

            public var vector: Vector {
                switch self {
                case .up: return Vector(x: 0, y: 1)
                case .down: return Vector(x: 0, y: -1)
                case .left: return Vector(x: -1, y: 0)
                case .right: return Vector(x: 1, y: 0)
                }
            }
        }

        public let direction: Direction
        public let distance: Int

        public init(code: String) {
            let rawDistance = code.dropFirst()
            guard
                let char = code.first,
                let direction = Direction(char: char),
                let distance = Int(rawDistance)
                else {
                    fatalError("Unable to understand code: \(code)")
            }
            self.direction = direction
            self.distance = distance
        }

        public func plotPath(startingAt vector: Vector) -> [Vector] {
            let offset = direction.vector
            return (1...distance).map { index in
                return vector.adding(other: offset.scaled(by: index))
            }
        }

        public var description: String {
            return "PathComponent[\(code)]"
        }

        public var code: String { "\(direction.rawValue)\(distance)" }
    }

    public let components: [PathComponent]

    public init(pathData: String) {
        let pathComponents = pathData.components(separatedBy: ",").filter { !$0.isEmpty }
        components = pathComponents.compactMap { PathComponent(code: $0) }
        print("Created a path with \(components.count) components.")
    }

    public func plotPath() -> [Vector] {
        return components.reduce(into: [.zero]) { path, component in
            guard let start = path.last else { return }
            path.append(contentsOf: component.plotPath(startingAt: start))
        }
    }

    public var description: String {
        return "Path[components: \(components.count)]"
    }
}
