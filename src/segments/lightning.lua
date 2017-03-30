_S.lightning = {
    ids={0,1,9},
    move=3,
    ms=3/20,
    ma=(3/20)/1200,
    players={},
    defaultPlayer=function(player)
        _S.lightning.players[player] = os.time()
    end,
    callbacks={
        mouse={
            pr=-21,
            fnc=function(player,x,y)
                if player.ctrl and not player.shift then
                    if _S.lightning.players[player] < os.time()-1000 then
                        _S.lightning.players[player] = os.time()
                        local p=tfm.get.room.playerList[player.name]
                        _S.lightning.drawLightining(p.x,p.y,x,y,_S.lightning.ids[math.random(#_S.lightning.ids)])
                    end
                end
            end
        }
    },
    drawLine=function(x1,y1,x2,y2,spaces,id)
        id = id or 9
        spaces = spaces or 3
        local distance = _S.lightning.getDistance(x1,y1,x2,y2)
        local numOfParticles = math.floor(distance/spaces)
        local angle = _S.lightning.getAngle(x1,y1,x2,y2)
        for i=0,numOfParticles do
            local dotX = x1+math.cos(angle)*(i*spaces)
            local dotY = y1+math.sin(angle)*(i*spaces)
            tfm.exec.displayParticle(id,dotX,dotY,math.random()*_S.lightning.ms-_S.lightning.ms/2,math.random()*_S.lightning.ms-_S.lightning.ms/2,math.random()*_S.lightning.ma-_S.lightning.ma/2,math.random()*_S.lightning.ma-_S.lightning.ma/2)
        end
    end,
    getDistance=function(x1,y1,x2,y2)
        return math.sqrt(math.abs(x1-x2)^2+math.abs(y1-y2)^2)
    end,
    getAngle=function(x1,y1,x2,y2)
        return math.atan2(y2-y1,x2-x1)
    end,
    radToDeg=function(i)
        i = i*180/math.pi
        i = i<0 and i+360 or i
        return i
    end,
    degToRad=function(i)
        return i*math.pi/180
    end,
    drawLightining=function(x1,y1,x2,y2,id)
        local ang = _S.lightning.getAngle(x1,y1,x2,y2)
        local dis = _S.lightning.getDistance(x1,y1,x2,y2)
        local rd = function() return math.random()*25+25 end
        local ra = function() return math.pi/(math.random()*120+30) end
        local wave = {}
        local addWave = function(k,xx,yy) wave[k] = {x=xx,y=yy} end
        addWave(0,x1,y1)
        local td = 0
        local randomDistance = rd()
        local randomAngle = ra()*((dis-td)/100)
        local zigZag = math.random()<0.5 and 1 or -1
        local ca = ang + randomAngle*zigZag
        while randomDistance<dis-td do
            td = td + randomDistance
            local tx = x1+math.cos(ca)*td
            local ty = y1+math.sin(ca)*td
            addWave(#wave+1,tx,ty)
            randomDistance = rd()
            randomAngle = ra()*((dis-td)/100)
            zigZag = zigZag * -1
            ca = ang + randomAngle*zigZag
        end
        addWave(#wave+1,x2,y2)
        for i=0,#wave-1 do
            local cw = wave[i]
            local nw = wave[i+1]
            _S.lightning.drawLine(cw.x,cw.y,nw.x,nw.y,3,id)
        end
    end
}