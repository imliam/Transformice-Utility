_S.bubbles = {
    disabled=true,
    ticks=0,
    callbacks={
        newGame=function()
            _S.bubbles.grounds = {}
            _S.bubbles.shamanObjects = {}
            for _, ground in pairs(map.grounds) do
                if ground.type == 9 then
                    table.insert(_S.bubbles.grounds, {ground.x, ground.y, ground.length, ground.height})
                end
            end
        end,
        eventLoop=function(time,remaining)
            _S.bubbles.ticks=_S.bubbles.ticks+1
            if _S.bubbles.grounds then
                x = math.random()*map.length
                y = math.random()*map.height
                for _, ground in pairs(_S.bubbles.grounds) do
                    for i = 10, 0, -1 do
                        x = math.random(ground[1]-(ground[3]/2), ground[1]+(ground[3]/2))
                        y = math.random(ground[2]-(ground[4]/2), ground[2]+(ground[4]/2))
                        tfm.exec.displayParticle(14, x, y, 0, math.random(-2, -1), 0, 0)
                    end
                    if _S.bubbles.ticks%3==0 then
                        table.insert(_S.bubbles.shamanObjects, tfm.exec.addShamanObject(59, x, y))
                    end
                end
            end
        end
    }
}