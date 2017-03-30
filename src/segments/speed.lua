_S.speed = {
    callbacks={
        keyboard={
            [KEYS.LEFT]=function(player,down,x,y) 
                if down then
                    tfm.exec.movePlayer(player.name, 0, 0, false, -player.speedPower, 0, false)
                end
            end,
            [KEYS.RIGHT]=function(player,down,x,y)
                if down then
                    tfm.exec.movePlayer(player.name, 0, 0, false, player.speedPower, 0, false)
                end
            end,
        }
    }
}