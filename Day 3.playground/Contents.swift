import Cocoa

/**
 --- Day 3: Crossed Wires ---

 The gravity assist was successful, and you're well on your way to the Venus refuelling station. During the rush back on Earth, the fuel management system wasn't completely installed, so that's next on the priority list.

 Opening the front panel reveals a jumble of wires. Specifically, two wires are connected to a central port and extend outward on a grid. You trace the path each wire takes as it leaves the central port, one wire per line of text (your puzzle input).

 The wires twist and turn, but the two wires occasionally cross paths. To fix the circuit, you need to find the intersection point closest to the central port. Because the wires are on a grid, use the Manhattan distance for this measurement. While the wires do technically cross right at the central port where they both start, this point does not count, nor does a wire count as crossing with itself.

 For example, if the first wire's path is R8,U5,L5,D3, then starting from the central port (o), it goes right 8, up 5, left 5, and finally down 3:

 ...........
 ...........
 ...........
 ....+----+.
 ....|....|.
 ....|....|.
 ....|....|.
 .........|.
 .o-------+.
 ...........
 Then, if the second wire's path is U7,R6,D4,L4, it goes up 7, right 6, down 4, and left 4:

 ...........
 .+-----+...
 .|.....|...
 .|..+--X-+.
 .|..|..|.|.
 .|.-X--+.|.
 .|..|....|.
 .|.......|.
 .o-------+.
 ...........
 These wires cross at two locations (marked X), but the lower-left one is closer to the central port: its distance is 3 + 3 = 6.

 Here are a few more examples:

 R75,D30,R83,U83,L12,D49,R71,U7,L72
 U62,R66,U55,R34,D71,R55,D58,R83 = distance 159
 R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
 U98,R91,D20,R16,D67,R40,U7,R15,U6,R7 = distance 135
 What is the Manhattan distance from the central port to the closest intersection?
 */
let fileUrl = Bundle.main.url(forResource: "PuzzleInput", withExtension: nil)
let data = try! Data(contentsOf: fileUrl!)
var inputLines = String(data: data, encoding: .utf8)!
    .components(separatedBy: .newlines)
var firstInputLine = inputLines[0].components(separatedBy: ",")
var secondInputLine = inputLines[1].components(separatedBy: ",")

typealias Instruction = (direction: String, amount: Int)
typealias Coordinate = (x: Int, y: Int)

func findCoordinatesForLine(path: [Instruction]) -> [Coordinate] {
    var x = 0
    var y = 0
    var coordinates: [Coordinate] = []
    
    for instruction in path {
        switch instruction.direction {
        case "L":
            x = x - instruction.amount
            break
        case "R":
            x = x + instruction.amount
            break
        case "U":
            y = y + instruction.amount
            break
        case "D":
            y = y - instruction.amount
            break
        default:
            break
        }
        coordinates.append(Coordinate(x, y))
    }
    
    return coordinates
}

func parseInstructions(instructionStrings:[String]) -> [Instruction] {
    var inst: [Instruction] = []
    for instructionString in instructionStrings {
        let index = instructionString.index(instructionString.startIndex, offsetBy: 1)
        let direction = String(instructionString[instructionString.startIndex..<index])
        let amount = Int(instructionString[index..<instructionString.endIndex]) ?? 0
        inst.append((direction: direction, amount: amount))
    }
    return inst
}

func findManhattanDistance(path: [String]) -> (Int, Int) {
    return (0,0)
}


print(parseInstructions(instructionStrings: ["R8","U5","L5","D3"]))
