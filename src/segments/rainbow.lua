_S.rainbow = {
    players={},
    defaultPlayer=function(player)
        _S.rainbow.players[player] = os.time()
    end,
    callbacks={
        keyboard={
            [KEYS.SPACE]=function(player,down,x,y)
                if down then
                    if _S.rainbow.players[player] < os.time()-500 then
                        _S.rainbow.players[player] = os.time()
                        for a = math.pi, 2*math.pi, math.pi/50 do
                            local s = 3
                            vx1, vy1 = s*math.cos(a), s*math.sin(a)
                            local m = -3/100
                            vx,vy=vx1,vy1
                            tfm.exec.displayParticle(1, x, y+12, vx, vy, m*vx, m*vy)
                            vx,vy=vx1*1.1,vy1*1.1
                            tfm.exec.displayParticle(9, x, y+12, vx, vy, m*vx, m*vy)
                            vx,vy=vx1*1.1,vy1*1.2
                            tfm.exec.displayParticle(11, x, y+12, vx, vy, m*vx, m*vy)
                            vx,vy=vx1*1.3,vy1*1.3
                            tfm.exec.displayParticle(13, x, y+12, vx, vy, m*vx, m*vy)
                        end
                    end
                end
            end,
        },
    },
}