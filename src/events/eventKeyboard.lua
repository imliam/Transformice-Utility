function eventKeyboard(name,key,down,x,y)
    -- Notify listeners
    notifyNameListeners(name, function(player,sn,s)
        if s.callbacks.keyboard then
            local cb=s.callbacks.keyboard[key]
            if cb then
                cb(player,down,x,y)
            end
        end
    end)
end