%dw 2.0
import * from dw::core::Strings
import * from dw::core::Arrays
output application/json

var inp = lines(payload)

// Finds the matching numbers between numbers and winning numbers
fun findMatchingNumbers(line) = do {
    var cLine = (line splitBy ':')[1]
    var winningNumbers = flatten(((cLine splitBy '|')[0]) scan /\d+/)
    var myNumbers = flatten(((cLine splitBy '|')[1]) scan /\d+/)
    var matchingNumbers = myNumbers filter (winningNumbers contains $)
    ---
    matchingNumbers   
}
    
---
inp reduce ((line, points=0) -> do{
    var matchingNumbers = findMatchingNumbers(line)  
    var multiplier = (sizeOf(matchingNumbers) -1)  
    //var inf = log(matchingNumbers)
    ---
    if (!isEmpty(matchingNumbers))
        points + pow(2, multiplier)
    else
        points
})