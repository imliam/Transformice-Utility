_S.mapMode_shaman = {
    disabled=true,
    callbacks={
        newGame=function()
            _S.mapMode_normal.callbacks.newGame()
            local scores=sortScores()
            tfm.exec.setShaman(scores[1].name)
        end,
        roundEnd=function()
            for n,p in pairs(tfm.get.room.playerList) do
                if p.isShaman then
                    tfm.exec.setPlayerScore(n,0)
                end
            end
        end,
        playerDied=function(player)
            _S.mapMode_normal.callbacks.playerDied(player)
        end,
        playerWon=function(player)
            _S.mapMode_normal.callbacks.playerWom(player)
        end,
    }
}
