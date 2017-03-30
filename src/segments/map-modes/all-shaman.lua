_S.mapMode_all_shaman = {
    disabled=true,
    callbacks={
        newGame=function()
            for n,p in pairs(tfm.get.room.playerList) do
                tfm.exec.setShaman(n)
            end
        end,
        roundEnd=function()
            for n,p in pairs(tfm.get.room.playerList) do
                if p.isShaman then
                    tfm.exec.setPlayerScore(n,0,true)
                end
            end
        end,
        playerDied=function(player)
            if alivePlayers()<=2 and currentTime<20000 then
                tfm.exec.setGameTime(5)
            end
        end
    }
}
