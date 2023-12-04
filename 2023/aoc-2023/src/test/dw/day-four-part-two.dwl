%dw 2.5
import * from dw::core::Strings
import * from dw::core::Arrays
output application/json

var inp = lines(payload)

fun createArr(str: String) = do {
    flatten(str scan /\d+/) map $ as Number
}

var scoreCards = (inp map (line) -> do {
    var cLine = (line splitBy ':')[1]
    var winningNumbers = createArr((cLine splitBy '|')[0])
    var myNumbers = createArr((cLine splitBy '|')[1])
    var scoredNumbers = myNumbers filter (winningNumbers contains $)
    ---
    scoredNumbers
    
})

var bList = (0 to sizeOf(inp) -1) as Array
var rList = (1 to sizeOf(inp) map 1)
var winningCombinationsPerCard = scoreCards map sizeOf($)

fun calculateResult(list) = (list reduce ((index, acc = { currentCard: 1, res: rList}) -> do {
    var numOfWinningCombinations = winningCombinationsPerCard[index]
    var currentNumberOfCopies = acc.res[index]
    var indexToCreateCopiesFrom = index + 1
    var indexToCreateCopiesTo = (index + 1) + numOfWinningCombinations
    var info = log('Index: $(index) - numOfWinningCombinations: $(numOfWinningCombinations), indexToCreateCopiesFrom: $(indexToCreateCopiesFrom) - currentNumberOfCopies: $(currentNumberOfCopies) - current result:', acc.res)

    fun addCopiesToResult(result, timesToLoop, currentLoop = 1) = do {
        var newLoop = currentLoop + 1
        ---
        if (currentLoop <= timesToLoop)
            addCopiesToResult(
                (result map (item, idx) -> if(idx >= indexToCreateCopiesFrom and idx < indexToCreateCopiesTo) (item + 1) else item), timesToLoop, newLoop
            )
        else
            result
    }
    ---
    {
        currentCard: index,
        res: addCopiesToResult(acc.res, currentNumberOfCopies) 
    }
})).res
---
//[58355,]
{
    a: sum(calculateResult(bList[0 to 9])),
    //a: sum(calculateResult(bList[30 to 59])),
    // a: sum(calculateResult(bList[60 to 89])),
    // a: sum(calculateResult(bList[90 to 119])),
    // a: sum(calculateResult(bList[120 to 149])),
    // a: sum(calculateResult(bList[150 to 179])),
    // a: sum(calculateResult(bList[180 to -1])),
}
















