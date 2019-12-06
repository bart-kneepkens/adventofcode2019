/**
 --- Day 4: Secure Container ---

 You arrive at the Venus fuel depot only to discover it's protected by a password. The Elves had written the password on a sticky note, but someone threw it out.

 However, they do remember a few key facts about the password:

 - It is a six-digit number.
 - The value is within the range given in your puzzle input.
 - Two adjacent digits are the same (like 22 in 122345).
 - Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).
 - Other than the range rule, the following are true:

 111111 meets these criteria (double 11, never decreases).
 223450 does not meet these criteria (decreasing pair of digits 50).
 123789 does not meet these criteria (no double).
 How many different passwords within the range given in your puzzle input meet these criteria?
 */

func meetsCriteria(password: Int) -> Bool {
    
    var pw: [Int] = []
    var x = password

    while(x > 0) {
        pw.append(x % 10)
        x = x / 10
    }
    

    // is a six digit number
    let isSixDigits = pw.count == 6

    // Two adjacent digets are the same
    let uniqueDigits = Set<Int>(pw)
    let hasTwoAdjacentDigits = uniqueDigits.count < 6
    
    // Digits never decrease
    var digitsNeverDecrease = false
    var previous = 0
    for digit in pw {
        if (digit < previous) {
            digitsNeverDecrease = true
        } else {
            previous = digit
        }
    }

    return isSixDigits && hasTwoAdjacentDigits && !digitsNeverDecrease
}

func findAmountOfPasswordsWithinRange(_ lowerbounds: Int, _ upperbounds: Int) -> Int {
    var amount = 0
    
    for i in lowerbounds..<upperbounds {
        if(meetsCriteria(password: i)) {
            amount += 1
        }
    }
    
    return amount
}

print(meetsCriteria(password: 111111))
print(!meetsCriteria(password: 223450))
print(!meetsCriteria(password: 123789))

print(findAmountOfPasswordsWithinRange(347312, 805915))