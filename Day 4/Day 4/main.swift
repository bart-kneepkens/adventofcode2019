func meetsCriteria(passwordDigits: [Int]) -> Bool {
    // Is a six digit number
    let isSixDigits = passwordDigits.count == 6
    
    // Digits never decrease
    var digitsNeverDecrease = false
    var previous = 0
    for digit in passwordDigits {
        if (digit < previous) {
            digitsNeverDecrease = true
        } else {
            previous = digit
        }
    }
    
    return isSixDigits && !digitsNeverDecrease
}

func containsTwoAdjacentDigits(passwordDigits: [Int]) -> Bool {
    let uniqueDigits = Set<Int>(passwordDigits)
    return uniqueDigits.count < 6
}

func containsOnlyTwoAdjacentDigits(passwordDigits: [Int]) -> Bool {
    var frequencyMap: [Int: Int] = [:]
    
    for digit in passwordDigits {
        guard let value = frequencyMap[digit] else { frequencyMap[digit] = 1; continue; }
        frequencyMap[digit] = value + 1
    }
    
    return frequencyMap.contains { pair in
        return pair.value == 2
    }
}

func findAmountOfPasswordsWithinRange(_ lowerbounds: Int, _ upperbounds: Int, _ extraCriteria: ([Int]) -> Bool) -> Int {
    var amount = 0
    
    for password in lowerbounds..<upperbounds {
        var passwordDigits: [Int] = []
        var x = password
        
        while (x > 0) {
            passwordDigits.append(x % 10)
            x = x / 10
        }
        passwordDigits.reverse()
        
        if(meetsCriteria(passwordDigits: passwordDigits) && extraCriteria(passwordDigits) ) {
            amount += 1
        }
    }
    
    return amount
}

// Part 1
assert(findAmountOfPasswordsWithinRange(347312, 805915, containsTwoAdjacentDigits) == 594)
assert(findAmountOfPasswordsWithinRange(347312, 805915, containsOnlyTwoAdjacentDigits) == 364)
