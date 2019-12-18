import Cocoa

let input =
    """
3,8,1005,8,325,1106,0,11,0,0,0,104,1,104,0,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,101,0,8,28,2,3,7,10,2,1109,3,10,2,102,0,10,2,1005,12,10,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,0,10,4,10,101,0,8,67,2,109,12,10,1,1003,15,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,1,8,10,4,10,101,0,8,96,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,0,10,4,10,1002,8,1,119,3,8,102,-1,8,10,1001,10,1,10,4,10,1008,8,0,10,4,10,101,0,8,141,3,8,1002,8,-1,10,101,1,10,10,4,10,108,0,8,10,4,10,1001,8,0,162,1,106,17,10,1006,0,52,1006,0,73,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,1001,8,0,194,1006,0,97,1,1004,6,10,1006,0,32,2,8,20,10,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,1,10,4,10,102,1,8,231,1,1,15,10,1006,0,21,1,6,17,10,2,1005,8,10,3,8,102,-1,8,10,101,1,10,10,4,10,108,1,8,10,4,10,102,1,8,267,2,1007,10,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,1,10,4,10,102,1,8,294,1006,0,74,2,1003,2,10,1,107,1,10,101,1,9,9,1007,9,1042,10,1005,10,15,99,109,647,104,0,104,1,21101,936333018008,0,1,21101,342,0,0,1106,0,446,21102,937121129228,1,1,21101,0,353,0,1105,1,446,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,21101,0,209383001255,1,21102,400,1,0,1106,0,446,21101,0,28994371675,1,21101,411,0,0,1105,1,446,3,10,104,0,104,0,3,10,104,0,104,0,21101,867961824000,0,1,21101,0,434,0,1106,0,446,21102,1,983925674344,1,21101,0,445,0,1106,0,446,99,109,2,21201,-1,0,1,21102,40,1,2,21101,477,0,3,21102,467,1,0,1106,0,510,109,-2,2106,0,0,0,1,0,0,1,109,2,3,10,204,-1,1001,472,473,488,4,0,1001,472,1,472,108,4,472,10,1006,10,504,1101,0,0,472,109,-2,2106,0,0,0,109,4,1201,-1,0,509,1207,-3,0,10,1006,10,527,21102,1,0,-3,21202,-3,1,1,21201,-2,0,2,21102,1,1,3,21102,1,546,0,1106,0,551,109,-4,2105,1,0,109,5,1207,-3,1,10,1006,10,574,2207,-4,-2,10,1006,10,574,22101,0,-4,-4,1105,1,642,21202,-4,1,1,21201,-3,-1,2,21202,-2,2,3,21101,0,593,0,1105,1,551,22102,1,1,-4,21101,1,0,-1,2207,-4,-2,10,1006,10,612,21102,1,0,-1,22202,-2,-1,-2,2107,0,-3,10,1006,10,634,21201,-1,0,1,21101,634,0,0,105,1,509,21202,-2,-1,-2,22201,-4,-2,-4,109,-5,2106,0,0
""".components(separatedBy: ",").compactMap({ Int($0) })

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
                return read(rawParameter)
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

struct Coordinate {
    var x: Int
    var y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

extension Coordinate: Hashable {
    static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

enum Color: Int {
    case black
    case white
}

enum Direction: Int {
    case left
    case right
}

enum Heading {
    case north
    case east
    case south
    case west
}

func newHeading(_ heading: Heading, _ direction: Direction) -> Heading {
    if direction == .left {
        switch heading {
        case .north: return .west
        case .east: return .north
        case .south: return .east
        case .west: return .south
        }
    }
    switch heading {
    case .north: return .east
    case .east: return .south
    case .south: return .west
    case .west: return .north
    }
}

func runRobot() {
    let inputQueue = BlockingQueue(0)
    var map = [Coordinate: Color]()
    var currentHeading = Heading.north
    
    var position = Coordinate(0,0)
    
    func paint(_ color: Color) {
        map[position] = color

    }
    
    func turn(_ direction: Direction) {
        currentHeading = newHeading(currentHeading, direction)
    }
    
    func move() {
        var newCoordinate = position
        
        switch currentHeading {
        case .north: newCoordinate = Coordinate(position.x, position.y + 1)
        case .east: newCoordinate = Coordinate(position.x + 1, position.y)
        case .south: newCoordinate = Coordinate(position.x, position.y - 1)
        case .west: newCoordinate = Coordinate(position.x - 1, position.y)
        }
        
        position = newCoordinate
    }
    
    var firstOut = true
    
    runProgram(onInput: { () -> Int in
        let val = inputQueue.removeFirst()
        print("inputting", val)
        return val
    }) { output in
        print("outputting", output)
        if firstOut {
            paint(Color(rawValue: output)!)
            firstOut = false
        } else {
            firstOut = true
            turn(Direction(rawValue: output)!)
            move()
            if map[position] != nil {
                inputQueue.append(map[position]!.rawValue)
            } else {
                inputQueue.append(Color.black.rawValue)
            }
        }
    }
    
    print(map.count)
}

runRobot()
