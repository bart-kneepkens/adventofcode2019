import Cocoa

let input = "3,8,1001,8,10,8,105,1,0,0,21,42,51,76,93,110,191,272,353,434,99999,3,9,1002,9,2,9,1001,9,3,9,1002,9,3,9,1001,9,2,9,4,9,99,3,9,1002,9,3,9,4,9,99,3,9,1002,9,4,9,101,5,9,9,1002,9,3,9,1001,9,4,9,1002,9,5,9,4,9,99,3,9,1002,9,5,9,101,3,9,9,102,5,9,9,4,9,99,3,9,1002,9,5,9,101,5,9,9,1002,9,2,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,99".components(separatedBy: ",").compactMap({ Int($0) })

//let puzzleInput =
//"""
//3,225,1,225,6,6,1100,1,238,225,104,0,1101,9,90,224,1001,224,-99,224,4,224,102,8,223,223,1001,224,6,224,1,223,224,223,1102,26,62,225,1101,11,75,225,1101,90,43,225,2,70,35,224,101,-1716,224,224,4,224,1002,223,8,223,101,4,224,224,1,223,224,223,1101,94,66,225,1102,65,89,225,101,53,144,224,101,-134,224,224,4,224,1002,223,8,223,1001,224,5,224,1,224,223,223,1102,16,32,224,101,-512,224,224,4,224,102,8,223,223,101,5,224,224,1,224,223,223,1001,43,57,224,101,-147,224,224,4,224,102,8,223,223,101,4,224,224,1,223,224,223,1101,36,81,225,1002,39,9,224,1001,224,-99,224,4,224,1002,223,8,223,101,2,224,224,1,223,224,223,1,213,218,224,1001,224,-98,224,4,224,102,8,223,223,101,2,224,224,1,224,223,223,102,21,74,224,101,-1869,224,224,4,224,102,8,223,223,1001,224,7,224,1,224,223,223,1101,25,15,225,1101,64,73,225,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,1008,226,677,224,1002,223,2,223,1005,224,329,1001,223,1,223,1007,677,677,224,102,2,223,223,1005,224,344,101,1,223,223,108,226,677,224,102,2,223,223,1006,224,359,101,1,223,223,108,226,226,224,1002,223,2,223,1005,224,374,1001,223,1,223,7,226,226,224,1002,223,2,223,1006,224,389,1001,223,1,223,8,226,677,224,1002,223,2,223,1006,224,404,1001,223,1,223,107,677,677,224,1002,223,2,223,1006,224,419,101,1,223,223,1008,677,677,224,102,2,223,223,1006,224,434,101,1,223,223,1107,226,677,224,102,2,223,223,1005,224,449,1001,223,1,223,107,226,226,224,102,2,223,223,1006,224,464,101,1,223,223,107,226,677,224,102,2,223,223,1005,224,479,1001,223,1,223,8,677,226,224,102,2,223,223,1005,224,494,1001,223,1,223,1108,226,677,224,102,2,223,223,1006,224,509,101,1,223,223,1107,677,226,224,1002,223,2,223,1005,224,524,101,1,223,223,1008,226,226,224,1002,223,2,223,1005,224,539,101,1,223,223,7,226,677,224,1002,223,2,223,1005,224,554,101,1,223,223,1107,677,677,224,1002,223,2,223,1006,224,569,1001,223,1,223,8,226,226,224,1002,223,2,223,1006,224,584,101,1,223,223,1108,677,677,224,102,2,223,223,1005,224,599,101,1,223,223,108,677,677,224,1002,223,2,223,1006,224,614,101,1,223,223,1007,226,226,224,102,2,223,223,1005,224,629,1001,223,1,223,7,677,226,224,1002,223,2,223,1005,224,644,101,1,223,223,1007,226,677,224,102,2,223,223,1005,224,659,1001,223,1,223,1108,677,226,224,102,2,223,223,1006,224,674,101,1,223,223,4,223,99,226
//"""
//
//let input = puzzleInput.components(separatedBy: ",").compactMap({ Int($0) })

func extractInstructionOpcode(_ input: Int) -> Int {
    return input % 100
}

