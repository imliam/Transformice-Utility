function eventNewGame()
    if timerID then
        system.removeTimer(timerID)
    end
    map=parseMapXML()
    if tempMode then map.mode=tempMode end
    if map.reload and (map.code and map.code~=0) then
        system.newTimer(function() selectMap(tfm.get.room.xmlMapInfo.xml) end,3000,false)
    else
        if map.mode and modes[map.mode] then
            map.segments[modes[map.mode]]=true
        end
    end
    if not map.mode then map.mode="tribehouse" end
    tempMode=nil
    for name,player in pairs(players) do
        player.facingRight=true
        player.lastSpawn=os.time()
    end
    
    if SETTINGS.VOTE_TIME then
        SETTINGS.VOTE_TIME.votes={}
    end
    
    if SETTINGS.VOTE_SKIP then
        SETTINGS.VOTE_SKIP.votes={}
        SETTINGS.VOTE_SKIP.skipped=nil
    end
    
    -- Notify listeners
    notifyListeners(function(sn,s)
        if not s.disabled or (map.segments and map.segments[sn]) then
            local cb=s.callbacks.newGame
            if cb then
                cb()
            end
        end
    end)
    for key,segment in pairs(_S) do
        if segment.toDespawn then
            segment.toDespawn={}
        end
    end
    setMapName()
    
    if map.bg then for i,image in pairs(map.bg) do tfm.exec.addImage(image.img,"?"..(1-i),image.x,image.y) end end
    if map.fg then for i,image in pairs(map.fg) do tfm.exec.addImage(image.img,"!"..(50+i),image.x,image.y) end end
end