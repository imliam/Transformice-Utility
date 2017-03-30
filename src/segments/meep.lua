_S.meep = {
    callbacks={
        newGame=function()
            for name,player in pairs(players) do
                if player.activeSegments.meep then
                    tfm.exec.giveMeep(name)
                end
            end
        end,
        keyboard={
            [KEYS.SPACE]=function(player,down,x,y)
                if player.meepTimer<os.time()-10100 and player.meepPower then -- time for the meep bar to restore
                    player.meepTimer=os.time()
                    for k,v in pairs(tfm.get.room.playerList) do
                        if player.name~=k then
                            local xdiff=tfm.get.room.playerList[k].x-x
                            local ydiff=tfm.get.room.playerList[k].y-(y+10)
                            local length=math.sqrt(xdiff^2+ydiff^2)
                            if length <= 90 then -- distance obviously
                                tfm.exec.movePlayer(k, 0, 0, false, (xdiff/(math.abs(xdiff)+math.abs(ydiff)))*player.meepPower, (ydiff/(math.abs(xdiff)+math.abs(ydiff)))*player.meepPower, false)
                            end -- the two 250 values determine the power (they must be the same)
                        end
                    end
                end
            end
        }
    }
}
