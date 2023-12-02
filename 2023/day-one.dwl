%dw 2.0
output application/json
import isNumeric from dw::core::Strings

var lines = (payload splitBy '\n')

fun getFirstAndLastNumbers(list: Array) = list map (line) -> do {
    var numbers = line find(/\d/)
    var firstNumber = line[numbers[0][0]]
    var lastNumber = line[numbers[-1][0]]
    ---
    "$(firstNumber)$(lastNumber)"
}
var partOne = sum(getFirstAndLastNumbers(lines))

var partTwo = do {
    // This makes sure things like oneight get replaced correctly
    fun replaceStringWithNumber(a) = a
        replace "one"   with "one1one"
        replace 'two'   with "two2two"
        replace 'three' with "three3three"
        replace 'four'  with "four4four"
        replace 'five'  with "five5five"
        replace 'six'   with "six6six"
        replace 'seven' with "seven7seven"
        replace 'eight' with "eight8eight"
        replace 'nine'  with "nine9nine"

    var replacedLines = lines map (replaceStringWithNumber($))
    ---
    sum(getFirstAndLastNumbers(replacedLines))
}
---
{
    partOne: partOne,
    partTwo: partTwo
}





