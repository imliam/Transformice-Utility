function eventNewPlayer(name)
    local player={
        activeSegments={},
        name=name,
        lang=tfm.get.room.playerList[name].community or "en"
    }
    if not ranks[name] then
        ranks[name]=1
    end
    -- Combine defaultPlayer with player
    for _,s in pairs(_S) do
        if s.defaultPlayer then
            s.defaultPlayer(player)
        end
    end
    players[name]=player
    tfm.exec.lowerSyncDelay(name)

    -- Activates segments
    for sn,s in pairs(_S) do
        if player.activeSegments[sn] then
            activateSegment(name,sn)
        end
    end

    -- Show recent changelog
    if showChangelog(7,3,player) then
        tfm.exec.chatMessage(showChangelog(7,3,player),name)
    end
    
    -- Show random greeting message
    local greets=translate("greetings",player.lang)
    tfm.exec.chatMessage("<J>"..greets[math.random(#greets)],name)

    -- Ranks
    local tribeName=tfm.get.room.playerList[name].tribeName
    if tribeName then
        if string.byte(tfm.get.room.name,2)==3 and (tfm.get.room.name:lower()):match(tfm.get.room.playerList[name].tribeName:lower())then
            ranks[name]=4
        elseif suffix and ((suffix:lower()):match(name:lower()) or (suffix:lower()):match(tfm.get.room.playerList[name].tribeName:lower())) then
            ranks[name]=4
        end
    end
    if not ranks[name] then
        ranks[name]=1
    end
    if ranks[name]>=RANKS.ROOM_ADMIN then
        for n,r in pairs(ranks) do
            if r>=RANKS.ROOM_ADMIN and players[n]then
                tfm.exec.chatMessage("<font color='#AAAAAA'>&#926; ["..upper(moduleName).."] "..(translate("joinedroom",players[n].lang):format(name)).."</font>",n)
           end
       end
    end

    system.bindMouse(name,true)

    -- Notify listeners
    notifyListeners(function(sn,s)
        if not s.disabled or (map.segments and map.segments[sn]) then
            local cb=s.callbacks.newPlayer
            if cb then
                cb(player)
            end
        end
    end)
    if SETTINGS.QUICKRESPAWN then
        toRespawn[name]=os.time()
    end
    if _S.global.tempMapName then
        ui.setMapName("<J>".._S.global.tempMapName)
    else
        setMapName()
    end
    if map.bg then for i,image in pairs(map.bg) do tfm.exec.addImage(image.img,"?"..(1-i),image.x,image.y) end end
    if map.fg then for i,image in pairs(map.fg) do tfm.exec.addImage(image.img,"!"..(50+i),image.x,image.y) end end
end