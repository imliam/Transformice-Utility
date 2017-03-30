function eventPlayerWon(name)
    -- Notify listeners
    notifyNameListeners(name, function(player,sn,s)
        local cb=s.callbacks.playerWon
        if cb then
            cb(player)
        end
    end)
    if SETTINGS.QUICKRESPAWN then
        toRespawn[name]=os.time()
    end
end