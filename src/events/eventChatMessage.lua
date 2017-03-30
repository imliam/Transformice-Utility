function eventChatMessage(name,message)
    -- Notify listeners
    notifyNameListeners(name, function(player,sn,s)
        local cb=s.callbacks.chatMessage
        if cb then
            cb(player)
        end
    end)

    -- Dad jokes galore!
    if math.random(1,200)==1 then
        local lowermessage=message:lower()
        for _,im in ipairs({"i'm ","im ","i'm","im"}) do
            local found=lowermessage:find(im)
            if found and #message>#im then
                tfm.exec.chatMessage("<V>[Dad] <N>Hi "..message:sub(found+#im)..", I'm dad!</b>",name)
                break
            end
        end
    end
end