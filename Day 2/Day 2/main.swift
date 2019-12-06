import Cocoa

var input = "1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,13,1,19,1,5,19,23,2,10,23,27,1,27,5,31,2,9,31,35,1,35,5,39,2,6,39,43,1,43,5,47,2,47,10,51,2,51,6,55,1,5,55,59,2,10,59,63,1,63,6,67,2,67,6,71,1,71,5,75,1,13,75,79,1,6,79,83,2,83,13,87,1,87,6,91,1,10,91,95,1,95,9,99,2,99,13,103,1,103,6,107,2,107,6,111,1,111,2,115,1,115,13,0,99,2,0,14,0".components(separatedBy: ",")
    .compactMap({ Int($0) })

func runProgram(code: [Int], instructionIndex: Int = 0) -> [Int] {
    var codeCopy = code
    
    let instruction = code[instructionIndex]
    
    guard instruction != 99 else { return codeCopy }
    
    let firstIndex = codeCopy[instructionIndex + 1]
    let secondIndex = codeCopy[instructionIndex + 2]
    let destinationIndex = codeCopy[instructionIndex + 3]
    let first = codeCopy[firstIndex]
    let second = codeCopy[secondIndex]
    
    if (instruction == 1) {
        // Addition
        let sum = first + second
        codeCopy[destinationIndex] = sum
    } else {
        // Multiplication
        let product = first * second
        codeCopy[destinationIndex] = product
    }
    
    let newIndex = instructionIndex + 4
    
    if (instructionIndex < codeCopy.count - 1) {
        codeCopy = runProgram(code: codeCopy, instructionIndex: newIndex)
    }

    return codeCopy
}


// Provided testcases
assert(runProgram(code: [1,0,0,0,99]) == [2,0,0,0,99])
assert(runProgram(code: [2,3,0,3,99]) == [2,3,0,6,99])
assert(runProgram(code: [2,4,4,5,99,0]) == [2,4,4,5,99,9801])
assert(runProgram(code: [1,1,1,4,99,5,6,0,99]) == [30,1,1,4,2,5,6,0,99])

// Result preparation
input[1] = 12
input[2] = 2

print(runProgram(code: input)[0]) // 4714701

// --- Part Two ---

func runWithNounAndVerb(noun: Int, verb: Int) -> Int {
    var inputCopy = input;
    inputCopy[1] = noun
    inputCopy[2] = verb
    return runProgram(code: inputCopy)[0]
}

// Verb seems to be directly related to the last 2 digits of the result
// Last two digits = verb + 2

func findNounAndVerb(for number: Int) -> (Int, Int) {
    // Find the verb first
    let verb = (number % 100) + 1
    
    for i in 0...99 {
        let result = runWithNounAndVerb(noun: i, verb: verb)
        if (result == number) {
            return (i, verb)
        }
    }
    
    return (0, 0)
}

assert(findNounAndVerb(for: 4714701) == (12, 2)) // Part 1 testcase
let partTwoResult = findNounAndVerb(for: 19690720)
assert(partTwoResult == (51, 21))
let answer = 100 * partTwoResult.0 + partTwoResult.1
print(answer)
