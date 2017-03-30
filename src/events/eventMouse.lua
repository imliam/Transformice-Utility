function eventMouse(name,x,y)
    -- Initialize notify order
    if not notifyOrder.mouse then
        initNotifyOrder("mouse")
    end
    -- Notify listeners
    notifyNameListeners(name, function(player,sn,s)
        local cb=s.callbacks.mouse
        if cb then
            if cb.fnc(player,x,y) then return true end
        end
        return false
    end, "mouse")
end