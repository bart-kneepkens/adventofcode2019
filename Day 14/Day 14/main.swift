import Cocoa

class Chemical: Hashable {
    var amount: Int
    var name: String
    
    init(_ amount: Int, _ name: String) {
        self.amount = amount
        self.name = name
    }
    
    static func ==(lhs: Chemical, rhs: Chemical) -> Bool {
        return lhs.amount == rhs.amount && lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(amount)
        hasher.combine(name)
    }
}

typealias Reaction = (input: Set<Chemical>, output: Chemical)
typealias Chemicals = [String: Int]

extension Dictionary where Key == String, Value == Int {
    mutating func put(_ element: Chemical) {
        if let existingValue = self[element.name] {
            self[element.name] = existingValue + element.amount
        } else {
            self[element.name] = element.amount
        }
    }
    
    mutating func take(_ element: Chemical) -> Bool {
        if let existingValue = self[element.name] {
            if element.amount <= existingValue {
                self[element.name] = existingValue - element.amount
                return true
            }
        }
        return false
    }
}

class Stash {
    var chemicals = Chemicals()
    
    func withdraw(_ chemical: Chemical) -> Bool {
        if chemical.name == "ORE" && self.chemicals["ORE"] == nil {
            return true
        }
        
        return chemicals.take(chemical)
    }
    
    func store(_ chemical: Chemical) {
        chemicals.put(chemical)
    }
    
    func quantity(of chemical: String) -> Int {
        return chemicals[chemical] ?? 0
    }
}

var stash = Stash()
var consumed = Chemicals()
var reactions: [Reaction] = []

@discardableResult
func generate(_ chemical: Chemical) -> Bool {
    guard let reaction = reactions.first(where: { $0.output.name == chemical.name }) else { return false }
    
    var numberOfReactions = chemical.amount / reaction.output.amount
    if chemical.amount % reaction.output.amount != 0 {
        numberOfReactions += 1
    }
    
    for input in reaction.input {
        let requiredQuantity = input.amount * numberOfReactions
        let requiredChemical = Chemical(requiredQuantity, input.name)
        while !stash.withdraw(requiredChemical) {
            let quantityToGenerate = requiredQuantity - stash.quantity(of: input.name)
            let chemicalToGenerate = Chemical(quantityToGenerate, input.name)
            let generated = generate(chemicalToGenerate)
            if !generated { return false }
        }
        consumed.put(requiredChemical)
    }
    
    let chemicalToStore = Chemical(reaction.output.amount * numberOfReactions, reaction.output.name)
    stash.store(chemicalToStore)
    return true
}

// Parse inputs
reactions = puzzleInput.components(separatedBy: .newlines).map { line -> Reaction in
    let components = line.components(separatedBy: "=>")
    let inputChemicalStrings = components[0].components(separatedBy: ",")
    let inputChemicals = inputChemicalStrings.map { ics -> Chemical in
        let chemComponents = ics.trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
        return Chemical(Int(chemComponents[0])!, chemComponents[1])
    }
    let outputChemicalComponents = components[1].components(separatedBy: " ")
    let outputChemical = Chemical(Int(outputChemicalComponents[1])!, outputChemicalComponents[2])
    return (Set(inputChemicals), outputChemical)
}

// Part 1
generate(Chemical(1, "FUEL"))
assert(consumed["ORE"]! == 278404) // 278404
