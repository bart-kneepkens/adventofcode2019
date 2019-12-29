struct Coordinate {
    var x: Int
    var y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    func moved(_ move: Move) -> Coordinate {
        switch move {
        case .east:
            return Coordinate(self.x - 1, self.y)
        case .west:
            return Coordinate(self.x + 1, self.y)
        case .north:
            return Coordinate(self.x, self.y + 1)
        case .south:
            return Coordinate(self.x, self.y - 1)
        }
    }
}

extension Coordinate {
    static func +(_ left: Coordinate, _ right: Coordinate) -> Coordinate {
        return Coordinate(left.x + right.x, left.y + right.y)
    }
}

extension Coordinate: Hashable {
    static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

extension Coordinate: CustomStringConvertible {
    var description: String {
        return "<x= \(self.x), y= \(self.y)>"
    }
}
