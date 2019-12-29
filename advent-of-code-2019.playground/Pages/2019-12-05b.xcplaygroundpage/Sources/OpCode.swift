import Foundation

/// A single instruction in the program's execution.
///
struct OpCode: CustomStringConvertible {

    /// The type of operation to perform.
    ///
    enum Operation: Int, CustomStringConvertible {
        /// Add first two parameters together and store at location of 3rd parameter.
        case add = 1

        /// Multiply first two parameters together and store at location of 3rd parameter.
        case multiply = 2

        /// Take input and write it to the location of the parameter.
        case input = 3

        /// Read from location and output it.
        case output = 4

        case jumpIfTrue = 5

        case jumpIfFalse = 6

        case lessThan = 7

        case equals = 8

        /// Stop the program.
        case halt = 99

        var parameterCount: Int {
            switch self {
            case .add, .multiply, .lessThan, .equals: return 3
            case .input, .output: return 1
            case .jumpIfTrue, .jumpIfFalse: return 2
            case .halt: return 0
            }
        }

        var description: String {
            switch self {
            case .add: return "ADD"
            case .multiply: return "MUL"
            case .input: return "INP"
            case .output: return "OUT"
            case .jumpIfFalse = "JPF"
            case .jumpIfTrue = "JPT"
            case .lessThan = "LES"
            case .equals = "EQL"
            case .halt: return "END"
            }
        }
    }

    /// An argument for the operation.
    ///
    enum Parameter: CustomStringConvertible {

        /// The argument is an address position in memory that the value should be read from.
        ///
        case address(Int)

        /// The argument is the value to be used.
        case immediate(Int)

        var description: String {
            switch self {
            case .address(let value): return "A(\(value))"
            case .immediate(let value): return "I(\(value))"
            }
        }

        var immediateValue: Int {
            switch self {
                case .address(let value): return value
                case .immediate(let value): return value
            }
        }
    }

    /// The operation to perform.
    ///
    let operation: Operation

    /// The arguments for the operation.
    ///
    let parameters: [Parameter]

    /// Return the length of the OpCode in memory. Used to advance the program pointer.
    ///
    var length: Int {
        switch operation {
            case .add, .multiply, .jumpIfFalse, .jumpIfTrue: return 4
            case .lessThan, .equals: return 3
            case .input, .output: return 2
            case .halt: return 1
        }
    }

    init(with data: [Int]) {
        // Make sure we've been sent at least 4 values... we may not use all of them.
        guard
            data.count >= 4,
            let code = data.first else {
            fatalError("OpCode initialized without at least 4 values.")
        }

        // Break the number into its digits.
        let rawOperation: Int
        let modeDigits: [Int]
        if code <= 99 {
            // There are no mode digits.
            rawOperation = code

            // Attempt to create an Operation from the digits.
            guard let operation = Operation(rawValue: rawOperation) else {
                fatalError("Unknown operation encountered: \(rawOperation)")
            }

            // Store the operation.
            self.operation = operation

            // Everything is mode 0 in this case.
            modeDigits = [0, 0, 0]
        } else {
            let digits = String(code)
                .map { String($0) }
                .compactMap { Int($0) }

            // The last 2 digits are the operation code.
            let operationDigits = Array(digits.suffix(2))

            // Verify that we got 2 digits.
            guard operationDigits.count == 2 else {
                fatalError("Did not find 2 digits for an instruction code.")
            }

            // Recombine the digits.
            rawOperation = operationDigits[0] * 10 + operationDigits[1]

            // Attempt to create an Operation from the digits.
            guard let operation = Operation(rawValue: rawOperation) else {
                fatalError("Unknown operation encountered: \(rawOperation)")
            }

            // Store the operation.
            self.operation = operation

            // The rest of the code digits are the parameter mode values. They are stored in
            // reverse order, so we flip the list. It is cast to the array so we can append
            // additional values if necessary.
            var rawModeDigits = Array<Int>(digits.dropLast(2).reversed())

            // Pad out the mode digits array if it's shorter than the number of parameters for the
            // operation. This is because leading zeroes are dropped in the code and must now be
            // restored as trailing zeroes.
            while rawModeDigits.count < operation.parameterCount { rawModeDigits.append(0) }

            // Save the digits.
            modeDigits = rawModeDigits

        }

        // Drop the code value and take the rest as the parameter values.
        let parameterValues = Array<Int>(data.dropFirst())

        // Combine the mode digits with the values to create Parameter objects which encode how each
        // value should be treated.
        let parameters: [Parameter] = (0..<operation.parameterCount).map { index in
            let mode = modeDigits[index]
            let value = parameterValues[index]
            switch mode {
            case 0: return .address(value)
            case 1: return .immediate(value)
            default: fatalError("Unrecognized mode digit: \(mode)")
            }
        }

        self.parameters = parameters
    }

    var description: String {
        return "\(operation.description)[\(parameters.map { $0.description }))]"
    }
}
