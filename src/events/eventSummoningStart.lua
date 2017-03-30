function eventSummoningStart(name, type, x, y, ang)
    -- Notify listeners
    notifyNameListeners(name, function(player,sn,s)
        local cb=s.callbacks.summoningStart
        if cb then
            cb(player,type,x,y,ang)
        end
    end)
end