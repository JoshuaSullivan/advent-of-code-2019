import Foundation


class IntCodeComputer {

    var inputs: [Int]

    var outputs: [Int] = []

    var program: [Int]

    var programIndex: Int = 0

    init(program: [Int], diagnosticId: Int) {
        self.program = program + [0, 0, 0, 0]
        self.inputs = [diagnosticId]
    }

    func execute() -> [Int] {
        print("execute()")
        var isHalted = false
        repeat {
            let opCode = nextOpCode()
            print("opCode: \(opCode)")
            
            switch opCode.operation {

            case .add:
                let a = value(for: opCode.parameters[0], with: program)
                let b = value(for: opCode.parameters[1], with: program)
                let target = opCode.parameters[2].immediateValue
                program[target] = a + b
                print("\(target) : \(program[target])")

            case .multiply:
                let a = value(for: opCode.parameters[0], with: program)
                let b = value(for: opCode.parameters[1], with: program)
                let target = opCode.parameters[2].immediateValue
                program[target] = a * b
                print("\(target) : \(program[target])")

            case .input:
                guard let input = inputs.first else {
                    fatalError("No input available for an input OpCode.")
                }
                let target = opCode.parameters[0].immediateValue
                program[target] = input

            case .output:
                let outValue = value(for: opCode.parameters[0], with: program)
                outputs.append(outValue)

            case .jumpIfTrue:
                let a = value(for: opCode.parameters[0], with: program)
                let target = opCode.parameters[1].immediateValue
                if a != 0 {
                    programIndex = target
                    continue
                }

            case .jumpIfFalse:
                let a = value(for: opCode.parameters[0], with: program)
                let target = opCode.parameters[1].immediateValue
                if a == 0 {
                    programIndex = target
                    continue
                }

            case .lessThan:
                let a = value(for: opCode.parameters[0], with: program)
                let b = value(for: opCode.parameters[1], with: program)
                let target = opCode.parameters[2].immediateValue
                program[target] = a < b ? 1 : 0
                print("\(target) : \(program[target])")

            case .equals:
                let a = value(for: opCode.parameters[0], with: program)
                let b = value(for: opCode.parameters[1], with: program)
                let target = opCode.parameters[2].immediateValue
                program[target] = a == b ? 1 : 0
                print("\(target) : \(program[target])")

            case .halt:
                isHalted = true

            }
            programIndex += opCode.length
        } while !isHalted
        return outputs
    }

    private func nextOpCode() -> OpCode {
        print("")
        print("programIndex: \(programIndex)")
        let range = programIndex..<(programIndex + 4)
//        print("range: \(range)")
        let values = Array(program[range])
        print("values: \(values)")
        return OpCode(with: values)
    }

    private func value(for parameter: OpCode.Parameter, with program: [Int]) -> Int {
//        print("value(for: \(parameter), with:...)")
        switch parameter {
            case .address(let index): return program[index]
            case .immediate(let value): return value
        }
    }
}
