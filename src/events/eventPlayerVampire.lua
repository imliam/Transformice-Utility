function eventPlayerVampire(name)
    -- Notify listeners
    notifyNameListeners(name, function(player,sn,s)
        local cb=s.callbacks.playerVampire
        if cb then
            cb(player)
        end
    end)
end