function eventPlayerLeft(name)
    -- Notify listeners
    notifyNameListeners(name, function(player,sn,s)
        local cb=s.callbacks.playerLeft
        if cb then
            cb(player)
        end
    end)
    if ranks[name]>=RANKS.ROOM_ADMIN then
        for n,r in pairs(ranks) do
            if r>=RANKS.ROOM_ADMIN and players[n] then
                tfm.exec.chatMessage("<font color='#AAAAAA'>&#926; ["..upper(moduleName).."] "..(translate("leftroom",players[n].lang):format(name)).."</font>",n)
           end
       end
    end
    players[name]=nil
end