import Cocoa

var input = puzzleInput.components(separatedBy: ",").compactMap({ Int($0) })

func runProgram(onInput: () -> Int, onOutput: (Int) -> Bool) {
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
    
    var program = input
    var instructionPointer = 0
    var relativeBase = 0
    var shouldEnd = false
    
    while instructionPointer < program.count - 1 && !shouldEnd {
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
            shouldEnd = onOutput(readParameter(1))
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

enum Move: Int {
    case north = 1
    case south = 2
    case west = 3
    case east = 4
    
    var reversed: Move {
        get {
            switch self {
            case .north: return .south
            case .south: return .north
            case .east: return .west
            case .west: return .east
            }
        }
    }
}

enum Tile {
    case empty
    case wall
    case oxygen
    case undefined
}

extension Tile: CustomStringConvertible {
    var description: String {
        switch self {
        case .empty: return " "
        case .wall: return "#"
        case .oxygen: return "O"
        case .undefined: return "u"
        }
    }
}

let WALL_HIT = 0
let HAS_MOVED = 1
let HAS_MOVED_HIT_OXYGEN_SYSTEM = 2

let allMoves: [Move] = [.north, .south, .west, .east]

func findPathToOxygen() -> (path: [Move], map: [Coordinate: Tile]) {
    var path = [(coordinate: Coordinate, move: Move)]()
    var position = Coordinate(0,0)
    var nextMove: Move = .west
    var map: [Coordinate: Tile] = [position: .empty]
    
    runProgram(onInput: { () -> Int in
        let neighboringTiles = allMoves.map { move -> (move: Move, tile: Tile) in
            let coordinate = position.moved(move)
            return (move, map[coordinate] ?? .undefined)
        }
        
        if let nextStep = neighboringTiles.first(where: { $0.tile == .undefined }) {
            nextMove = nextStep.move
        } else {
            // There is no undefined adjacent tile. take a step back.
            nextMove = path.last!.move.reversed
        }

        return nextMove.rawValue
    }, onOutput: { output in
        switch(output) {
        case WALL_HIT:
            map[position.moved(nextMove)] = .wall
            break
        case HAS_MOVED:
            let previousPosition = position
            position = position.moved(nextMove)
            map[previousPosition] = .empty
            
            let lastPosition = path.last?.coordinate
            
            if lastPosition == position {
                path.removeLast() // No steps taken == no steps possible == dead end
            } else {
                path.append((previousPosition, nextMove))
            }
            break
        case HAS_MOVED_HIT_OXYGEN_SYSTEM:
            let previousPostion = position
            map[position] = .empty
            map[position.moved(nextMove)] = .oxygen
            path.append((previousPostion, nextMove))
            return true
        default: break
        }
        
        return false
    })
    
    return (path.map({ $0.move }), map)
}


// Part 1
let resultMovePath = findPathToOxygen().path
assert(resultMovePath.count == 304)

// Part 2

var map = findPathToOxygen().map
var oxygenEverywhere = false
var minutes = 0

while !oxygenEverywhere {
    // fill all empty spaces with the holy oxygen
    let existingOxygenLocations = map.filter({ $0.value == .oxygen })
    existingOxygenLocations.forEach { location in
        let neighboringLocations = allMoves.map({ location.key.moved($0) })
        neighboringLocations.forEach { coordinate in
            if map[coordinate] == .empty {
                map[coordinate] = .oxygen
            }
        }
        
    }
    minutes += 1
    
    oxygenEverywhere = map.filter({ $0.value == .empty }).count == 0
}

assert(minutes == 310)
