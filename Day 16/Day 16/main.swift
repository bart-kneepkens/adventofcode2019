import Cocoa

var input =
"""
59705379150220188753316412925237003623341873502562165618681895846838956306026981091618902964505317589975353803891340688726319912072762197208600522256226277045196745275925595285843490582257194963750523789260297737947126704668555847149125256177428007606338263660765335434914961324526565730304103857985860308906002394989471031058266433317378346888662323198499387391755140009824186662950694879934582661048464385141787363949242889652092761090657224259182589469166807788651557747631571357207637087168904251987880776566360681108470585488499889044851694035762709053586877815115448849654685763054406911855606283246118699187059424077564037176787976681309870931
"""

let PATTERN = [0, 1, 0, -1]

extension String {
    var consistsOfOnlyNumerals: Bool {
        get {
            return !self.contains(where: { Int(String($0)) == nil })
        }
    }
    var digits: [Int] {
        get {
            precondition(self.consistsOfOnlyNumerals)
            return self.compactMap({ Int(String($0)) })
        }
    }
}

extension Int {
    var onesDigit: Int {
        get {
            return self % 10
        }
    }
}


func apply(_ pattern: [Int], to input: [Int], repeater: Int = 0) -> Int {
    var fullPattern = [Int]()
    
    // Create long pattern array to hold all pattern values
    for p in pattern {
        for _ in 0..<repeater + 1 {
            fullPattern.append(p)
        }
    }
    
    // Repeat every pattern value multiplier amount of times
    let patternMultiplier = ((input.count - fullPattern.count) / pattern.count) + 1
    var extendedPattern = fullPattern
    extendedPattern.removeFirst()
    if patternMultiplier > 0 && extendedPattern.count < input.count {
        for _ in 0..<patternMultiplier {
            extendedPattern.append(contentsOf: fullPattern)
        }
    }
    
    // Apply the actual pattern (zip)
    var output = [Int]()
    for i in 0..<input.count {
        let value = input[i] * extendedPattern[i]
        output.append(value)
    }
    
    let sum = output.reduce(0, +)
    return abs(sum.onesDigit)
}

func phase(_ input: [Int]) -> [Int]{
    var results = [Int]()
    for i in 0..<input.count {
        results.append(apply(PATTERN, to: input, repeater: i))
    }
    return results
}

func fft(_ input: String, _ phases: Int) -> String {
    var previousResult = input.digits
    for _ in 0..<phases {
        previousResult = phase(previousResult)
    }
    return previousResult.map({ String($0) }).joined()
}

assert(fft("80871224585914546619083218645595", 100).prefix(8) == "24176176")
assert(fft("19617804207202209144916044189917", 100).prefix(8) == "73745418")
assert(fft("69317163492948606335995924319873", 100).prefix(8) == "52432133")
print(fft(input, 100).prefix(8))
