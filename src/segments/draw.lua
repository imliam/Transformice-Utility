-- Drawing segment

_S.draw = {
    redraw=true,
    _={
        minBrushSize=1,
        maxBrushSize=25
    },
    defaultPlayer=function(player)
        player.activeSegments.draw=false
        player.draw={
            tool="line",
            size=10,
            color=0xFFFFFF,
            pickerId=0,
            alpha=100,
            lastClick=nil,
            nextDraw=nil,
            history={},
            bezierPath=nil,
            foreground=true,
            enteringColor=nil
        }
    end,
    menu=function(player)
        return {
            --title="Drawing",
            {callback="draw tool line",icon="|",color=player.draw.tool=="line" and 0xCCCCCC or nil},
            --{callback="draw tool curve",icon="~",color=player.draw.tool=="curve" and 0xCCCCCC or nil},
            {callback="draw tool circle",icon="o",color=player.draw.tool=="circle" and 0xCCCCCC or nil},
            {callback="draw tool brush",icon="b",color=player.draw.tool=="brush" and 0xCCCCCC or nil},
            {callback="draw picker",icon=" ",color=player.draw.color or 0xFFFFFF},
            {callback="draw tool eraser",icon="e",color=player.draw.tool=="eraser" and 0xCCCCCC or nil},
            {callback="draw clear",icon="c"},
            {callback="draw undo",icon="u"},
            {custom="<p align='center'><a href='event:draw size -3'>-</a> "..player.draw.size.."px <a href='event:draw size 3'>+</a></p>",width=65},
            {custom="<p align='center'><a href='event:draw alpha -10'>-</a> "..player.draw.alpha.."% <a href='event:draw alpha 10'>+</a></p>",width=65},
            {custom="<p align='center'><a href='event:draw foreground'>"..(player.draw.foreground and "fg" or "bg").."</a></p>",width=30},
        }
    end,
    menuCondition=function(player) return player.activeSegments.draw end,
    colors={
        red={title="Red",color=0xFF0000},
        green={title="Green",color=0x00FF00},
        blue={title="Blue",color=0x0000FF},
        orange={title="Orange",color=0xFF6600},
        background={title="Background Blue",color=0x6A7495},
        brown={title="Brown",color=0x78583A},
        skin={title="Skin Yellow",color=0xE3C07E},
        white={title="White",color=0xFFFFFF},
        silver={title="Silver",color=0xC0C0C0},
        gray={title="Gray",color=0x808080},
        black={title="Black",color=0x000001},
        maroon={title="Maroon",color=0x800000},
        yellow={title="Yellow",color=0xFFFF00},
        olive={title="Olive",color=0x808000},
        lime={title="Lime",color=0x00FF00},
        green={title="Green",color=0x008000},
        aqua={title="Aqua",color=0x00FFFF},
        teal={title="Teal",color=0x008080},
        navy={title="Navy",color=0x000080},
        fuchsia={title="Fuchsia",color=0xFF00FF},
        purple={title="Purple",color=0x800080},
        pink={title="Pink",color=0xFF69B4}
    },
    onEnable=function(player,manual)
        if manual==nil then manual=false end
        local keys={KEYS.A, KEYS.B, KEYS.D, KEYS.E, KEYS.F}
        for i = 0, 9 do
            table.insert(keys, KEYS["NUMPAD "..i])
        end
        for _,key in ipairs(keys) do
            system.bindKeyboard(player.name,key,true,manual)
            system.bindKeyboard(player.name,key,false,manual)
        end
    end,
    addHexCharToColor=function(player,letter)
        table.insert(player.draw.enteringColor, letter)
        if #player.draw.enteringColor==6 then
            local c=table.concat(player.draw.enteringColor, '')
            c=getColor(c)
            if c then
                player.draw.color=c
--                  c=string.format("%06X",c)
--                  tfm.exec.chatMessage(translate("colorchanged",player.lang):format("[<font color='#"..c.."'>#"..(c:upper()).."</font>]"),player.name)
            end
            player.draw.enteringColor=nil
            _S.draw.onEnable(player,false)
        end
    end,
    callbacks={
        newGame=function()
            _S.draw.ids={}
            _S.draw.physicObject()
        end,
        newPlayer=function(player)
            _S.draw.physicObject()
            if _S.draw.redraw then
                --local tbl=_S.draw.ids
                --_S.draw.ids={}
                for _,joint in ipairs(_S.draw.ids) do
                    if not joint.removed then
                        _S.draw.addJoint(joint.id,joint.coords1,joint.coords2,joint.name,joint.line,joint.color,joint.alpha,joint.foreground)
                    end
                end
            end
        end,
        keyboard={
            [KEYS.Z]=function(player,down,x,y)
                if down and player.ctrl then
                    _S.draw.undo(player.name)
                end
            end,
            [KEYS.W]=function(player,down,x,y)
                _S.draw.callbacks.keyboard[KEYS.Z](player,down,x,y)
            end,
            [KEYS.C]=function(player,down,x,y)
                if ranks[player.name]>=RANKS.ROOM_ADMIN and down then
                    if player.shift then
                        player.draw.enteringColor={}
                        _S.draw.onEnable(player,true)
                    elseif player.draw.enteringColor then
                        _S.draw.addHexCharToColor(player,'C')
                    end
                end
            end,
            [KEYS.A]=hexColorEntering('A'),
            [KEYS.B]=hexColorEntering('B'),
            [KEYS.D]=hexColorEntering('D'),
            [KEYS.E]=hexColorEntering('E'),
            [KEYS.F]=hexColorEntering('F'),
            [KEYS['NUMPAD 0']]=hexColorEntering('0'),
            [KEYS['NUMPAD 1']]=hexColorEntering('1'),
            [KEYS['NUMPAD 2']]=hexColorEntering('2'),
            [KEYS['NUMPAD 3']]=hexColorEntering('3'),
            [KEYS['NUMPAD 4']]=hexColorEntering('4'),
            [KEYS['NUMPAD 5']]=hexColorEntering('5'),
            [KEYS['NUMPAD 6']]=hexColorEntering('6'),
            [KEYS['NUMPAD 7']]=hexColorEntering('7'),
            [KEYS['NUMPAD 8']]=hexColorEntering('8'),
            [KEYS['NUMPAD 9']]=hexColorEntering('9')
        },
        mouse={
            pr=3,
            fnc=function(player,x,y)
                if player.activeSegments.draw and not player.omo then
                    if player.draw.nextDraw or (player.shift and player.draw.lastClick) then
                        _S.draw.tool[player.draw.tool](player.draw.lastClick,{x=x,y=y},player.name)
                    else
                        player.draw.nextDraw=true
                    end
                    player.draw.lastClick={x=x,y=y}
                end
            end
        },
        chatCommand={
            color={
                rank=RANKS.ANY,
                fnc=function(player,color,target)
                    target=target and upper(target) or player.name
                    if color then
                        local c=getColor(color)
                        if c then
                            players[target].draw.color=c
                            c=string.format("%06X",c)
                            tfm.exec.chatMessage(translate("colorchanged",player.lang):format("[<font color='#"..c.."'>#"..(c:upper()).."</font>]"),player.name)
                        else
                            tfm.exec.chatMessage(translate("invalidargument",player.lang),player.name)
                        end
                    else
                        _S.draw.callbacks.textArea.picker(1,player.name)
                    end
                end
            },
            brush={
                rank=RANKS.ANY,
                fnc=function(player,size,target)
                    target=target and upper(target) or player.name
                    size=tonumber(size) or 10
                    players[target].draw.size=math.max(_S.draw._.minBrushSize,math.min(_S.draw._.maxBrushSize,size))
                    _S.global.showMenu(target)
                    tfm.exec.chatMessage(translate("brushchanged",player.lang):format(size),player.name)
                end
            },
            clear={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,target)
                    target=target and upper(target) or player.name
                    if target=="All" or target=="*" then target=nil end
                    _S.draw.clear(target)
                end
            },
            jointxml={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player)
                    local str=""
                    for _,joint in pairs(_S.draw.ids) do
                        if not joint.removed then
                            local j=[[&lt;JD P1="%s"P2="%s"c="%s,%s,1,0"/&gt;]]
                            str=str..(j:format(
                                joint.coords1.x..","..joint.coords1.y,
                                joint.coords2.x..","..joint.coords2.y,
                                string.format("%X",joint.color),
                                joint.line)
                            )
                        end
                    end
                    local splitnum=800
                    for i=1,#str,splitnum do
                        tfm.exec.chatMessage("<font size='8'>"..string.sub(str,i,i+splitnum-1).."</font>",player.name)
                    end
                end
            },
        },
        textArea={
            tool=function(id,name,arg)
                local t = arg[3]
                if t and _S.draw.tool[t] then
                    local player=players[name]
                    player.draw.tool=t
                    _S.global.showMenu(name)
                    player.draw.lastClick=nil
                    player.draw.nextDraw=nil
                    if t=="brush" or t=="eraser" then
                        player.draw.nextDraw=true
                    end
                end
            end,
            clear=function(id,name,arg)
                _S.draw.clear(name)
            end,
            undo=function(id,name,arg)
                _S.draw.undo(name)
            end,
            size=function(id,name,arg)
                local player=players[name]
                local size=player.draw.size
                size=math.max(_S.draw._.minBrushSize,math.min(_S.draw._.maxBrushSize,size+(arg[3] or 1)))
                player.draw.size=size
                _S.global.showMenu(name)
            end,
            alpha=function(id,name,arg)
                local player=players[name]
                local alpha=player.draw.alpha
                alpha=math.min(100,math.max(10,alpha+(arg[3] or 0)))
                player.draw.alpha=tonumber(alpha)
                _S.global.showMenu(name)
            end,
            foreground=function(id,name,arg)
                local player=players[name]
                player.draw.foreground=not player.draw.foreground
                _S.global.showMenu(name)
            end,
            color=function(id,name,arg)
                local player=players[name]
                local color = tonumber(arg[3]) or 1
                player.draw.color=color
                _S.global.showMenu(name)
            end,
            picker=function(id,name,arg)
                --[[
                local i=0
                for k,c in pairs(_S.draw.colors) do
                    ui.addTextArea(600+i,"<a href='event:draw colorpicker "..c.color.."'>"..c.title or c.color.."</a>",name,150,60+(i*24),100,18,c.color,0x212F36,1,true)
                    i=i+1
                end
                ]]
                local player=players[name]
                local id=player.draw.pickerId+1
                player.draw.pickerId=id
                ui.showColorPicker(id, name, player.draw.color, translate("pickacolor",players[name].lang))
            end,
            colorpicker=function(id,name,arg)
                ui.showColorPicker(id, name, arg[3], translate("pickacolor",players[name].lang))
            end
        },
        colorPicked=function(player,id,color)
            if color==0 then color=1 end
            if color==-1 then
                --[[
                for i=600,620 do
                    ui.removeTextArea(i,player.name)
                end
                ]]
            elseif id==player.draw.pickerId then
                player.draw.color=color
                _S.global.showMenu(player.name)
            end
        end
    },
    ids={},
    physicObject=function()
        tfm.exec.addPhysicObject(1,400,-600,{type=13,width=10,height=10,foreground=true,friction=0.3,restitution=0,dynamic=false,miceCollision=false,groundCollision=false})
    end,
    addJoint=function(id,coords1,coords2,name,size,color,alpha,foreground)
        id=id or #_S.draw.ids+1
        local tbl={
            id=id,
            coords={x=(coords1.x+coords2.x)/2,y=(coords1.y+coords2.y)/2},
            coords1=coords1,
            coords2=coords2,
            point1=coords1.x..","..coords1.y,
            point2=coords2.x..","..coords2.y,
            name=name,
            line=size or 10,
            color=color or 0xFFFFFF,
            alpha=alpha or 1,
            frequency=10,
            type=0,
            damping=0.2,
            foreground=foreground
        }
        tfm.exec.addJoint(id,1,1,tbl)
        _S.draw.ids[id]=tbl
        return id
    end,
    readdJoint=function(index,update)
        local joint=_S.draw.ids[index]
        if joint then
            joint.removed=false
            tfm.exec.addJoint(joint.id,1,1,joint)
            if update then _S.draw.blankJoint() end
        end
    end,
    removeJointByIndex=function(index,update)
        local joint=_S.draw.ids[index]
        if joint then
            tfm.exec.removeJoint(joint.id)
            joint.removed=true
            if update then _S.draw.blankJoint() end
        end
    end,
    removeJoint=function(id)
        for _,joint in ipairs(_S.draw.ids) do
            if joint.id==id then
                tfm.exec.removeJoint(id)
                joint.removed=true
            end
        end
        _S.draw.blankJoint()
    end,
    blankJoint=function()
        tfm.exec.addJoint(0,1,1,{
            type=0,
            point1="0,0",
            point2="0,1",
            frequency=10,
            damping=0.2,
            line=1,
            color=0xFFFFFF,
            alpha=0,
            foreground=false
        })
    end,
    clear=function(name)
        local action={}
        for _,joint in ipairs(_S.draw.ids) do
            if (name and joint.name==name or not name) and not joint.removed then
                table.insert(action,joint.id)
                tfm.exec.removeJoint(joint.id)
                joint.removed=true
            end
        end
        if not name then -- !clear all : not undoable (this is to clear memory mainly if the room is getting laggy)
            _S.draw.ids={}
            for _,p in pairs(players) do
                p.draw.history={}
            end
        elseif players[name] then
            _S.draw.addHistoryAction(name,false,action)
        end
        _S.draw.blankJoint()
    end,
    undo=function(name)
        local player=players[name]
        local hist=player.draw.history
        local i=#hist

        if i>0 then
            local action=table.remove(hist,i)
            local additive=action.additive
            local lastJointIndex=nil

            for _,v in ipairs(action) do
                if type(v)=='number' then
                    if additive then -- the action added new joints, so we will remove them
                        _S.draw.removeJointByIndex(v)
                    else -- the action removed joints, so we will re-add them
                        _S.draw.readdJoint(v)
                        lastJointIndex=v
                    end
                else
                    for _,w in ipairs(v) do
                        if additive then -- the action added new joints, so we will remove them
                            _S.draw.removeJointByIndex(w)
                        else -- the action removed joints, so we will re-add them
                            _S.draw.readdJoint(w)
                            lastJointIndex=w
                        end
                    end
                end
            end
            if additive and #hist>0 then
                -- Get coords from last join of action before this one
                action=hist[#hist]
                lastJointIndex=action[#action]
                if type(lastJointIndex)=='table' then
                    lastJointIndex=lastJointIndex[#lastJointIndex]
                end
            end
            if lastJointIndex then
                -- Set lastClick based on coords of lastJointIndex
                local joint=_S.draw.ids[lastJointIndex]
                if joint then
                    player.draw.lastClick=joint.coords2
                end
            end
            _S.draw.blankJoint()
        end
    end,
    addHistoryAction=function(name,additive,...)
        local player=players[name]
        local arg={...}
        arg.additive=additive
        table.insert(player.draw.history,arg)
    end,
    tool={
        line=function(coords1,coords2,name)
            local player=players[name]
            local action=_S.draw.addJoint(nil,coords1,coords2,name,player.draw.size,player.draw.color,player.draw.alpha/100,player.draw.foreground)
            _S.draw.addHistoryAction(name,true,action)
            if name then
                player.draw.nextDraw=nil
            end
        end,
        brush=function(coords1,coords2,name)
            local player=players[name]
            local action=_S.draw.addJoint(nil,coords2,{x=coords2.x,y=coords2.y+1},name,player.draw.size,player.draw.color,player.draw.alpha/100,player.draw.foreground)
            _S.draw.addHistoryAction(name,true,action)
        end,
        circle=function(coords1,coords2,name)
            local player=players[name]
            local action=_S.draw.addJoint(nil,coords1,{x=coords1.x,y=coords1.y+1},name,distance(coords1.x,coords1.y,coords2.x,coords2.y)*2,player.draw.color,player.draw.alpha/100,player.draw.foreground)
            _S.draw.addHistoryAction(name,true,action)
            if name then
                player.draw.nextDraw=nil
            end
        end,
        eraser=function(coords1,coords2,name)
            local dist=10
            local action={}
            for i,joint in pairs(_S.draw.ids) do
                if name and joint.name==name or not name then
                    -- TODO: separate distance function for each shape (line, dot, circle, curve)
                    if pythag(coords2.x,coords2.y,joint.coords.x,joint.coords.y,dist) then
                        table.insert(action,i)
                        tfm.exec.removeJoint(joint.id)
                        joint.removed=true
                    end
                end
            end
--              _S.draw.addHistoryAction(name,false,action)
            _S.draw.blankJoint()
        end,
        curve=function(coords1,coords2,name)
            -- TODO: should convert all {x, y} tables in this file to Vector(x, y)
--[[                local player=players[name]
            local bp = player.draw.bezierPath
            if coords1 then coords1 = Vector(coords1.x, coords1.y) end
            if coords2 then coords2 = Vector(coords2.x, coords2.y) end
            if not bp then
                bp = BezierPath()
                bp:add(coords1)
                bp:add(coords2)
                player.draw.bezierPath = bp
            elseif bp:size() >= 2 then
                bp:add(coords2)
                local action = {}
                local tesPoints = bp:draw()
                for i = 2, #tesPoints - 1 do
                    local p1, p2 = tesPoints[i - 1]:floored(), tesPoints[i]:floored()
                    table.insert(action, _S.draw.addJoint(nil,p1,p2,name,player.draw.size,player.draw.color,player.draw.alpha/100,player.draw.foreground))
                end
                _S.draw.addHistoryAction(name,true,action)
            end]]
        end
    }
}