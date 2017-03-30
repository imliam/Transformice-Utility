function eventColorPicked(id, name, color)
    -- Notify listeners
    notifyNameListeners(name, function(player,sn,s)
        if s.callbacks.colorPicked then
            local cb=s.callbacks.colorPicked
            if cb then
                cb(player,id,color)
            end
        end
    end)
end