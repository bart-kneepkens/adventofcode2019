import Cocoa

let puzzleInput =
"""
###..#########.#####.
.####.#####..####.#.#
.###.#.#.#####.##..##
##.####.#.###########
###...#.####.#.#.####
#.##..###.########...
#.#######.##.#######.
.#..#.#..###...####.#
#######.##.##.###..##
#.#......#....#.#.#..
######.###.#.#.##...#
####.#...#.#######.#.
.######.#####.#######
##.##.##.#####.##.#.#
###.#######..##.#....
###.##.##..##.#####.#
##.########.#.#.#####
.##....##..###.#...#.
#..#.####.######..###
..#.####.############
..##...###..#########
"""

struct Coordinate {
    var x: Int
    var y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
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

typealias Asteroid = Coordinate
typealias Slope = Coordinate

let lines  = puzzleInput.components(separatedBy: .newlines)
var asteroids: [Asteroid] = []

for (Y, line) in lines.enumerated() {
    for (X, point) in line.enumerated() {
        if point == "#" {
            asteroids.append(Asteroid(X,Y))
        }
    }
}

func slope(_ asteroidA: Asteroid, _ asteroidB: Asteroid) -> Slope {
    let deltaX = asteroidB.x - asteroidA.x
    let deltaY = asteroidB.y - asteroidA.y
    return Slope(deltaX, deltaY)
}

func amountOfUniqueSlopes(_ asteroid: Asteroid) -> Int {
    return Set(asteroids
        .filter({ $0 != asteroid })
        .map({ slope(asteroid, $0)})
        .map({ simplify($0)})).count
}

func gcdIterativeEuklid(_ m: Int, _ n: Int) -> Int {
    var a: Int = 0
    var b: Int = max(m, n)
    var r: Int = min(m, n)

    while r != 0 {
        a = b
        b = r
        r = a % b
    }
    return b
}

func simplify(_ slope: Slope) -> Slope {
    let gcd = abs(gcdIterativeEuklid(slope.x, slope.y))
    return Slope((slope.x / gcd), (slope.y / gcd))
}

let bestAsteroid = asteroids.sorted(by: { amountOfUniqueSlopes($0) > amountOfUniqueSlopes($1)}).first!

print(bestAsteroid, amountOfUniqueSlopes(bestAsteroid)) // Coordinate(x: 11, y: 11) 221
