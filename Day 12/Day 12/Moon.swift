class Moon {
    var position: Coordinate
    var velocity: Coordinate
    
    init(_ x: Int, _ y: Int, _ z: Int) {
        self.position = Coordinate(x, y, z)
        self.velocity = Coordinate(0,0,0)
    }
    
    func applyGravity(_ otherMoon: Moon) {
        let otherPosition = otherMoon.position
        let xmod = gravityModifier(self.position.x, otherPosition.x)
        let ymod = gravityModifier(self.position.y, otherPosition.y)
        let zmod = gravityModifier(self.position.z, otherPosition.z)
        
        let v = Coordinate(xmod, ymod, zmod)
        self.velocity = self.velocity + v
    }
    
    func applyVelocity() {
        let p = self.position + self.velocity
        self.position = p
    }
    
    var potentialEnergy: Int {
        return abs(self.position.x) + abs(self.position.y) + abs(self.position.z)
    }
    
    var kineticEnergy: Int {
        return abs(self.velocity.x) + abs(self.velocity.y) + abs(self.velocity.z)
    }
    
    var totalEnergy: Int {
        return self.potentialEnergy * self.kineticEnergy
    }
}

extension Moon: Hashable {
    static func == (lhs: Moon, rhs: Moon) -> Bool {
        return lhs.position == rhs.position && lhs.velocity == rhs.velocity
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
        hasher.combine(velocity)
    }
}

extension Moon: CustomStringConvertible {
    var description: String {
        return "pos=\(self.position), vel=\(self.velocity)"
    }
}
