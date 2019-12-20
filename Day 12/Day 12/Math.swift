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


func lcm(_ m: Int, _ n: Int, using gcdAlgorithm: (Int, Int) -> (Int) = gcdIterativeEuklid) -> Int {
    guard (m & n) != 0 else { return -1 }
    return m / gcdAlgorithm(m, n) * n
}
