
enum Axis {
    case x, y, z
}

class Moon {
    var position: Coordinate
    var velocity: Coordinate
    
    init(_ x: Int, _ y: Int, _ z: Int) {
        self.position = Coordinate(x, y, z)
        self.velocity = Coordinate(0,0,0)
    }
    
    func applyGravity(_ otherMoon: Moon, _ axis: Axis) {
        let otherPosition = otherMoon.position
        
        var modifier: Coordinate = Coordinate(0, 0, 0)
        
        switch axis {
        case .x: modifier.x = gravityModifier(self.position.x, otherPosition.x)
        case .y: modifier.y = gravityModifier(self.position.y, otherPosition.y)
        case .z: modifier.z = gravityModifier(self.position.z, otherPosition.z)
        }
        
        self.velocity = self.velocity + modifier
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
