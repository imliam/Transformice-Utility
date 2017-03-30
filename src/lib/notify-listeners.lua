-- Notify each active segment that an event has occured

function initNotifyOrder(event)
    local segmentNames={}
    for sn,s in pairs(_S) do
        if s.callbacks[event] then
            local niceness=s.callbacks[event].pr or 20
            table.insert(segmentNames, {sn, niceness})
        end
    end
    table.sort(segmentNames, function(a,b)
        return a[2] < b[2]
    end)
    notifyOrder[event]=segmentNames
end

function notifyListeners(f,prioritized)
    if prioritized then
        for _,no in ipairs(notifyOrder[prioritized]) do
            local sn=no[1]
            local s=_S[sn]
            if f(sn,s) then break end
        end
    else
        local stop=f("global",_S.global)
        for sn,s in pairs(_S) do
            if stop then break end
            if sn~="global" then
                stop=f(sn,s)
            end
        end
    end
end

function notifyNameListeners(name,f,prioritized)
    local player=players[name]
    if prioritized then
        for _,no in ipairs(notifyOrder[prioritized]) do
            local sn=no[1]
            local s=_S[sn]
            if player and (player.activeSegments[sn] or (map.segments and map.segments[sn])) then
                if f(player,sn,s) then break end
            end
        end
    else
        local stop=f(player,"global",_S.global)
        for sn,s in pairs(_S) do
            if stop then break end
            if sn~="global" then
                if player and (player.activeSegments[sn] or (map and map.segments and map.segments[sn])) then
                    stop=f(player,sn,s)
                end
            end
        end
    end
end