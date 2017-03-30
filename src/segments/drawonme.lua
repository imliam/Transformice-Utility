_S.drawOnMe = {
    defaultPlayer=function(player)
        player.activeSegments.drawOnMe=false
        player.drawOnMe={
            imgs={},
            lastFacing="right"
        }
    end,
    redraw=function(player,direction)
        for _,dot in ipairs(player.drawOnMe.imgs) do
            tfm.exec.removeImage(dot.img)
            dot.img=tfm.exec.addImage("151469722d4.png","$"..player.name,direction=="right" and dot.x*-1 or dot.x,dot.y)
        end
        player.drawOnMe.lastFacing=direction
    end,
    callbacks={
        mouse={
            pr=2,
            fnc=function(player,x,y)
                local p=tfm.get.room.playerList[player.name]
                if pythag(p.x,p.y,x,y,25) then
                    local xoff=x-p.x
                    local yoff=y-p.y
                    table.insert(player.drawOnMe.imgs,{
                        img=tfm.exec.addImage("151469722d4.png","$"..player.name,xoff,yoff),
                        x=player.facingRight and xoff*-1 or xoff,
                        y=yoff
                    })
                end
            end
        },
        keyboard={
            [KEYS.LEFT]=function(player,down,x,y)
                if down then
                    if player.drawOnMe.imgs and player.drawOnMe.lastFacing=="right" then
                        _S.drawOnMe.redraw(player,"left")
                    end
                end
            end,
            [KEYS.RIGHT]=function(player,down,x,y)
                if down then
                    if player.drawOnMe.imgs and player.drawOnMe.lastFacing=="left" then
                        _S.drawOnMe.redraw(player,"right")
                    end
                end
            end,
        },
        newGame=function()
            for name in pairs(tfm.get.room.playerList) do
                local player=players[name]
                _S.drawOnMe.redraw(player,"right")
            end
        end,
        playerRespawn=function(player)
            _S.drawOnMe.redraw(player,"right")
        end,
        chatCommand={
            clear={
                rank=RANKS.ANY,
                fnc=function(player)
                    for _,dot in ipairs(player.drawOnMe.imgs) do
                        tfm.exec.removeImage(dot.img)
                    end
                    player.drawOnMe.imgs={}
                end
            }
        }
    }
}