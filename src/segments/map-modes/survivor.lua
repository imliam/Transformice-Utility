_S.mapMode_survivor = {
    disabled=true,
    endCondition=function()
        local alive=false
        for n,p in pairs(tfm.get.room.playerList) do
            if not p.isDead and not p.isShaman then
                alive=true
                break
            end
        end
        if not alive then
            tfm.exec.setGameTime(5)
        end
    end,
    callbacks={
        roundEnd=function()
            for n,p in pairs(tfm.get.room.playerList) do
                if not p.isDead and not p.isShaman then
                    tfm.exec.setPlayerScore(n,10,true)
                end
            end
        end,
        playerDied=function(player)
            tfm.exec.setPlayerScore(n,1,true)
            _S.mapMode_survivor.endCondition()
        end,
    }
}
