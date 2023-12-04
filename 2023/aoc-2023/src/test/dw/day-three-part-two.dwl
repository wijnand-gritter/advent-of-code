%dw 2.0
output application/json
import * from dw::core::Strings
/*
 * Solution to this puzzle is to draw a rectangle around each asterisk like this:
 * 467..
 * ...*.
 * .465..
 * Then find all numbers adjecent
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
        indexes: (v.indexes[0][idx])
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
            startIndex to endIndex
        })
        ---
        acc << {
            num: item,
            indexes: indexArr
        }
    }))
}

var linesWithGears = (inp map (line, idx) -> do {
    var gearOnLine = flatten(line find /\*+/)
    ---
    {
        lineId: idx,
        gearIndexes: gearOnLine
    }
}) filter !isEmpty($.gearIndexes)
---
sum(flatten(linesWithGears map (gearLine) -> do {
    var pLine = getPreviousLine(gearLine.lineId)
    var cLine = inp[gearLine.lineId]
    var nLine = getNextLine(gearLine.lineId)
    var numOnpLine = flatten(pLine scan /\d+/)
    var numOncLine = flatten(cLine scan /\d+/)
    var numOnnLine = flatten(nLine scan /\d+/)
    var pLineIdx = ((getIndexesOfLineItems(pLine, numOnpLine)))
    var cLineIdx = ((getIndexesOfLineItems(cLine, numOncLine)))
    var nLineIdx = ((getIndexesOfLineItems(nLine, numOnnLine)))
    ---
    (gearLine.gearIndexes map (gi) -> do {
        (
            pLineIdx filter ($.indexes contains gi)
            ++ 
            cLineIdx filter ($.indexes contains gi)            
            ++ 
            nLineIdx filter ($.indexes contains gi)
        ).num
    }) filter sizeOf($) == 2
}) map (item) -> (item[0] * item[1]))