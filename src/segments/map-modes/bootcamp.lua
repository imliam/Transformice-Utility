_S.mapMode_bootcamp = {
    disabled=true,
    ticks=0,
    callbacks={
        newGame=function()
            _S.mapMode_bootcamp.ticks=0
            tfm.exec.setGameTime(999999)
        end,
        eventLoop=function(time,remaining)
            _S.mapMode_bootcamp.ticks=_S.mapMode_bootcamp.ticks+1
            if _S.mapMode_bootcamp.ticks==10 then
                for n,p in pairs(tfm.get.room.playerList) do
                    if p.isDead then
                        tfm.exec.respawnPlayer(n)
                    end
                end
            end
        end,
        playerWon=function(player)
            tfm.exec.setPlayerScore(player.name,10,true)
        end,
        playerDied=function(player)
            tfm.exec.setPlayerScore(player.name,-1,true)
        end
    }
}
