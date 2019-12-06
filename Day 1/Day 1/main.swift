import Cocoa

let input = """
103450
107815
53774
124794
90372
98169
106910
50087
104958
71936
118379
122284
55871
91714
120685
117684
146047
60332
72034
127689
117575
101714
121018
86073
73764
100533
104443
113037
79474
123364
128367
63620
54004
124093
133256
95915
97442
64267
70823
143108
86422
118962
66129
69445
51804
56436
117587
64632
104564
67514
108782
123991
110932
122201
98816
126708
69821
66902
96993
55032
109143
67678
58009
50232
69841
101922
95832
122820
72056
102557
68727
85192
74694
142252
140332
53783
123036
88197
148727
138393
87427
65693
88448
51044
95470
97336
121463
91997
149518
66967
119301
112022
57363
128247
107454
77260
126346
97658
137578
134743
""".components(separatedBy: .newlines).compactMap({ Int($0) })

func calculateFuel(for mass: Int) -> Int {
    let dividedAndRoundedDown: Int = (mass / 3)
    return dividedAndRoundedDown - 2
}

let totalFuelNeeded = input
    .map({ calculateFuel(for: $0 )})
    .reduce(0, +)

print(totalFuelNeeded) // 3216868

// Part 2

func calculateAdditionalFuel(for fuel: Int) -> Int {
    let result = calculateFuel(for: fuel)
    if (result <= 0) {
        return 0
    }
    else {
        return result + calculateAdditionalFuel(for: result)
    }
}

let grandTotalFuel = input
    .map { moduleMass in
        let fuelNeeded = calculateFuel(for: moduleMass)
        let additionalFuelNeededForFuel = calculateAdditionalFuel(for: fuelNeeded)
        return fuelNeeded + additionalFuelNeededForFuel }
    .reduce(0, +)

print(grandTotalFuel) // 4822435
