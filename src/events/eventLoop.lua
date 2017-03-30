function eventLoop(time,remaining)
    currentTime=remaining
    -- Notify listeners
    notifyListeners(function(sn,s)
        if not s.disabled or (map.segments and map.segments[sn]) then
            local cb=s.callbacks.eventLoop
            if cb then
                cb(time,remaining)
            end
        end
    end)
    if not SETTINGS.DISABLEAUTONEWGAME and remaining<=0 and not map.mode == "tribehouse" then
        selectMap()
    end
    if SETTINGS.QUICKRESPAWN and not (map.reload and tfm.get.room.currentMap~=0) and time>=3000 then
        local tbl={}
        for n,t in pairs(toRespawn) do
            if t<=os.time()-1000 then
                tfm.exec.respawnPlayer(n)
            else
                tbl[n]=t
            end
        end
        toRespawn=tbl
    end
    for key,segment in pairs(_S) do
        if segment.toDespawn then
            for i = #segment.toDespawn, 1, -1 do
                local object = segment.toDespawn[i]
                if object.despawn<=os.time() then
                    tfm.exec.removeObject(object.id)
                    table.remove(segment.toDespawn,i)
                end
            end
        end
    end
end