import Cocoa

let WIDTH = 25
let HEIGHT = 6

let testInp = "123456789012"

func takeEveryNthString(_ layerString: String, n: Int) -> [String] {
    var intermediate = layerString
    var result: [String] = []
    
    while intermediate.count >= n {
        let index = intermediate.index(intermediate.startIndex, offsetBy: n)
        let substr = intermediate[intermediate.startIndex..<index]
        result.append(String(substr))
        intermediate = String(intermediate.suffix(from: index))
    }
    
    return result
}

func amountOfZeroesInLayer(_ layer: [String]) -> Int {
    var amount = 0
    
    for row in layer {
        amount += row.filter({ $0 == "0" }).count
    }
    
    return amount
}

extension Array where Element == String {
    func occurrenceOfCharacter(_ character: Character) -> Int {
        return self.map { str in
            return str.filter({ $0 == character }).count
        }.reduce(0,+)
    }
}


let layerStrings = takeEveryNthString(input, n: WIDTH * HEIGHT)

let layers = layerStrings.map({ takeEveryNthString($0, n: WIDTH) })

//print(layers)

let layerWithFewestZeroes = layers.min { lhs, rhs in
    return lhs.occurrenceOfCharacter("0") < rhs.occurrenceOfCharacter("0")
}!

let numberOf1Digits = layerWithFewestZeroes.occurrenceOfCharacter("1")
let numberOf2Digits = layerWithFewestZeroes.occurrenceOfCharacter("2")

print(numberOf1Digits * numberOf2Digits) // 1677
