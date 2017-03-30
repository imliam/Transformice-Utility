_S.ballExplosion = {
    disabled=true,
    defaultPlayer=function(player)
        player.activeSegments.ballExplosion=true
    end,
    power=70,
    objects={},
    time=3000,
    range=70,
    callbacks={
        summoningEnd=function(player,objectType,x,y,ang,other)
            if objectType > 100 then objectType=objectType/100 end
            if objectType >= 6 and objectType < 7 then -- all balls
                table.insert(_S.ballExplosion.objects, {id=other.id,spawn=os.time(),range=_S.ballExplosion.range,explode=_S.ballExplosion.time,power=_S.ballExplosion.power})
            end
        end,
        eventLoop=function()
            local toRemove={}
            for index, data in pairs(_S.ballExplosion.objects) do
                if data.spawn < os.time()-data.explode then
                    coord = tfm.get.room.objectList[data.id] or {x=-5000,y=-5000}
                    tfm.exec.removeObject(data.id)
                    _S.ballExplosion.explodeLocal(data.power,data.range,coord.x,coord.y)
                    table.insert(toRemove, index)
                end
            end
            for _,i in ipairs(toRemove) do
                _S.ballExplosion.objects[i]=nil
            end
        end,
    },
    explodeLocal=function(power,range,x,y)
        tfm.exec.explosion(x,y,power,range,false)
        for i=0,20 do
            local angle=math.random(-180, 180)
            local velX=math.cos(angle)
            local velY=math.sin(angle)
            tfm.exec.displayParticle(math.random(4), x+math.random(-velX, velX), y+math.random(-velY, velY), velX, velY, math.random(-0.11, 0.11), math.random(-0.11, 0.11), nil)
        end
    end
}