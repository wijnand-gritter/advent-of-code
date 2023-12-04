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
inp reduce ((line, res= { mNumbers: {line: 0, winningCombinations: [], resultList: []}, points: 0 }) -> do {
    var matchingNumbers = findMatchingNumbers(line)  
    var multiplier = (sizeOf(matchingNumbers) -1)  
    var inf = log(matchingNumbers)
    var initialCard = 1
    var nextCards = (1 to sizeOf(matchingNumbers) map 1) // 1 should be X (copies to add!)
    ---
    {
        mNumbers: {
            line: res.mNumbers.line + 1,
            resultList: res.mNumbers.resultList << nextCards,            
            winningCombinations: res.mNumbers.winningCombinations << [sizeOf(matchingNumbers)]

        },
        points: if (!isEmpty(matchingNumbers))
            res.points + pow(2, multiplier)
                else
            res.points
    }

})