function eventEmotePlayed(name,emote,param)
    -- Notify listeners
    notifyNameListeners(name, function(player,sn,s)
        local cb=s.callbacks.emotePlayed
        if cb then
            cb(player,emote,param)
        end
    end)
end