_S.fly = {
    callbacks={
        keyboard={
            [KEYS.SPACE]=function(player,down,x,y)
                if down then
                    tfm.exec.movePlayer(player.name,0,0,true,0,-50,true)
                end
            end,
        },
    },
}