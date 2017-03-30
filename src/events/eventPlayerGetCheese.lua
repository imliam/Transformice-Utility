function eventPlayerGetCheese(name)
    -- Notify listeners
    notifyNameListeners(name, function(player,sn,s)
        local cb=s.callbacks.playerGetCheese
        if cb then
            cb(player)
        end
    end)
end