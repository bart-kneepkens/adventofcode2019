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

var relativeBase = 0

@discardableResult
func runProgram(_ program: [Int], instructionPointer: Int = 0, onInput: () -> Int, onOutput: (Int) -> Void) -> [Int] {
    var mutableProgram = program
    var newInstructionPointer = 0
    
    let instruction = extractInstructionOpcode(mutableProgram[instructionPointer])
    guard instruction != HALT else { return mutableProgram }
    
    let parameterModes = extractInstructionParameterModes(mutableProgram[instructionPointer])
    
    func write(_ value: Int, at address: Int) {
        if mutableProgram.count > address {
            mutableProgram[address] = value
            return
        }
        mutableProgram.append(contentsOf: [Int](repeating: 0, count: address - mutableProgram.count + 1))
        mutableProgram[address] = value
    }
    
    func read(_ address: Int) -> Int {
        if mutableProgram.count > address {
            return mutableProgram[address]
        }
        return 0
    }
    
    func readParameter(_ index: Int) -> Int {
        let rawParameter = mutableProgram[instructionPointer + index]
        let mode = parameterModes.count > index - 1 ? parameterModes[index - 1] : 0
        
        if mode == 0 {
            return mutableProgram[rawParameter]
        } else if mode == 1 {
            return rawParameter
        }
        
        return mutableProgram[rawParameter + relativeBase]
    }
    
    func writeParameter(_ index: Int) -> Int {
        let rawParameter = mutableProgram[instructionPointer + index]
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
        newInstructionPointer = instructionPointer + 4
        break
    case MULTIPLICATION:
        let product = readParameter(1) * readParameter(2)
        write(product, at: writeParameter(3))
        newInstructionPointer = instructionPointer + 4
        break
    case INPUT:
        let value = onInput()
        write(value, at: writeParameter(1))
        newInstructionPointer = instructionPointer + 2
        break
    case OUTPUT:
        onOutput(readParameter(1))
        newInstructionPointer = instructionPointer + 2
        break
    case JUMP_IF_TRUE:
        if readParameter(1) != 0 {
            newInstructionPointer = readParameter(2)
        } else {
            newInstructionPointer = instructionPointer + 3
        }
        break
    case JUMP_IF_FALSE:
        if readParameter(1) == 0 {
            newInstructionPointer = readParameter(2)
        } else {
            newInstructionPointer = instructionPointer + 3
        }
        break
    case LESS_THAN:
        let value = readParameter(1) < readParameter(2) ? 1 : 0
        write(value, at: writeParameter(3))
        newInstructionPointer = instructionPointer + 4
        break
    case EQUALS:
        let value = readParameter(1) == readParameter(2) ? 1 : 0
        write(value, at: writeParameter(3))
        newInstructionPointer = instructionPointer + 4
        break
    case ADJUST_RELATIVE_BASE:
        relativeBase = relativeBase + readParameter(1)
        newInstructionPointer = instructionPointer + 2
        break
    default:
        break
    }
    
    if (instructionPointer < mutableProgram.count - 1) {
        mutableProgram = runProgram(mutableProgram,
                                    instructionPointer: newInstructionPointer,
                                    onInput: onInput,
                                    onOutput: onOutput)
    }
    
    return mutableProgram
}

runProgram(input, onInput: { () -> Int in
    return 1
}) { output in
    print(output)
    assert(output == 2457252183)
}
