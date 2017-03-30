_S.prophunt = {
    hunters={},
    props={
        --name={x=,y=,img=}
    },
    defaultPlayer=function(player)
        --player.activeSegments.prophunt=true
        player.prophunt={
            ids={}
        }
    end,
    callbacks={
        newGame=function()
            --[[
            _S.prophunt.props={}
            for n,p in pairs(_S.prophunt.hunters) do
                tfm.exec.setPlayerScore(n,0)
            end
            local hunter=highscore()
            _S.prophunt.hunters={}
            _S.prophunt.hunters[hunter]={lives=3}
            _S.blind.textarea(hunter)
            --hearts(hunter)
            ]]
        end,
        keyboard={
            [KEYS.E]=function(player,down,x,y)
                if down and not tfm.get.room.playerList[player.name].isDead then
                    local closest
                    for _,deco in pairs(map.decorations) do
                        if pythag(x,y,deco.x,deco.y,20) and _S.images.sprites.props[deco.id] then
                            local d=distance(deco.x,deco.y,x,y)
                            if not closest or d<closest.distance then
                                closest={id=deco.id,distance=d}
                            end
                        end
                    end
                    if closest then
                        _S.images.selectImage(player,closest.id,"props")
                    end
                end
            end,
            [KEYS.SPACE]=function(player,down,x,y)
                if down and not tfm.get.room.playerList[player.name].isDead and player.sprite then
                    if _S.hide.hidden[player.name] then
                        tfm.exec.movePlayer(player.name,_S.prophunt.props[player.name].x,_S.prophunt.props[player.name].y)
                        tfm.exec.removeImage(_S.prophunt.props[player.name].img)
                        _S.hide.hidden[player.name]=nil
                        _S.prophunt.props[player.name]=nil
                    else
                        _S.hide.hidden[player.name]=true
                        _S.hide.movePlayer(player)
                        local image=_S.images.sprites[player.sprite.category][player.sprite.id]
                        local directory=image[player.facingRight and "right" or "left"] or image
                        _S.prophunt.props[player.name]={
                            x=x,
                            y=y,
                            img=tfm.exec.addImage(directory.img..".png","?50",x+(directory.x or image.x or -50),y+(directory.y or image.y or -50))
                        }
                    end
                end
            end,
        }
    }
}