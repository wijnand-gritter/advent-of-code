%dw 2.0
output application/json

fun readInput(inp) = (inp splitBy '\n') map (game) -> do {
    (game splitBy ': ')[1] replace ',' with '' replace ';' with ''
}
var totalGames = readInput(payload) reduce ((line, acc = []) -> do{
    var x = (line splitBy ' ')
    var a = {((x map (item, idx) -> do {
    {
        (red: x[idx -1] as Number) if (item == "red"),
        (green: x[idx -1]  as Number) if (item == "green"),
        (blue: x[idx -1]  as Number) if (item == "blue")
    }
}) filter !isEmpty($))} 
    var maxRed = max(a.*red)
    var maxGreen = max(a.*green)
    var maxBlue = max(a.*blue)
    var info = log("red: $(maxRed), green: $(maxGreen), blue: $(maxBlue)", a)
    ---
    acc << (maxRed * maxGreen * maxBlue)
})
---
sum(totalGames)
































