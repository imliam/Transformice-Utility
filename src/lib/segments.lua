function toggleSegment(name,segment,active)
    if active then
        activateSegment(name,segment)
    else
        deactivateSegment(name,segment)
    end
end

function activateSegment(name,segment)
    local s=_S[segment]
    if s.callbacks.keyboard then
        for key in pairs(s.callbacks.keyboard) do
            system.bindKeyboard(name,key,true,true)
            system.bindKeyboard(name,key,false,true)
        end
    end
    if s.onEnable then
        s.onEnable(players[name])
    end
    players[name].activeSegments[segment]=true
    _S.global.showMenu(name)
end

function deactivateSegment(name,segment)
    local s=_S[segment]
    local mouse
    local keys={}
    if s.callbacks.keyboard then
        for key in pairs(s.callbacks.keyboard) do
            keys[key]=true
        end
        
        -- See if anything else needs to use it, if so it won't unbind.
        for seg in pairs(players[name].activeSegments) do
            if _S[seg] and _S[seg].callbacks then
                if _S[seg].callbacks.keyboard then
                    for key in pairs(_S[seg].callbacks.keyboard) do
                        if keys[key] then
                            keys[key]=nil
                        end
                    end
                end
                if _S[seg].callbacks.mouse then
                    mouse=true
                end
            end
        end
        for key in pairs(keys) do
            system.bindKeyboard(name,key,true,false)
            system.bindKeyboard(name,key,false,false)
        end
    end
    if s.onDisable then
        s.onDisable(players[name])
    end
    players[name].activeSegments[segment]=nil
    _S.global.showMenu(name)
end

function bindChatCommands()
    for _,segment in pairs(_S) do
        if segment.callbacks and segment.callbacks.chatCommand then
            for cmd in pairs(segment.callbacks.chatCommand) do
                system.disableChatCommandDisplay(cmd,true)
            end
        end
    end
end

function defaultToggleSegmentChatCallback(segment)
    local fn=function(player,...)
        local arg={...}
        if arg[1] and (arg[1] == "on" or arg[1] == "off") then
            table.insert(arg, 1, "all") -- insert "all" at 1, moving "on" or "off" to index 2
            executeCommand(player, function(a, enable)
                toggleSegment(a,segment,enable == "on")
            end, arg)
        else
            executeCommand(player, function(a)
                toggleSegment(a,segment,not players[a].activeSegments[segment])
            end, arg)
        end
    end
    return fn
end

function executeCommand(player,f,arg)
    local getTargets = function()
        local ret = {}
        local addMe = function(args)
            ret[player.name] = args
        end
        local str = arg[1]
        if str then
            if str == "all" or str == "*" then
                table.remove(arg, 1)
                for n in pairs(players) do
                    ret[n] = arg
                end
            elseif str == "me" then
                table.remove(arg, 1)
                addMe(arg)
            else
                local i = 0
                for j,a in ipairs(arg) do
                    local n = tonumber(a) or upper(a)
                    if players[n] then
                        ret[n] = true
                    else
                        break
                    end
                    i = j
                end
                if i == 0 then
                    addMe(arg)
                else
                    local tmp = {}
                    for k = 1, #arg - i do
                        tmp[k] = arg[i + k]
                    end
                    for n in pairs(ret) do
                        ret[n] = tmp
                    end
                end
            end
        else
            addMe(arg)
        end
        return ret
    end
    local targets = getTargets() -- of the shape {name1={rest of the arguments}, name2={...}, name3={...}, ...}
    -- if there are no more non-name arguments it will be {name1=true, name2=true, name3=true} mesa thinks
    for t,args in pairs(targets) do
        f(t, unpack(args)) -- t is targetName, followed by rest of arguments
    end
    return targets
end