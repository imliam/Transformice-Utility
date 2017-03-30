_S.ratapult = {
    toDespawn={},
    defaultPlayer=function(player)
        player.activeSegments.ratapult=false
        player.ratapult={
            timestamp=os.time(),
            cooldown=1500,
            spawnLength=3000,
        }
    end,
    callbacks={
        keyboard={
            [KEYS.DOWN]=function(player,down,x,y)
                if not tfm.get.room.playerList[player.name].isDead then
                    if down then
                        player.ratapult.timestamp=os.time()
                    else
                        if os.time()-player.ratapult.timestamp-player.ratapult.cooldown>=0 then
                            local power=(os.time()+player.ratapult.cooldown-player.ratapult.timestamp)/100
                            if power>75 then power=75 end
                            table.insert(_S.ratapult.toDespawn,{
                                id=tfm.exec.addShamanObject(10,player.facingRight and x+30 or x-30,y,0,player.facingRight and power or -power),
                                despawn=os.time()+player.ratapult.spawnLength
                            })
                            player.ratapult.timestamp=os.time()
                        end
                    end
                end
            end,
        },
    },
}