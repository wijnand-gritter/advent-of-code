%dw 2.0
output application/json
import * from dw::core::Strings
/*
 * Solution to this puzzle is to draw a rectangle around a number like this:
 * .*...
 * .467.
 * .....
 * If one of the '.' matches a symbol, it is a valid entry
 *
 */

var inp = lines(payload)
var totalLineSize = sizeOf(inp[0])
var defaultLine = (0 to totalLineSize) reduce ((item, acc = "") -> acc ++ '.')

fun getPreviousLine(idx) = inp[idx-1] default defaultLine
fun getNextLine(idx) = inp[idx+1] default defaultLine

fun getIndexesOfLineItems(line, items) = do {
    fun removeDuplicates(inp) = flatten((inp groupBy $.num) pluck ((v, key, index) -> (v) map (item, idx) -> {
        num: (key),
        items: (v.items[0][idx])
    }))
    ---
    removeDuplicates(items reduce ((item, acc=[]) -> do {
        var regEx = ("\\b$(item as Number)\\b" as Regex)
        var startIndexes = flatten(line find regEx)
        var indexArr = (startIndexes map (sIdx) -> do {
            var len = sizeOf(item)
            var startIndex = do {
                var s = sIdx -1
                ---
                if (s < 0) sIdx else s
            }
            var endIndex = do {
                var s = sIdx+len
                ---
                if (s >= totalLineSize) totalLineSize -1 else s
            }
            ---
            [startIndex, endIndex]
        })
        ---
        acc << {
            num: item,
            items: indexArr
        }
    }))
}

fun getCharOnLine(line, indexes) = line[indexes[0] to indexes[1]]

var sanitizedPayload = (inp map (cLine, idx) -> do {
    var pLine = if (idx == 0) defaultLine else getPreviousLine(idx)
    var nLine = getNextLine(idx)
    var numOnLine = flatten(cLine scan /\d+/)
    var indexesOfLineItems = ((getIndexesOfLineItems(cLine, numOnLine)))
    ---
    indexesOfLineItems map (indexOfLineItem) -> ({
        num:   indexOfLineItem.num,
        pLine: getCharOnLine(pLine, indexOfLineItem.items),
        cLine: getCharOnLine(cLine, indexOfLineItem.items),
        nLine: getCharOnLine(nLine, indexOfLineItem.items)
    })
}) filter !isEmpty($)
---
sum((sanitizedPayload flatMap (lineItems) -> do {
    (lineItems map (lineItem) -> do {
        var info = log("lineItem: ", lineItem)
        fun cleanLine(line) = line replace /[0-9]/ with '' replace '.' with ''
        ---
        if (
            !isEmpty(cleanLine(lineItem.pLine)) or
            !isEmpty(cleanLine(lineItem.cLine)) or
            !isEmpty(cleanLine(lineItem.nLine))
        ) lineItem.num as Number
        else
            null
    })
}) filter !isEmpty($))