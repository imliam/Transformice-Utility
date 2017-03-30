function eventSummoningEnd(name, type, x, y, ang, other)
    -- Notify listeners
    SPAWNEDOBJS[other.id] = true
    notifyNameListeners(name, function(player,sn,s)
        local cb=s.callbacks.summoningEnd
        if cb then
            cb(player,type,x,y,ang,other)
        end
    end)
end