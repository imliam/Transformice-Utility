function eventPlayerRespawn(name)
    players[name].facingRight=true
    players[name].lastSpawn=os.time()
    -- Notify listeners
    notifyNameListeners(name, function(player,sn,s)
        local cb=s.callbacks.playerRespawn
        if cb then
            cb(player)
        end
    end)
end