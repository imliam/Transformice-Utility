-- Simulates the shaman skill "projection"

_S.projection = {
    callbacks={
        keyboard={
            [KEYS.LEFT]=function(player,down,x,y) 
                if down then
                    if player.dash and player.dash.direction=="left" and player.dash.time>os.time()-250 and (player.lastDash and player.lastDash<os.time()-3000 or not player.lastDash) then
                        tfm.exec.movePlayer(player.name, x-100, y)
                        player.lastDash=os.time()
                        for i=1,6 do
                            tfm.exec.displayParticle(3,x,y,math.random(-1,1),math.random(-1,1),0,0)
                            tfm.exec.displayParticle(35,x-50,y,0,0,0,0)
                        end
                    end
                    player.dash={time=os.time(),direction="left"}
                end
            end,
            [KEYS.RIGHT]=function(player,down,x,y) 
                if down then
                    if player.dash and player.dash.direction=="right" and player.dash.time>os.time()-250 and (player.lastDash and player.lastDash<os.time()-3000 or not player.lastDash) then
                        tfm.exec.movePlayer(player.name, x+100, y)
                        player.lastDash=os.time()
                        for i=1,6 do
                            tfm.exec.displayParticle(3,x,y,math.random(-1,1),math.random(-1,1),0,0)
                            tfm.exec.displayParticle(35,x+50,y,0,0,0,0)
                        end
                    end
                    player.dash={time=os.time(),direction="right"}
                end
            end,
        }
    }
}