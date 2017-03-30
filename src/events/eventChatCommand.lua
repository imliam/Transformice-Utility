function eventChatCommand(name,message)
    local args = string.split(message, "%s")
    local cmd = table.remove(args, 1)

    notifyNameListeners(name, function(player,sn,s)
        if s.callbacks.chatCommand then
            local cb=s.callbacks.chatCommand[cmd]
            if cb then
                local privLevel=cb.rank or 1
                if ranks[name]>=privLevel then
                    if not cb.hide  then
                        for pn,r in pairs(ranks) do
                            if players[pn] and r>=RANKS.ROOM_ADMIN then
                                tfm.exec.chatMessage("<font color='#AAAAAA'>&#926; ["..name.."] !"..message.."</font>",pn)
                            end
                        end
                    end
                    cb.fnc(player, unpack(args))
                else
                    tfm.exec.chatMessage(translate("nocmdperms",player.lang),name)
                end
            end
        end
    end)
end