_S.dash = {
    callbacks={
        keyboard={
            [KEYS.LEFT]=function(player,down,x,y) 
                if down then
                    if player.dash and player.dash.direction=="left" and player.dash.time>os.time()-250 and (player.lastDash and player.lastDash<os.time()-5000 or not player.lastDash) then
                        tfm.exec.movePlayer(player.name, 0, 0, false, -100, 0, false)
                        player.lastDash=os.time()
                    end
                    player.dash={time=os.time(),direction="left"}
                end
            end,
            [KEYS.RIGHT]=function(player,down,x,y) 
                if down then
                    if player.dash and player.dash.direction=="right" and player.dash.time>os.time()-250 and (player.lastDash and player.lastDash<os.time()-5000 or not player.lastDash) then
                        tfm.exec.movePlayer(player.name, 0, 0, false, 100, 0, false)
                        player.lastDash=os.time()
                    end
                    player.dash={time=os.time(),direction="right"}
                end
            end,
        }
    }
}