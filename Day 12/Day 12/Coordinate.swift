struct Coordinate {
    var x: Int
    var y: Int
    var z: Int
    
    init(_ x: Int, _ y: Int, _ z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
}

extension Coordinate {
    static func +(_ left: Coordinate, _ right: Coordinate) -> Coordinate {
        return Coordinate(left.x + right.x, left.y + right.y, left.z + right.z)
    }
}

extension Coordinate: Hashable {
    static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(z)
    }
}

extension Coordinate: CustomStringConvertible {
    var description: String {
        return "<x= \(self.x), y= \(self.y), z= \(self.z))"
    }
}
