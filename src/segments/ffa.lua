_S.ffa = {
    toDespawn={},
    defaultPlayer=function(player)
        player.activeSegments.ffa=false
        player.ffa={
            object=17,
            power=10,
            timestamp=0,
            cooldown=1000,
            spawnLength=2000,
            offset={
                x=2,
                y=10,
            },
        }
    end,
    callbacks={
        keyboard={
            [KEYS.DOWN]=function(player,down,x,y)
                if down and not tfm.get.room.playerList[player.name].isDead then
                    if player.ffa.timestamp<=os.time()-player.ffa.cooldown then
                        local angle=(player.facingRight and 90 or 270)+(player.ffa.object==17 and 0 or -90)
                        table.insert(_S.ffa.toDespawn,{
                            id=tfm.exec.addShamanObject(player.ffa.object,player.facingRight and x+player.ffa.offset.x or x-player.ffa.offset.x,y+player.ffa.offset.y,angle,player.ffa.power*math.cos(math.rad(angle)),player.ffa.power*math.sin(math.rad(angle))),
                            despawn=os.time()+player.ffa.spawnLength
                        })
                        player.ffa.timestamp=os.time()
                    end
                end
            end,
        },
        chatCommand={
            off={
                rank=RANKS.ANY,
                fnc=function(player,x,y)
                    local newx,newy
                    if tonumber(x) and tonumber(y) then
                        newx=x
                        newy=y
                    elseif x=="dom" then
                        newx=-10
                        newy=15
                    elseif x=="def" then
                        newx=2
                        newy=10
                    else
                        tfm.exec.chatMessage(translate("invalidargument",player.lang),player.name)
                    end
                    if newx and newy then
                        player.ffa.offset={x=tonumber(newx),y=tonumber(newy)}
                        tfm.exec.chatMessage(translate("offsetschanged",player.lang):format(newx,newy),player.name)
                    end
                end
            }
        }
    },
}