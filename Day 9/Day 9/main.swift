import Cocoa

let input = "3,8,1001,8,10,8,105,1,0,0,21,42,51,76,93,110,191,272,353,434,99999,3,9,1002,9,2,9,1001,9,3,9,1002,9,3,9,1001,9,2,9,4,9,99,3,9,1002,9,3,9,4,9,99,3,9,1002,9,4,9,101,5,9,9,1002,9,3,9,1001,9,4,9,1002,9,5,9,4,9,99,3,9,1002,9,5,9,101,3,9,9,102,5,9,9,4,9,99,3,9,1002,9,5,9,101,5,9,9,1002,9,2,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,99".components(separatedBy: ",").compactMap({ Int($0) })

class BlockingQueue<Element> {
    let dispatchQueue = DispatchQueue(label: "Queue")
    let semaphore = DispatchSemaphore(value: 0)
    
    var buffer: [Element] = []
    
    init(_ element: Element) {
        self.append(element)
    }
    
    func append(_ element: Element) {
        self.dispatchQueue.sync { buffer.append(element) }
        
        self.semaphore.signal()
    }
    
    func removeFirst() -> Element {
        self.semaphore.wait()
        
        var result: Element?
        
        self.dispatchQueue.sync { result = self.buffer.removeFirst() }
        
        return result!
    }
}

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

@discardableResult
func runProgram(code: [Int], instructionPointer: Int = 0, inputQueue: BlockingQueue<Int>, outputQueue: BlockingQueue<Int>) -> [Int] {
    var codeCopy = code
    
    let instruction = extractInstructionOpcode(code[instructionPointer])
    guard instruction != 99 else { return codeCopy }
    
    let parameterModes = extractInstructionParameterModes(code[instructionPointer])
    
    let firstParameterMode = parameterModes.count > 0 ? parameterModes[0] : 0
    let secondParameterMode = parameterModes.count > 1 ? parameterModes[1] : 0
    
    let firstParameter = codeCopy[instructionPointer + 1]
    let secondParameter = codeCopy[instructionPointer + 2]
    let thirdParameter = codeCopy.count > instructionPointer + 3 ? codeCopy[instructionPointer + 3] : 0
    
    let firstValue = firstParameterMode == 0 ? codeCopy[firstParameter] : firstParameter
    let secondValue = secondParameterMode == 0 && codeCopy.count > secondParameter ? codeCopy[secondParameter] : secondParameter
    
    var newInstructionPointer = 0
    
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
        let value = inputQueue.removeFirst()
        codeCopy[firstParameter] = value
        newInstructionPointer = instructionPointer + 2
        break
    case OUTPUT:
        outputQueue.append(firstValue)
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
                              inputQueue: inputQueue,
                              outputQueue: outputQueue)
    }
    
    return codeCopy
}

// This is very embarrassing please don't look
// I know I should implement a better algorithm such as Heap's, but I'm lagging behind on my calendar
func findAllUniqueCombinationsWithPossibleSettings(_ possibleSettings: Set<Int>) -> Set<[Int]> {
    var uniqueCombinations: Set<[Int]> = Set()
    
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

func runCombinationWithFeedbackLoop(combination: [Int]) -> Int {
    let queues = combination.map { BlockingQueue<Int>($0) }
    
    queues.first!.append(0)
    
    for amp in 0..<4 {
        let dispatch = DispatchQueue(label: "\(amp)")
        
        dispatch.async {
            runProgram(code: input, inputQueue: queues[amp], outputQueue: queues[amp + 1])
        }
    }
    
    runProgram(code: input, inputQueue: queues[4], outputQueue: queues[0])
    
    return queues[0].removeFirst()
}

//let part2Answer = findAllUniqueCombinationsWithPossibleSettings(Set([5, 6, 7, 8, 9]))
//                    .map({ runCombinationWithFeedbackLoop(combination: $0) })
//                    .max()
//
//print(part2Answer!)
