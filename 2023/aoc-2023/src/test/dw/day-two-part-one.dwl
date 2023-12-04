%dw 2.0
output application/json

fun readInput(inp) = (inp splitBy '\n') map (game) -> do {
    var setsInGame = (game splitBy ': ')[1] splitBy '; '
    ---
    setsInGame map (set) -> do {
        {((set splitBy ', ') map (setItems) -> do{
            var v = (setItems splitBy ' ')[0]
            var k = (setItems splitBy ' ')[1]
            ---
            (k): (v as Number)
        })}
    }
}

fun validateSet(obj: Object) = do {
    var bag = { red: 12, green: 13, blue: 14 }
    var isValid = obj mapObject ((v, k) -> (k): (v) <= bag[k])
    ---
    (isValid pluck $) map !($ contains false)
}

var validatedGames = readInput(payload) map (game) -> do {
    (game) flatMap (sets) -> validateSet(sets)
}

var partOne = validatedGames reduce ((game, acc = {
    currentGame: 1,
    totalScore: 0
}) -> do {
    var isValidGame = !(game contains false)
    var cGame = acc.currentGame + 1
    var newScore = if (isValidGame) acc.totalScore + acc.currentGame else 0
    var gameInfo = log("Valid: $(isValidGame) - currentGameId: $(acc.currentGame) - totalScore: $(acc.totalScore) - newScore: $(newScore)")
    ---
    {
        currentGame: cGame,
        totalScore: if (isValidGame) newScore else acc.totalScore
    }
})

---
partOne.totalScore

































