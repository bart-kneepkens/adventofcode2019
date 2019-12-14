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

var relativeBase = 0

@discardableResult
func runProgram(code: [Int], instructionPointer: Int = 0, onInput: () -> Int, onOutput: (Int) -> Void) -> [Int] {
    var codeCopy = code
    
    let instruction = extractInstructionOpcode(code[instructionPointer])
    guard instruction != 99 else { return codeCopy }
    
    let parameterModes = extractInstructionParameterModes(code[instructionPointer])
    
//    let firstParameterMode = parameterModes.count > 0 ? parameterModes[0] : 0
//    let secondParameterMode = parameterModes.count > 1 ? parameterModes[1] : 0
//    let thirdParameterMode = parameterModes.count > 2 ? parameterModes[2] : 0
    
    func readParameter(_ index: Int) -> Int {
        let rawParameter = codeCopy[instructionPointer + index]
        let mode = parameterModes.count > index - 1 ? parameterModes[index - 1] : 0
        
        if mode == 0 {
            return codeCopy[rawParameter]
        } else if mode == 1 {
            return rawParameter
        }
        
        return codeCopy[rawParameter + relativeBase]
    }
    
    func writeParameter(_ index: Int) -> Int {
        let rawParameter = codeCopy[instructionPointer + index]
        let mode = parameterModes.count > index - 1 ? parameterModes[index - 1] : 0
        
        if mode == 0 || mode == 1 {
            return rawParameter
        }
        
        return rawParameter + relativeBase
    }
    
    
    var newInstructionPointer = 0
    
    switch instruction {
    case ADDITION:
        let sum = readParameter(1) + readParameter(2)
        codeCopy[writeParameter(3)] = sum
        newInstructionPointer = instructionPointer + 4
        break
    case MULTIPLICATION:
        let product = readParameter(1) * readParameter(2)
        codeCopy[writeParameter(3)] = product
        newInstructionPointer = instructionPointer + 4
        break
    case INPUT:
        print("input please")
        let value = onInput()
        codeCopy[writeParameter(1)] = value
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
        if readParameter(1) < readParameter(2) {
            codeCopy[writeParameter(3)] = 1
        } else {
            codeCopy[writeParameter(3)] = 0
        }
        newInstructionPointer = instructionPointer + 4
        break
    case EQUALS:
        if readParameter(1) == readParameter(2) {
            codeCopy[writeParameter(3)] = 1
        } else {
            codeCopy[writeParameter(3)] = 0
        }
        newInstructionPointer = instructionPointer + 4
        break
    case ADJUST_RELATIVE_BASE:
        relativeBase = relativeBase + readParameter(1)
        newInstructionPointer = instructionPointer + 2
        break
    default:
        break
    }
    
    if (instructionPointer < codeCopy.count - 1) {
        codeCopy = runProgram(code: codeCopy,
                              instructionPointer: newInstructionPointer,
                              onInput: onInput,
                              onOutput: onOutput)
    }
    
    return codeCopy
}


var program = input
program.append(contentsOf: [Int](repeating: 0, count: 1024*1024))

runProgram(code: program, onInput: { () -> Int in
    let val = readLine()
    return Int(val!) ?? 0
}) { output in
    print(output)
}

//2457252183