func extractInstructionParameterModes(_ input: Int) -> [Int] {
    let remainder = (input - (input % 100)) / 100
    var result: [Int] = []
    var x = remainder
    
    while(x > 0) {
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

@discardableResult
func runProgram(code: [Int], instructionPointer: Int = 0, simulatedInputs: [Int], simulatedInputPointer: Int = 0, onOutput: (Int) -> Void) -> [Int] {
    var codeCopy = code
    
    let instruction = extractInstructionOpcode(code[instructionPointer])
    guard instruction != 99 else { return codeCopy }
    
    let parameterModes = extractInstructionParameterModes(code[instructionPointer])
    
    let firstParameterMode = parameterModes.count > 0 ? parameterModes[0] : 0
    let secondParameterMode = parameterModes.count > 1 ? parameterModes[1] : 0
    
    let firstParameter = codeCopy[instructionPointer + 1]
    let secondParameter = codeCopy[instructionPointer + 2]
    let thirdParameter = codeCopy.count > instructionPointer + 2 ? codeCopy[instructionPointer + 3] : 0
    
    let firstValue = firstParameterMode == 0 ? codeCopy[firstParameter] : firstParameter
    let secondValue = secondParameterMode == 0 && codeCopy.count > secondParameter ? codeCopy[secondParameter] : secondParameter
    
    var newInstructionPointer = 0
    
    var newSimulatedInputPointer = simulatedInputPointer
    
    switch instruction {
    case ADDITION:
        
        let sum = firstValue + secondValue
        codeCopy[thirdParameter] = sum
        newInstructionPointer = instructionPointer + 4
        
        break
    case MULTIPLICATION:
        
        let product = firstValue * secondValue
        codeCopy[thirdParameter] = product
        newInstructionPointer = instructionPointer + 4
        
        break
    case INPUT:
        
        let simInput = simulatedInputs[simulatedInputPointer]
        print("Simulating input ", simInput)
        newSimulatedInputPointer += 1
        
        codeCopy[firstParameter] = simInput
        newInstructionPointer = instructionPointer + 2
        
        break
    case OUTPUT:
        
        onOutput(firstValue)
        newInstructionPointer = instructionPointer + 2
        
        break
    case JUMP_IF_TRUE:
        
        if firstValue != 0 {
            newInstructionPointer = secondValue
        } else {
            newInstructionPointer = instructionPointer + 3
        }
        
        break
    case JUMP_IF_FALSE:
        
        if firstValue == 0 {
            newInstructionPointer = secondValue
        } else {
            newInstructionPointer = instructionPointer + 3
        }
        
        break
    case LESS_THAN:
        
        if firstValue < secondValue {
            codeCopy[thirdParameter] = 1
        } else {
            codeCopy[thirdParameter] = 0
        }
        
        newInstructionPointer = instructionPointer + 4
        
        break
    case EQUALS:
        
        if firstValue == secondValue     {
            codeCopy[thirdParameter] = 1
        } else {
            codeCopy[thirdParameter] = 0
        }
        
        newInstructionPointer = instructionPointer + 4
        break
    default:
        break
    }
    
    if (instructionPointer < codeCopy.count - 1) {
        codeCopy = runProgram(code: codeCopy,
                              instructionPointer: newInstructionPointer,
                              simulatedInputs: simulatedInputs,
                              simulatedInputPointer: newSimulatedInputPointer,
                              onOutput: onOutput)
    }
    
    return codeCopy
}

func runCombinationOfPhaseSettings(_ combination: [Int]) -> Int {
    var previousOutput = 0
    
    for setting in combination {
        runProgram(code: input, simulatedInputs: [setting, previousOutput]) { output in
            previousOutput = output
        }
    }
    
    return previousOutput
}

// This is very embarrassing please don't look
func findAllUniqueCombinationsWithPossibleSettings(_ possibleSettings: Set<Int>) -> Set<[Int]> {
    var uniqueCombinations: Set<[Int]> = Set([[]])
    
    for firstSetting in possibleSettings {
        var p2 = possibleSettings
        p2.remove(firstSetting)
        
        for secondSetting in p2 {
            var p3 = p2
            p3.remove(secondSetting)
            
            for thirdSetting in p3 {
                var p4 = p3
                p4.remove(thirdSetting)
                
                for fourthSetting in p4 {
                    var p5 = p4
                    p5.remove(fourthSetting)
                    
                    for fifthSetting in p5 {
                        uniqueCombinations.insert([firstSetting, secondSetting, thirdSetting, fourthSetting, fifthSetting])
                    }
                }
            }
        }
    }
    
    return uniqueCombinations
}

// Part 1
let possibleCombinations = findAllUniqueCombinationsWithPossibleSettings(Set([0,1,2,3,4]))
var maximumThrust = 0

for combination in possibleCombinations {
    let out = runCombinationOfPhaseSettings(combination)
    if out > maximumThrust {
        maximumThrust = out
    }
}
print(maximumThrust)

