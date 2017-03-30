_S.flames = {
    disabled=true,
    defaultPlayer=function(player)
        player.activeSegments.flames=true
    end,
    decorations={},
    onFire={},
    ids={2, 13},
    lamps={
        [44]={x=0,y=-70},
        [46]={x=0,y=-65},
        [55]={x=0,y=-10},
        [71]={x=0,y=-25},
        [96]={x=0,y=0},
        [97]={x=0,y=-60},
        [102]={x=0,y=30},
    },
    callbacks={
        newGame=function()
            _S.flames.onFire={}
            _S.flames.decorations={}
            for _,deco in pairs(map.decorations) do
                if _S.flames.lamps[deco.id] then
                    table.insert(_S.flames.decorations,deco)
                end
            end
        end,
        eventLoop=function(time,remaining)
            for i,deco in pairs(_S.flames.decorations) do
                _S.flames.fireParticles(deco.x+_S.flames.lamps[deco.id].x,deco.y+_S.flames.lamps[deco.id].y)
                if i==10 then break end
            end
            local toremove={}
            for name,time in pairs(_S.flames.onFire) do
                _S.flames.fireParticles(tfm.get.room.playerList[name].x,tfm.get.room.playerList[name].y)
                if time<os.time()-15000 then
                    toremove[name]=true
                end
            end
            for k in pairs(toremove) do _S.flames.onFire[k]=nil end
        end,
        emotePlayed=function(player,emote,param)
            if emote==tfm.enum.emote.confetti or (emote==tfm.enum.emote.flag and param=="us") then
                local x=tfm.get.room.playerList[player.name].x
                local y=tfm.get.room.playerList[player.name].y
                for k,v in pairs(_S.flames.decorations) do
                    local x2=v.x+_S.flames.lamps[v.id].x
                    local y2=v.y+_S.flames.lamps[v.id].y
                    if inSquare(x+(player.facingRight and 50 or -50),y,x2,y2,40) then
                        if param=="us" then tfm.exec.chatMessage("Please stop burning the US flag :(",player.name) end
                        _S.flames.onFire[player.name]=os.time()
                        break
                    end
                end
            end
        end,
    },
    fireParticles=function(x,y)
        for i = 1, 5 do
            local x = x + math.random(-15, 15)
            local y = y - math.random(0, 10) - 5
            local vx = math.random(-1, 1) / 10
            local vy = -(math.random(50, 100) / 100)
            for j = 1, 2 do
                tfm.exec.displayParticle(_S.flames.ids[math.random(#_S.flames.ids)], x, y, vx, vy, 0, 0, nil)
            end
        end
    end
}