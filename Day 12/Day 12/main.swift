import Cocoa

func gravityModifier(_ coordinate: Int, _ otherCoordinate: Int) -> Int {
    if coordinate > otherCoordinate {
        return -1
    } else if coordinate < otherCoordinate {
        return 1
    }
    return 0
}

func timestep(_ moons: [Moon], _ axis: Axis) {
    for moon in moons {
        for other in moons {
            if other == moon { continue }
            moon.applyGravity(other, axis)
        }
    }
}

func findTotalEnergy(of moons: [Moon], after steps: Int) -> Int {
    for _ in 1...steps {
        timestep(moons, .x)
        timestep(moons, .y)
        timestep(moons, .z)
        moons.forEach({ $0.applyVelocity() })
    }
    return moons.map({ $0.totalEnergy }).reduce(0, +)
}

let example1Moons = [
    Moon(-1, 0, 2),
    Moon(2, -10, -7),
    Moon(4, -8, 8),
    Moon(3, 5, -1)
]
assert(findTotalEnergy(of: example1Moons, after: 10) == 179)

let example2Moons = [
    Moon(-8, -10, 0),
    Moon(5, 5, 10),
    Moon(2, -7, 3),
    Moon(9, -8, -3)
]
assert(findTotalEnergy(of: example2Moons, after: 100) == 1940)

let puzzleInputMoons = [
    Moon(14, 4, 5),
    Moon(12, 10, 8),
    Moon(1, 7, -10),
    Moon(16, -5, 3)
]

assert(findTotalEnergy(of: puzzleInputMoons, after: 1000) == 6423)

// Part 2

func timeStepsUntilInitial(_ moons: [Moon], _ axis: Axis) -> Int {
    var initialValues: [Int] = []
    switch axis {
    case .x: initialValues = moons.map({ $0.position.x })
    case .y: initialValues = moons.map({ $0.position.y })
    case .z: initialValues = moons.map({ $0.position.z })
    }

    var timeSteps = 0;
    var currentValues: [Int] = []
    
    while !(currentValues == initialValues && moons.allSatisfy({ $0.kineticEnergy == 0 })) {
        timeSteps += 1
        timestep(moons, axis)
        moons.forEach({ $0.applyVelocity() })
        switch axis {
        case .x: currentValues = moons.map({ $0.position.x })
        case .y: currentValues = moons.map({ $0.position.y })
        case .z: currentValues = moons.map({ $0.position.z })
        }
    
    }
    
    return timeSteps
}


func findTimeUntilInitialPosition(_ moons: [Moon]) -> Int {
    let xCount = timeStepsUntilInitial(moons, .x)
    let yCount = timeStepsUntilInitial(moons, .y)
    let zCount = timeStepsUntilInitial(moons, .z)
    
    return lcm(xCount, lcm(yCount, zCount))
}

assert(findTimeUntilInitialPosition(example1Moons) == 2772)

assert(findTimeUntilInitialPosition(puzzleInputMoons) == 327636285682704)
