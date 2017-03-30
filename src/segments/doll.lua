_S.doll = {
    move=function(player,direction)
        if player.dolls then
            for k,v in pairs(player.dolls) do
                tfm.exec.movePlayer(v,0,0,true,
                    direction=="left" and -40 or direction=="right" and 40 or 0,
                    direction=="up" and -50 or direction=="down" and 40 or 0,
                    false)
            end
        end
    end,
    callbacks={
        keyboard={
            [KEYS.U]=function(player,down,x,y)
                if down then _S.doll.move(player,"up") end
            end,
            [KEYS.J]=function(player,down,x,y)
                if down then _S.doll.move(player,"down") end
            end,
            [KEYS.H]=function(player,down,x,y)
                if down then _S.doll.move(player,"left") end
            end,
            [KEYS.K]=function(player,down,x,y)
                if down then _S.doll.move(player,"right") end
            end
        },
    }
}
