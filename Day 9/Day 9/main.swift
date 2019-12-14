import Cocoa

let input = puzzleInput.components(separatedBy: ",").compactMap({ Int($0) })

func extractInstructionOpcode(_ input: Int) -> Int {
    return input % 100
}

func extractInstructionParameterModes(_ input: Int) -> [Int] {
    let remainder = (input - (input % 100)) / 100
    var result: [Int] = []
    var x = remainder
    
    while x > 0 {
        result.append(x % 10)
        x = x / 10
    }
    
    return result
}

let ADDITION = 1
let MULTIPLICATION = 2
let INPUT = 3
let OUTPUT = 4
let JUMP_IF_TRUE = 5
let JUMP_IF_FALSE = 6
let LESS_THAN = 7
let EQUALS = 8
let ADJUST_RELATIVE_BASE = 9

let HALT = 99

func runProgram(onInput: () -> Int, onOutput: (Int) -> Void) {
    var program = input
    var instructionPointer = 0
    var relativeBase = 0
    
    while instructionPointer < program.count - 1 {
        let instruction = extractInstructionOpcode(program[instructionPointer])
        guard instruction != HALT else { return }
        
        let parameterModes = extractInstructionParameterModes(program[instructionPointer])
        
        func write(_ value: Int, at address: Int) {
            if program.count > address {
                program[address] = value
                return
            }
            program.append(contentsOf: [Int](repeating: 0, count: address - program.count + 1))
            program[address] = value
        }
        
        func read(_ address: Int) -> Int {
            if program.count > address {
                return program[address]
            }
            return 0
        }
        
        func readParameter(_ index: Int) -> Int {
            let rawParameter = program[instructionPointer + index]
            let mode = parameterModes.count > index - 1 ? parameterModes[index - 1] : 0
            
            if mode == 0 {
                return program[rawParameter]
            } else if mode == 1 {
                return rawParameter
            }
            
            return program[rawParameter + relativeBase]
        }
        
        func writeParameter(_ index: Int) -> Int {
            let rawParameter = program[instructionPointer + index]
            let mode = parameterModes.count > index - 1 ? parameterModes[index - 1] : 0
            
            if mode == 0 || mode == 1 {
                return rawParameter
            }
            
            return rawParameter + relativeBase
        }
        
        switch instruction {
        case ADDITION:
            let sum = readParameter(1) + readParameter(2)
            write(sum, at: writeParameter(3))
            instructionPointer = instructionPointer + 4
            break
        case MULTIPLICATION:
            let product = readParameter(1) * readParameter(2)
            write(product, at: writeParameter(3))
            instructionPointer = instructionPointer + 4
            break
        case INPUT:
            let value = onInput()
            write(value, at: writeParameter(1))
            instructionPointer = instructionPointer + 2
            break
        case OUTPUT:
            onOutput(readParameter(1))
            instructionPointer = instructionPointer + 2
            break
        case JUMP_IF_TRUE:
            if readParameter(1) != 0 {
                instructionPointer = readParameter(2)
            } else {
                instructionPointer = instructionPointer + 3
            }
            break
        case JUMP_IF_FALSE:
            if readParameter(1) == 0 {
                instructionPointer = readParameter(2)
            } else {
                instructionPointer = instructionPointer + 3
            }
            break
        case LESS_THAN:
            let value = readParameter(1) < readParameter(2) ? 1 : 0
            write(value, at: writeParameter(3))
            instructionPointer = instructionPointer + 4
            break
        case EQUALS:
            let value = readParameter(1) == readParameter(2) ? 1 : 0
            write(value, at: writeParameter(3))
            instructionPointer = instructionPointer + 4
            break
        case ADJUST_RELATIVE_BASE:
            relativeBase = relativeBase + readParameter(1)
            instructionPointer = instructionPointer + 2
            break
        default:
            break
        }
        
    }
}

runProgram(onInput: { () -> Int in
    return 1
}) { output in
    print(output)
    assert(output == 2457252183)
}

runProgram(onInput: { () -> Int in
    return 2
}) { output in
    print(output)
    assert(output == 70634)
}
