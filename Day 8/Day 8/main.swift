import Cocoa

let WIDTH = 25
let HEIGHT = 6

let BLACK_PIXEL = "0"
let WHITE_PIXEL = "1"
let TRANSPARENT_PIXEL = "2"

typealias Layer = [String]

extension Array where Element == String {
    func occurrenceOfCharacter(_ character: Character) -> Int {
        return self.map { str in
            return str.filter({ $0 == character }).count
        }.reduce(0,+)
    }
}

func takeEveryNthString(_ layerString: String, n: Int) -> [String] {
    var intermediate = layerString
    var result: [String] = []
    
    while intermediate.count >= n {
        let index = intermediate.index(intermediate.startIndex, offsetBy: n)
        result.append(String(intermediate.prefix(upTo: index)))
        intermediate = String(intermediate.suffix(from: index))
    }
    
    return result
}

func amountOfZeroesInLayer(_ layer: Layer) -> Int {
    var amount = 0
    
    for row in layer {
        amount += row.filter({ $0 == "0" }).count
    }
    
    return amount
}

let layerStrings = takeEveryNthString(input, n: WIDTH * HEIGHT)
let layers = layerStrings.map({ takeEveryNthString($0, n: WIDTH) })

let layerWithFewestZeroes: Layer = layers.min { $0.occurrenceOfCharacter("0") < $1.occurrenceOfCharacter("0")}!

let numberOf1Digits = layerWithFewestZeroes.occurrenceOfCharacter("1")
let numberOf2Digits = layerWithFewestZeroes.occurrenceOfCharacter("2")
assert(numberOf1Digits * numberOf2Digits == 1677) // 1677


// Part 2
func drawLayer(_ layer: Layer) {
    layer.map {
        $0.replacingOccurrences(of: BLACK_PIXEL, with: "⬛️")
            .replacingOccurrences(of: WHITE_PIXEL, with: "⬜️")
            .replacingOccurrences(of: TRANSPARENT_PIXEL, with: " ")
    }.forEach({ print($0) })
}

var finalLayer: Layer = [String](repeating: String(repeating: " ", count: WIDTH), count: HEIGHT)

layers.reversed().forEach { layer in
    for (rowIndex, row) in layer.enumerated() {
        var mutableRow = Array(finalLayer[rowIndex])
        
        row.enumerated()
            .filter({ String($1) != TRANSPARENT_PIXEL })
            .forEach { characterIndex, character in
                mutableRow[characterIndex] = character
        }
        
        finalLayer[rowIndex] = String(mutableRow)
    }
}

drawLayer(finalLayer)
