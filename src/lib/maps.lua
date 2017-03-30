function randomMap(tbl)
    if tbl.associative then
        local t={}
        for k,v in pairs(tbl) do
            if k~="associative" then
                table.insert(t,v)
            end
        end
        local m=t[math.random(#t)]
        if type(m)=="table" then
            return m[math.random(#m)]
        else
            return m
        end
    else
        return tbl[math.random(#tbl)]
    end
end

function selectMap(map,category)
    if map then
        if category and maps[category] and (maps[category][tonumber(map)] or maps[category][map]) then
            local m=maps[category][tonumber(map)] or maps[category][map]
            if type(m)=="table" then m=table.random(m,false,true) end
            playMap(m)
        elseif category and maps[category] then
            playMap(randomMap(maps[category]))
        elseif category and modes[tostring(category):lower()] then
            tempMode=category:lower()
            playMap(map)
        elseif maps[map] then
            playMap(randomMap(maps[map]))
        else
            playMap(map)
        end
    else
        if mapInfo.queue[1] then
            playMap(mapInfo.queue[1].map)
            tfm.exec.chatMessagePublic("loadingmap",players,mapInfo.queue[1].map,mapInfo.queue[1].name)
            table.remove(mapInfo.queue,1)
        else
            local tbl={} for k,v in pairs(SETTINGS.ROTATION) do table.insert(tbl,k) end
            local category=tbl[math.random(#tbl)]
            playMap(randomMap(maps[category]) or 0)
        end
    end
end

function playMap(map)
    local timeSinceLastLoad=os.time()-mapInfo.lastLoad
    if timeSinceLastLoad<=3000 then
        --tfm.exec.chatMessage("Error. Map trying to reload: "..map)
        local timeUntilNextLoad=3000-timeSinceLastLoad
        if timeUntilNextLoad<1000 then timeUntilNextLoad=1000 end
        if mapInfo.timer then system.removeTimer(mapInfo.timer) mapInfo.timer=nil end
        mapInfo.timer=system.newTimer(function(...)
            local arg={...}
            --tfm.exec.chatMessage("Reloading "..tostring(arg[2]))
            playMap(arg[2])
        end,timeUntilNextLoad,false,map,map)
    else
        --tfm.exec.chatMessage("Map "..map.." loaded!")
        tfm.exec.newGame(map,false)
        mapInfo.lastLoad=os.time()
    end
end

function parseMapXML()
    local m={
        loaded=false,
        segments={},
        grounds={},
        decorations={},
        spawns={},
        shamspawns={},
        holes={},
        cheese={},
        length=800,
        height=400,
        code=tonumber(string.match(tfm.get.room.currentMap,"%d+")) or 0,
        wind=0,
        gravity=10,
    }
    if #tostring(m.code)<=3 and tfm.get.room.currentMap~="@0" then
        m.mode="vanilla"
    else
        m.xml=tfm.get.room.xmlMapInfo.xml
        local g=getValueFromXML
        local P=m.xml:match('<C><P (.-) /><Z>') or ""
        m.perm=tfm.get.room.xmlMapInfo.permCode
        m.author=g(P,"author") or tfm.get.room.xmlMapInfo.author or "Tigrounette"
        m.title=g(P,"title")
        m.id=g(P,"id")
        m.length=g(P,"L") or 800
        m.height=g(P,"H") or 400
        m.reload=g(P,"reload") and true or false
        local bg=g(P,"bg")
        if bg then m.bg=getBackgrounds(bg,".jpg") end
        local bg=g(P,"bg")
        if fg then m.bg=getBackgrounds(fg,".png") end
        local wg=g(P,"G")
        if wg and #wg>2 then
            wg=string.split(wg,",")
            m.wind=tonumber(wg[1]) or 0
            m.gravity=tonumber(wg[2]) or 10
        end
        local segmentstr=g(P,"segments")
        if segmentstr then
            for k,v in pairs(string.split(segmentstr,",")) do
                m.segments[v]=true
            end
        end
        m.collision=g(P,"C") and true
        m.soulmate=g(P,"A") and true
        m.nightmode=g(P,"N") and true
        m.aie=g(P,"aie") and true
        m.portals=g(P,"P") and true
        m.mgoc=g(P,"mgoc")
        for ground in m.xml:gmatch("<S [^/]+/>") do
            local P=string.split(g(ground,"P"),",")
            table.insert(m.grounds,{
                id=#m.grounds+1,
                x=g(ground,"X"),
                y=g(ground,"Y"),
                height=g(ground,"H"),
                length=g(ground,"L"),
                type=g(ground,"T"),
                color=g(ground,"o"),
                dynamic=tonumber(P[1]),
                mass=tonumber(P[2]),
                friction=tonumber(P[3]),
                restitution=tonumber(P[4]),
                rotation=tonumber(P[5]),
            })
        end
        local openingP=true
        for decoration in m.xml:gmatch("<P[^/]+/>") do
            if not openingP then
                local P=string.split(g(decoration,"P"),",")
                table.insert(m.decorations,{
                    id=g(decoration,"T"),
                    x=g(decoration,"X"),
                    y=g(decoration,"Y"),
                    color=C,
                    flip=P[2]=="1" and true or nil
                })
            end
            openingP=nil
        end
        for spawn in m.xml:gmatch("<DS [^/]+/>") do
            table.insert(m.spawns,{
                x=g(spawn,"X"),
                y=g(spawn,"Y"),
            })
        end
        --[[
        local multispawns=g(P,"DS")
        if multispawns then
            multispawns=string.split(multispawns,",")
            for i=1,#multispawns,2 do
                if tonumber(multispawns[i]) and tonumber(multispawns[i+1]) then
                    tableinsert(m.spawns,{
                        x=tonumber(multispawns[i]),
                        y=tonumber(multispawns[i+1])
                    })
                end
            end
        end
        ]]
        for spawn in m.xml:gmatch("<DC [^/]+/>") do
            table.insert(m.shamspawns,{
                x=g(spawn,"X"),
                y=g(spawn,"Y"),
            })
        end
        for spawn in m.xml:gmatch("<DC2 [^/]+/>") do
            table.insert(m.shamspawns,{
                x=g(spawn,"X"),
                y=g(spawn,"Y"),
            })
        end
        for hole in m.xml:gmatch("<T [^/]+/>") do
            table.insert(m.holes,{
                x=g(hole,"X"),
                y=g(hole,"Y"),
            })
        end
    end
    return m
end

function getValueFromXML(str,attribute)
    return tonumber(str:match(('%s="([^"]+)"'):format(attribute))) or str:match(('%s="([^"]+)"'):format(attribute)) or str:match(('%s=""'):format(attribute))
end

function getBackgrounds(str,extension)
    local imgs={}
    for _,bg in ipairs(string.split(str,";")) do
        local t={img="",x=0,y=0}
        for i,s in ipairs(string.split(bg,",")) do
            if i==1 then t.img=s
            elseif i==2 and tonumber(s) then t.x=tonumber(s)
            elseif i==3 and tonumber(s) then t.y=tonumber(s) end
        end
        if not t.img:find("%.") then
            t.img=t.img..extension
        end
        --if #t.img>11 then
            table.insert(imgs,t)
        --end
    end
    return #imgs>0 and imgs or nil
end

function setMapName()
    if map.id then
        ui.setMapName("<J>"..map.id)
    elseif map.title and map.author then
        ui.setMapName("<J>"..map.title.." <BL>- "..map.author)
    elseif map.title then
        ui.setMapName("<J>"..map.title)
    elseif map.author and map.author~=tfm.get.room.xmlMapInfo.author then
        ui.setMapName("<J>"..map.author.." <BL>- "..map.code)
    end
end