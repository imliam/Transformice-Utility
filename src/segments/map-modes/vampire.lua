_S.mapMode_vampire = {
    disabled=true,
    ticks=0,
    endCondition=function()
        local alive=false
        for n,p in pairs(tfm.get.room.playerList) do
            if not p.isDead and not p.isVampire then
                alive=true
                break
            end
        end
        if not alive then
            tfm.exec.setGameTime(5)
        end
    end,
    callbacks={
        newGame=function()
            tfm.exec.setGameTime(120)
        end,
        eventLoop=function(time,remaining)
            _S.mapMode_vampire.ticks=_S.mapMode_vampire.ticks+1
            if _S.mapMode_vampire.ticks==30 then
                local tbl={}
                for n,p in pairs(tfm.get.room.playerList) do
                    if not p.isDead then
                        table.insert(tbl,n)
                    end
                end
                tfm.exec.setVampirePlayer(tbl[math.random(#tbl)])
            end
        end,
        roundEnd=function()
            for n,p in pairs(tfm.get.room.playerList) do
                if not p.isDead and not p.isVampire then
                    tfm.exec.setPlayerScore(n,10,true)
                end
            end
        end,
        playerDied=function(player)
            tfm.exec.setPlayerScore(n,1,true)
            _S.mapMode_vampire.endCondition()
        end,
        playerVampire=function(player)
            _S.mapMode_vampire.endCondition()
        end
    }
}
