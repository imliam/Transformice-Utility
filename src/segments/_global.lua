-- Global segment that's always active and contains default functionality

_S.global = {
    defaultPlayer=function(player)
        player.activeSegments.global=true
        player.ctrl=false
        player.shift=false
        player.facingRight=true
        player.selected={}
    end,
    menu=function(player)
        return {
            --title="Help"
            {callback="global help",icon="?",width=40},
            {callback="global players",icon="Players",width=60},
        }
    end,
    menuCondition=function(player) return true end,
    shamObjects={},
    tempMapName=nil,
    selectPlayer=function(player,selection,x,y)
        if selection then
            if player.selected[selection] then
                player.selected[selection]=nil
            else
                player.selected[selection]=true
            end
        end
        local str=("<a href='event:global select all %s %s'>[%s]</a> <a href='event:global select none %s %s'>[%s]\n</a>"):format(x,y,translate("all",player.lang),x,y,translate("none",player.lang))
        local total=0
        local selected=0    
        for n,p in pairs(players) do
            str=str.."\n<font color='#"..(player.selected[n] and "2ECF73" or "C2C2DA").."'><a href='event:global select "..n.." "..x.." "..y.."'>"..(ranks[n]>=RANKS.ROOM_ADMIN and "★ " or "")..n.."</a>"
            total=total+1
            if player.selected[n] then
                selected=selected+1
            end
        end
        ui.addTextArea(0,str,player.name,x,y,nil,nil,nil,nil,0.5,true)
    end,
    callbacks={
        newGame=function()
            _S.global.tempMapName=nil
        end,
        newPlayer=function(player)
            _S.global.showMenu(player.name)
        end,
        playerLeft=function(player)
            for n,p in pairs(players) do
                if p.selected[player.name] then
                    p.selected[player.name]=nil
                end
            end
        end,
        textArea={
            players=function(id,name,arg)
                if players[name].dropdown and players[name].dropdown=="players" then
                    players[name].dropdown=nil
                    ui.removeTextArea(0,name)
                else
                    local ta
                    for k,v in pairs(players[name].menu) do
                        if v.id==id then ta=v end
                    end
                    _S.global.selectPlayer(players[name],nil,ta.x,ta.y+30)
                    players[name].dropdown="players"
                end
            end,
            select=function(id,name,arg)
                local x,y=tonumber(arg[4]),tonumber(arg[5])
                if arg[3]=="all" then
                    for n,p in pairs(tfm.get.room.playerList) do
                        players[name].selected[n]=true
                    end
                    _S.global.selectPlayer(players[name],nil,x,y)
                elseif arg[3]=="none" then
                    for n,p in pairs(tfm.get.room.playerList) do
                        players[name].selected[n]=nil
                    end
                    _S.global.selectPlayer(players[name],nil,x,y)
                elseif tfm.get.room.playerList[arg[3]] then
                    _S.global.selectPlayer(players[name],arg[3],x,y)
                end
            end
        },
        keyboard={
            [KEYS.SHIFT]=function(player,down,x,y)
                player.shift=down
            end,
            [KEYS.CTRL]=function(player,down,x,y)
                player.ctrl=down
            end,
            [KEYS.LEFT]=function(player,down,x,y)
                if down then player.facingRight=false end
            end,
            [KEYS.RIGHT]=function(player,down,x,y)
                if down then player.facingRight=true end
            end,
            [KEYS.DELETE]=function(player,down,x,y)
                tfm.exec.killPlayer(player.name)
            end,
        },
        mouse={
            pr=-20,
            fnc=function(player,x,y)
                if _S.omo and _S.omo.welcomed[player.name] then
                    local id=_S.omo.startID
                    for i=1,10 do
                        ui.removeTextArea(id+i,player.name)
                    end
                    _S.omo.welcomed[player.name]=nil
                elseif _S.splashScreen and _S.splashScreen.welcomed[player.name] then
                    tfm.exec.removeImage(_S.splashScreen.welcomed[player.name].img)
                    _S.splashScreen.welcomed[player.name]=nil
                elseif player.shift and player.ctrl then
                    tfm.exec.chatMessage("X:"..x.."   Y:"..y,player.name)
                    return true
                elseif player.shift then
                    -- Inspect ground.
                    return false
                elseif player.ctrl then
                    if ranks[player.name]>=RANKS.ROOM_ADMIN then
                        tfm.exec.movePlayer(player.name,x,y)
                    end
                    return true
                end
            end
        },
        chatCommand={
            win={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,...)
                    local arg={...}
                    executeCommand(player, function(a)
                        tfm.exec.giveCheese(a)
                        tfm.exec.playerVictory(a)
                    end, arg)
                end
            },
            cheese={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,...)
                    local arg={...}
                    executeCommand(player, function(a)
                        tfm.exec.giveCheese(a)
                    end, arg)
                end
            },
            victory={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,...)
                    local arg={...}
                    executeCommand(player, function(a)
                        tfm.exec.playerVictory(a)
                    end, arg)
                end
            },
            kill={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,...)
                    local arg={...}
                    executeCommand(player, function(a)
                        tfm.exec.killPlayer(a)
                    end, arg)
                end
            },
            respawn={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,...)
                    local arg={...}
                    executeCommand(player, function(a)
                        tfm.exec.respawnPlayer(a)
                    end, arg)
                end
            },
            r={rank=RANKS.ROOM_ADMIN,fnc=function(player,...) _S.global.callbacks.chatCommand.respawn.fnc(player,...) end},
            vampire={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,...)
                    local arg={...}
                    executeCommand(player, function(a)
                        tfm.exec.setVampirePlayer(a)
                    end, arg)
                end
            },
            vamp={rank=RANKS.ROOM_ADMIN,fnc=function(player,...) _S.global.callbacks.chatCommand.vampire.fnc(player,...) end},
            meep={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,...)
                    local arg={...}
                    executeCommand(player, function(a, power)
                        tfm.exec.giveMeep(a)
                        players[a].meepPower=tonumber(power) or false
                        players[a].meepTimer=os.time()
                        toggleSegment(a, "meep", not tonumber(arg[1]) and not players[a].activeSegments.meep or tonumber(arg[1]))
                        if not players[a].activeSegments.meep then tfm.exec.chatMessage(translate("meepremovednextround",player.lang), a) end
                    end, arg)
                end
            },
            shaman={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,...)
                    local arg={...}
                    executeCommand(player, function(a)
                        tfm.exec.setShaman(a)
                    end, arg)
                end
            },
            sham={rank=RANKS.ROOM_ADMIN,fnc=function(player,...) _S.global.callbacks.chatCommand.shaman.fnc(player,...) end},
            s={rank=RANKS.ROOM_ADMIN,fnc=function(player,...) _S.global.callbacks.chatCommand.shaman.fnc(player,...) end},
            mort={
                rank=RANKS.ANY,
                hide=true,
                fnc=function(player)
                    tfm.exec.killPlayer(player.name)
                end
            },
            die={rank=RANKS.ANY,hide=true,fnc=function(player,...) _S.global.callbacks.chatCommand.mort.fnc(player,...) end},
            me={
                rank=RANKS.ANY,
                hide=true,
                fnc=function(player,...)
                    local arg={...}
                    if arg[1] then
                        tfm.exec.chatMessage("<V>*"..player.name.." <N>"..(table.concat(arg," ")))
                    end
                end
            },
            mod={
                rank=RANKS.STAFF,
                hide=true,
                fnc=function(player,...)
                    local arg={...}
                    if arg[1] then
                        tfm.exec.chatMessage("<ROSE><b>["..player.name.."] "..(table.concat(arg," ")).."</b>")
                    end
                end
            },
            mapname={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,...)
                    local arg={...}
                    if arg[1] then
                        _S.global.tempMapName=table.concat(arg," ")
                        ui.setMapName("<J>".._S.global.tempMapName)
                    end
                end
            },
            c={
                rank=RANKS.ROOM_ADMIN,
                hide=true,
                fnc=function(player,...)
                    local arg={...}
                    if arg[1] then
                        for n,p in pairs(tfm.get.room.playerList) do
                            if ranks[n]>=RANKS.ROOM_ADMIN then
                                tfm.exec.chatMessage("<font color='#00FFFF'>&#926; ["..player.name.."] "..(table.concat(arg," ")).."</font>",n)
                            end
                        end
                    end
                end
            },
            t={rank=RANKS.ROOM_ADMIN,hide=true,fnc=function(player,...) _S.global.callbacks.chatCommand.c.fnc(player,...) end},
            draw={
                rank=RANKS.ROOM_ADMIN,
                fnc=defaultToggleSegmentChatCallback("draw")
            },
            drawonme={
                rank=RANKS.ROOM_ADMIN,
                fnc=defaultToggleSegmentChatCallback("drawOnMe")
            },
            ffa={
                rank=RANKS.ROOM_ADMIN,
                fnc=defaultToggleSegmentChatCallback("ffa")
            },
            lightning={
                rank=RANKS.ROOM_ADMIN,
                fnc=defaultToggleSegmentChatCallback("lightning")
            },
            fly={
                rank=RANKS.ROOM_ADMIN,
                fnc=defaultToggleSegmentChatCallback("fly")
            },
            dash={
                rank=RANKS.ROOM_ADMIN,
                fnc=defaultToggleSegmentChatCallback("dash")
            },
            projection={
                rank=RANKS.ROOM_ADMIN,
                fnc=defaultToggleSegmentChatCallback("projection")
            },
            inspect={
                rank=RANKS.ALL,
                fnc=defaultToggleSegmentChatCallback("inspect")
            },
            prophunt={
                rank=RANKS.ALL,
                fnc=defaultToggleSegmentChatCallback("prophunt")
            },
            clear={
                rank=RANKS.ROOM_ADMIN,
                fnc = function()
                    for objectId in pairs(SPAWNEDOBJS) do
                        tfm.exec.removeObject(objectId) 
                    end
                    SPAWNEDOBJS = {}
                end
            },
            name={
                rank=RANKS.ANY,
                fnc=function(player,color,...)
                    local arg={...}
                    if color then
                        if tonumber(color)==0 then
                            color=0
                        else
                            local c=getColor(color)
                            if c then
                                color=c
                            else
                                tfm.exec.chatMessage(translate("invalidargument",player.lang),player.name)
                            end
                        end
                    else
                        color=0
                    end
                    if color then
                        executeCommand(player,function(target)
                            tfm.exec.setNameColor(target,color)
                        end,arg)
                    end
                end
            },
            speed={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,power,...)
                    local arg={...}
                    power=tonumber(power) or 100
                    executeCommand(player, function(targetName)                         
                        local target = targetName and players[targetName] or player
                        target.speedPower=tonumber(power) or 100 
                        toggleSegment(target.name, "speed", not tonumber(arg[1]) and not target.activeSegments.speed or tonumber(arg[1]) and true)
                    end, arg)
                end
            },
            conj={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,...)
                    local arg={...}
                    executeCommand(player,function(target,time)
                        players[target].conjTime=time or 10
                        toggleSegment(target, "conj", not arg[1] and not players[target].activeSegments.conj or arg[1] and true)
                    end,arg)
                end
            },
            emote={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,...)
                    local arg={...}
                    executeCommand(player,function(target,emote)
                        if emote and tfm.enum.emote[emote:lower()] then
                            tfm.exec.playEmote(target,tfm.enum.emote[emote:lower()])
                        elseif tonumber(emote) then
                            tfm.exec.playEmote(target,tonumber(emote))
                        end
                    end,arg)
                end
            },
            flag={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,...)
                    local arg={...}
                    executeCommand(player,function(target,flag)
                        tfm.exec.playEmote(target,tfm.enum.emote.flag,flag)
                    end,arg)
                end
            },
            f={rank=RANKS.ROOM_ADMIN,fnc=function(player,...) _S.global.callbacks.chatCommand.flag.fnc(player,...) end},
            insta={
                rank=RANKS.ROOM_ADMIN,
                fnc=defaultToggleSegmentChatCallback("insta")
            },
            ratapult={
                rank=RANKS.ROOM_ADMIN,
                fnc=defaultToggleSegmentChatCallback("ratapult")
            },
            checkpoints={
                rank=RANKS.ROOM_ADMIN,
                fnc=defaultToggleSegmentChatCallback("checkpoints")
            },
            checkpoint={rank=RANKS.ROOM_ADMIN,fnc=function(player,...) _S.global.callbacks.chatCommand.checkpoints.fnc(player,...) end},
            cp={rank=RANKS.ROOM_ADMIN,fnc=function(player,...) _S.global.callbacks.chatCommand.checkpoints.fnc(player,...) end},
            rainbow={
                rank=RANKS.ROOM_ADMIN,
                fnc=defaultToggleSegmentChatCallback("rainbow")
            },
            meow={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player)
                    local tbl={6356881,6780029}
                    selectMap(tbl[math.random(#tbl)])
                    for n,p in pairs(players) do
                        _S.images.selectImage(p,"pusheen")
                    end
                    tfm.exec.setGameTime(9999999)
                        _S.global.tempMapName=("%s  <BL>|  %s %s %s"):format(translate("meow"),translate("meow"),translate("meow"),translate("meow"))
                        ui.setMapName("<J>".._S.global.tempMapName)
                end
            },
            pw={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,password)
                    if password then
                        tfm.exec.setRoomPassword(password)
                        pw=password
                        tfm.exec.chatMessage("Room password changed to: "..password,player.name)
                    elseif pw then
                        tfm.exec.setRoomPassword("")
                        pw=nil
                        tfm.exec.chatMessage("Room password reset.",player.name)
                    elseif not pw then
                        tfm.exec.chatMessage("The room currently has no password.",player.name)
                    end
                end
            },
            np={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,mapid,category)
                    selectMap(mapid,category)
                end
            },
            map={rank=RANKS.ROOM_ADMIN,fnc=function(player,...) _S.global.callbacks.chatCommand.np.fnc(player,...) end},
            maps={
                rank=RANKS.ANY,
                fnc=function(player,id)
                    local tbl={}
                    if id and maps[id] then
                        for k,v in pairs(maps[id]) do
                            if type(v)=="number" or type(v)=="string" then
                                table.insert(tbl,tostring(v))
                            elseif type(v)=="table" then
                                for kk,vv in pairs(v) do
                                    table.insert(tbl,tostring(vv))
                                end
                            end
                        end
                    else
                        for k,v in pairs(maps) do
                            table.insert(tbl,k)
                        end
                    end
                    tfm.exec.chatMessage(table.concat(tbl,","),player.name)
                end
            },
            maplist={rank=RANKS.ANY,fnc=function(player,...) _S.global.callbacks.chatCommand.maps.fnc(player,...) end},
            npp={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,mapid)
                    if mapid then
                        local alreadyQueued
                        for k,v in ipairs(mapInfo.queue) do
                            if v.map==mapid then
                                alreadyQueued=true
                                break
                            end
                        end
                        if alreadyQueued then
                            tfm.exec.chatMessage(translate("alreadyqueued",player.lang),player.name)
                        else
                            table.insert(mapInfo.queue,{map=mapid,name=player.name})
                            tfm.exec.chatMessage(translate("addedtoqueue",player.lang):format(mapid,#mapInfo.queue),player.name)
                        end
                    else
                        local tbl={}
                        for k,v in pairs(mapInfo.queue) do
                            table.insert(tbl,translate("submittedby",player.lang):format(k,v.map,v.name))
                        end
                        if tbl[1] then
                            tfm.exec.chatMessage(table.concat(tbl,"\n"),name)
                        else
                            tfm.exec.chatMessage(translate("noqueue",player.lang),player.name)
                        end
                    end
                end
            },
            queue={rank=RANKS.ROOM_ADMIN,fnc=function(player,...) _S.global.callbacks.chatCommand.npp.fnc(player,...) end},
            q={rank=RANKS.ROOM_ADMIN,fnc=function(player,...) _S.global.callbacks.chatCommand.npp.fnc(player,...) end},
            doll={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,...)
                    local arg={...}
                    if arg[1] then
                        player.dolls={}
                        --[[
                        for k,v in pairs(arg) do
                            if players[upper(v)] then
                                table.insert(player.dolls,upper(v))
                            end
                        end
                        ]]
                        executeCommand(player, function(target)
                            table.insert(player.dolls,upper(target))
                        end, arg)
                        activateSegment(player.name,"doll")
                    else
                        if player.activeSegments.doll then
                            deactivateSegment(player.name,"doll")
                            player.dolls=nil
                        end
                    end
                end
            },
            time={
                rank=RANKS.ANY,
                fnc=function(player,time)
                    if ranks[player.name]>=RANKS.ROOM_ADMIN then
                        if tonumber(time) then
                            tfm.exec.setGameTime((currentTime/1000)+time)
                            tfm.exec.chatMessagePublic("addedtime",players,player.name,time)
                        end
                        
                    elseif SETTINGS.VOTE_TIME then
                        local totalVotes=0
                        for _ in pairs(SETTINGS.VOTE_TIME.votes) do
                            totalVotes=totalVotes+1
                        end
                        if totalVotes<=SETTINGS.VOTE_TIME.maxVotes and not SETTINGS.VOTE_TIME.votes[player.name] then
                            tfm.exec.setGameTime((currentTime/1000)+SETTINGS.VOTE_TIME.timeToAdd,true)
                            tfm.exec.chatMessagePublic("addedtime",players,player.name,SETTINGS.VOTE_TIME.timeToAdd)
                            SETTINGS.VOTE_TIME.votes[player.name]=true
                        else
                            tfm.exec.chatMessage(translate("cantaddtime",player.lang),player.name)
                        end
                    end
                end
            },
            skip={
                rank=RANKS.ANY,
                fnc=function(player)
                    if SETTINGS.VOTE_SKIP and not SETTINGS.VOTE_SKIP.skipped then
                        if not SETTINGS.VOTE_SKIP.votes[player.name] then
                            SETTINGS.VOTE_SKIP.votes[player.name]=true
                            local total=0
                            local totalVotes=0
                            for n in pairs(players) do
                                total=total+1
                                if SETTINGS.VOTE_SKIP.votes[n] then
                                    totalVotes=totalVotes+1
                                end
                            end
                            local votesRequired=math.floor((total/1.25))
                            tfm.exec.chatMessagePublic("votedtoskip",players,player.name)
                            if totalVotes>=votesRequired then
                                SETTINGS.VOTE_SKIP.skipped=true
                                tfm.exec.chatMessagePublic("roundskipped",players)
                                tfm.exec.setGameTime(5)
                            end
                        else
                            tfm.exec.chatMessage(translate("alreadyvotedtoskip",player.lang),player.name)
                        end
                    end
                end
            },
            print={
                rank=RANKS.STAFF,
                fnc=function(player,...)
                    local arg={...}
                    local tbl=_G
                    local tmp={}
                    if arg[1] and arg[1]:find(".") then
                        tmp=string.split(arg[1],".")
                    end
                    for k,v in pairs(tmp) do
                        if tbl[tonumber(v)] or tbl[v] then
                            tbl=tbl[tonumber(v)] or tbl[v]
                        else
                            tfm.exec.chatMessage("Table doesn't exist.",player.name)
                            return
                        end
                    end
                    if type(tbl)=="string" or type(tbl)=="number" then
                        tfm.exec.chatMessage(tostring(tbl),player.name)
                    else
                        printInfo(arg[1],tbl,player.name)
                    end
                end
            },
            list={
                rank=RANKS.STAFF,
                fnc=function(player,...)
                    local arg={...}
                    local tbl=_G
                    local tmp={}
                    if arg[1] and arg[1]:find(".") then
                        tmp=string.split(arg[1],".")
                    end
                    for k,v in pairs(tmp) do
                        if tbl[tonumber(v)] or tbl[v] then
                            tbl=tbl[tonumber(v)] or tbl[v]
                        else
                            tfm.exec.chatMessage("Table doesn't exist.",player.name)
                            return
                        end
                    end
                    if arg[1] and type(tbl)=="table" then
                        local t={}
                        for k,v in pairs(tbl) do
                            table.insert(t,k)
                        end
                        tfm.exec.chatMessage(table.concat(t,", "),player.name)
                    else
                        tfm.exec.chatMessage("Not a table.",player.name)
                    end
                end
            },
            set={
                rank=RANKS.STAFF,
                fnc=function(player,...)
                    local arg={...}
                    local tbl=_G
                    local tmp={}
                    if arg[1] and arg[1]:find(".") then
                        tmp=string.split(arg[1],".")
                    end
                    for k,v in ipairs(tmp) do
                        local key=tbl[tonumber(v)] and tonumber(v) or v
                        if tmp[k+1] then
                            if tbl[key] then
                                tbl=tbl[key]
                            else
                                tfm.exec.chatMessage("Table doesn't exist.",player.name)
                                break
                            end
                        else
                            if arg[2] then
                                local newval=tonumber(arg[2]) or (arg[2]=="nil" and nil) or (arg[2]=="{}" and {}) or (arg[2]=="true" and true) or (arg[2]=="false" and false) or arg[2]
                                tbl[key]=newval
--                                  tbl=tonumber(arg[2]) or (arg[2]=="nil" and nil) or (arg[2]=="true" and true) or (arg[2]=="false" and false) or arg[2]
                                tfm.exec.chatMessage("Variable set: "..arg[2],player.name)
                            else
                                tfm.exec.chatMessage("No variable set.",player.name)
                            end
                        end
                    end
                end
            },
            skills={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,toggle)
                    local skillsDisabled=SETTINGS.SKILLS
                    if not toggle then
                        if SETTINGS.SKILLS then SETTINGS.SKILLS=false else SETTINGS.SKILLS=true end
                    elseif toggle=="on" then SETTINGS.SKILLS=true
                    elseif toggle=="off" then SETTINGS.SKILLS=false
                    end
                    
                    tfm.exec.disableAllShamanSkills(SETTINGS.SKILLS)
                    tfm.exec.chatMessagePublic(SETTINGS.SKILLS and "enabled" or "disabled",players)
                end
            },
            snow={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,time)
                    tfm.exec.snow(time or 60,10)
                end
            },
            changelog={
                rank=RANKS.ANY,
                fnc=function(player,days,num)
                    if showChangelog(days,num,player) then
                        tfm.exec.chatMessage(showChangelog(days,num,player),player.name)
                    else
                        tfm.exec.chatMessage("There are no recent things in the changelog.",player.name)
                    end
                end
            },
            xml={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,...)
                    local arg={...}
                    if arg[1] then
                        selectMap(table.concat(arg," "):gsub("&lt;","<"))
                    elseif ranks[player.name]>=RANKS.STAFF then
                        local splitnum=800
                        for i=1,#map.xml,splitnum do
                            tfm.exec.chatMessage("<font size='8'>"..(string.sub(map.xml,i,i+splitnum-1)):gsub("<","&lt;").."</font>",player.name)
                        end
                    end
                end
            },
            admins={
                rank=RANKS.ANY,
                fnc=function(player)
                    local t={}
                    for n in pairs(players) do
                        if ranks[n] and ranks[n]>=RANKS.ROOM_ADMIN then
                            table.insert(t,n)
                        end
                    end
                    if #t>0 then
                        tfm.exec.chatMessage(table.concat(t,", "),player.name)
                    else
                        tfm.exec.chatMessage(translate("noadmins",player.lang),player.name)
                    end
                end
            },
            admin={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,...)
                    local arg={...}
                    if arg[1] then
                        executeCommand(player, function(a)
                            if players[a] and ranks[a] then
                                if ranks[a]<RANKS.ROOM_ADMIN then
                                    ranks[a]=RANKS.ROOM_ADMIN
                                    tfm.exec.chatMessagePublic("isnowadmin",players,a)
                                else
                                    tfm.exec.chatMessage(translate("hashigherrank",player.lang):format(a),player.name)
                                end
                            end
                        end, arg)
                    end
                end
            },
            unadmin={
                rank=RANKS.ROOM_OWNER,
                fnc=function(player,...)
                    local arg={...}
                    if arg[1] then
                        executeCommand(player, function(a)
                            if players[a] and ranks[a] then
                                if ranks[a]<ranks[player.name] and ranks[a]==RANKS.ROOM_ADMIN then
                                    ranks[a]=RANKS.ANY
                                    tfm.exec.chatMessagePublic("isnoadmin",players,a)
                                else
                                    tfm.exec.chatMessage(translate("hashigherrank",player.lang):format(a),player.name)
                                end
                            end
                        end, arg)
                    end
                end
            },
            deadmin={rank=RANKS.ROOM_OWNER,fnc=function(player,...) _S.global.callbacks.chatCommand.lock.fnc(player,...) end},
            lock={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,num)
                    num=tonumber(num) or (num and false)  or 1
                    if tonumber(num) and (num>=1 and num<=50) then
                        tfm.exec.setRoomMaxPlayers(num)
                        tfm.exec.chatMessagePublic("roomlimit",players,num)
                    else
                        tfm.exec.chatMessage(translate("invalidargument",player.lang),player.name)
                    end
                end
            },
            unlock={rank=RANKS.ROOM_ADMIN,fnc=function(player,...) _S.global.callbacks.chatCommand.lock.fnc(player,50) end},
            score={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,...)
                    local arg={...}
                    executeCommand(player, function(target, score)
                        tfm.exec.setPlayerScore(target, score)
                    end, arg)
                end
            },
            tp={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,...)
                    local arg={...}
                    local x,y
                    for k,v in pairs(arg) do
                        if tonumber(v) then
                            if not x then x=v elseif not y then y=v end
                        end
                    end
                    if not x and not y then
                        player.activeSegments.tp=true
                        player.tp={}
                        executeCommand(player, function(target)
                            table.insert(player.tp,target)
                        end, arg)
                    else
                        executeCommand(player, function(target,x,y)
                            tfm.exec.movePlayer(target, x, y)
                        end, arg)
                    end
                end
            },
            spawn={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,id,x,y,num,angle,vx,vy)
                    if id then
                        local o={}
                        id=tfm.enum.shamanObject[id] or id
                        num=tonumber(num) or 1
                        if num>15 then num=15 elseif num<0 then num=0 end
                        for i=1,num do
                            table.insert(o,tfm.exec.addShamanObject(id,tonumber(x) or tfm.get.room.playerList[player.name].x, tonumber(y) or tfm.get.room.playerList[player.name].y,tonumber(angle) or 0,tonumber(vx) or 0,tonumber(vy) or 0))
                        end
                        return o
                    else
                        tfm.exec.chatMessage(translate("enterobjectid",player.lang),player.name)
                    end
                end
            },
            addspawn={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,id,x,y,num,angle,vx,vy,interval,despawn)
                    if id then
                        id=tfm.enum.shamanObject[id] or id
                        num=tonumber(num) or 1
                        if num>10 then num=10 elseif num<0 then num=0 end
                        for i=1,num do
                            table.insert(_S.addspawn.toSpawn, {name=player.name, type=tonumber(id), x=tonumber(x) or 0, y=tonumber(y) or 0, ang=tonumber(ang) or 0,vx=tonumber(vx) or 0, vy=tonumber(vy) or 0, interval=tonumber(interval) or 6, tick=0, despawn=tonumber(despawn) or 120})
                        end
                    else
                        toggleSegment(player.name, "addspawn", not players[player.name].activeSegments.addspawn)
                    end
                end
            },
            clearspawns={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player)
                    _S.addspawn.toSpawn={}
                end
            },
            removespawns={rank=RANKS.ROOM_ADMIN,fnc=function(player,...) _S.global.callbacks.chatCommand.clearspawns.fnc(player,...) end},
            disco={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player)
                    _S.disco.disabled = not _S.disco.disabled
                    if _S.disco.disabled then
                        for n,p in pairs(tfm.get.room.playerList) do
                            tfm.exec.setNameColor(n,0)
                        end
                    end
                end
            },
            doge={
                rank=RANKS.ROOM_ADMIN,
                fnc=function()
                    _S.doge.disabled = not _S.doge.disabled 
                    if _S.doge.disabled then
                        ui.removeTextArea(-50)
                    end
                end
            },
            treelights={
                rank=RANKS.ROOM_ADMIN,
                fnc=function()
                    _S.treelights.disabled = not _S.treelights.disabled
                    if not _S.treelights.disabled then _S.treelights.callbacks.newGame() end
                end
            },
            ballExplosion={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player, ...)
                    args = {...}
                    if #args == 0 then
                        _S.ballExplosion.disabled = not _S.ballExplosion.disabled
                    end
                end
            },
            flames={
                rank=RANKS.ROOM_ADMIN,
                fnc=function()
                    _S.flames.disabled = not _S.flames.disabled
                    if not _S.flames.disabled then _S.flames.callbacks.newGame() end
                end
            },
            bubbles={
                rank=RANKS.ROOM_ADMIN,
                fnc=function()
                    _S.bubbles.disabled = not _S.bubbles.disabled
                    if not _S.bubbles.disabled then 
                        _S.bubbles.callbacks.newGame() 
                        _S.bubbles.shamanObjects = {}
                    else
                        for _, id in pairs(_S.bubbles.shamanObjects) do
                            tfm.exec.removeObject(id)
                        end
                    end
                end
            },
            rain={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,id)
                    _S.rain.ID=tonumber(id) or 40
                    _S.rain.disabled = not _S.rain.disabled
                end
            },
            fireworks={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,...)
                    local arg={...}
                    if #arg==0 then
                        _S.fireworks.disabled = not _S.fireworks.disabled
                        --if not _S.fireworks.disabled then _S.fireworks.setPositions() end
                    else
                        executeCommand(player, function(target)
                            toggleSegment(target,"fireworks",not players[target].activeSegments.fireworks)
                        end, arg)
                    end
                        
                end
            },
            explosion={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,...)
                    local arg={...}
                    executeCommand(player, function(target)
                        players[target].activeSegments.explosion=not players[target].activeSegments.explosion
                    end, arg)
                end
            },
            debug={
                rank=RANKS.ANY,
                fnc=function(player,...)
                    player.activeSegments.debug=not player.activeSegments.debug
                    if player.activeSegments.debug then
                        _S.debug.showMapInfo(player.name)
                    else
                        ui.removeTextArea(-18,player.name)
                    end
                end
            },
            mapinfo={rank=RANKS.ANY,fnc=function(player,...) _S.global.callbacks.chatCommand.debug.fnc(player) end},
        }
    },
    showMenu=function(name,hidden)
        local player=players[name]
        local menu={}

        if _S.global.menuCondition and _S.global.menuCondition(player) then
            table.insert(menu, _S.global.menu(player))
        end
        for k,s in pairs(_S) do
            if k~="global" and s.menuCondition and s.menuCondition(player) then
                table.insert(menu, s.menu(player))
            end
        end
        player.menu=menu

        local x=0
        local y=25
        local ta=1
        for _,section in ipairs(menu) do
            local titlex=x
            for i,item in ipairs(section) do
                local width=item.width or 20
                ui.addTextArea(ta,item.custom or "<p align='center'><a href='event:"..item.callback.."'>"..item.icon.."\n</a></p>",name,5+x,y,width,20,item.color,nil,0.5,true)
                table.insert(player.menu,{id=ta,callback=item.callback,icon=item.icon,color=item.color,x=x+5,y=y})
                x=x+width+10
                ta=ta+1
            end
            if section.title then
                ui.addTextArea(ta,"<p align='center'>"..section.title.."</p>",name,titlex,50,x-titlex,20,nil,nil,0,true)
                ta=ta+1
            end
            x=x+20
        end
        for i=ta,50 do
            ui.removeTextArea(i,name)
        end
    end
}
