%dw 2.0
import * from dw::core::Strings

var inp = lines(payload)
var times = (inp[0] scan /\d+/) map $[0] 
var dist  = (inp[1] scan /\d+/) map $[0]

var partTwoTime = flatten(inp[0] scan /\d/) joinBy ''
var partTwoDistance = flatten(inp[1] scan /\d/) joinBy ''

fun findWinningWays(t,d) = do {
    var r1 = 0.5 * (t + (pow((pow(t,2) - 4 * d), 0.5)))
    var r2 = 0.5 * (t - (pow((pow(t,2) - 4 * d), 0.5)))
    var a = if(r1 contains '.') r1 + 1 else r1   
    var b = if(r2 contains '.') r2 - 1 else r2       
    ---
    floor(a) - (ceil(b) + 1)
}

fun calcProduct(arr) = arr reduce ((item, acc=0) -> if (acc == 0) (1 * item) else (acc * item))


output application/json
---
{
    partOne: calcProduct(zip(times,dist) map (race) -> (findWinningWays(race[0], race[1]))),
    partTwo: findWinningWays(partTwoTime, partTwoDistance)
}
