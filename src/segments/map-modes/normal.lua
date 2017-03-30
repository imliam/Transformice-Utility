_S.mapMode_normal = {
    disabled=true,
    playersWon=0,
    endCondition=function()
        tfm.exec.setPlayerScore(player.name,-1,true)
        if (tfm.get.room.playerList[player.name].isShaman or playersAlive()==2) and currentTime20000 then
            tfm.exec.setGameTime(20)
        elseif playersAlive()==1 and currentTime20000 then
            tfm.exec.setGameTime(20)
        elseif playersAlive()==0 and currentTime5000 then
            tfm.exec.setGameTime(5)
        end
    end,
    callbacks={
        newGame=function()
            _S.mapMode_normal.playersWon=0
        end,
        playerDied=function(player)
            tfm.exec.setPlayerScore(player.name,1,true)
            _S.mapMode_normal.endCondition()
        end,
        playerWon=function(player)
            if _S.mapMode_normal.playersWon==0 then
                tfm.exec.setPlayerScore(player.name,16,true)
            elseif _S.mapMode_normal.playersWon==1 then
                tfm.exec.setPlayerScore(player.name,14,true)
            elseif _S.mapMode_normal.playersWon==2 then
                tfm.exec.setPlayerScore(player.name,12,true)
            else
                tfm.exec.setPlayerScore(player.name,10,true)
            end
            _S.mapMode_normal.playersWon=_S.mapMode_normal.playersWon+1
            _S.mapMode_normal.endCondition()
        end,
    }
}