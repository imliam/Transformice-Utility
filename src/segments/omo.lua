_S.omo = {
    defaultPlayer=function(player)
        player.activeSegments.omo=true
    end,
    welcomed={},
    startID=100,
    emotes={"omo","@_@","@@","è_é","e_e","#_#",";A;","owo","(Y)(omo)(Y)","©_©","OmO","0m0","°m°","(´°?°`)","~(-_-)~","{^-^}"},
    display=function(name,str,x,y,size,border,fixed)
        local i=_S.omo.startID
        size=size or 32
        for xoff=-1,1 do
            for yoff=-1,1 do
                i=i+1
                if not (xoff==0 and yoff==0) then
                    ui.addTextArea(i,"<p align='center'><b><font size='"..size.."' color='#000000' face='Soopafresh,Segoe,Verdana'>"..str.."</font></b></p>",name,x+(xoff*(border or 1))-250,y+(yoff*(border or 1))-50,500,nil,nil,nil,0,fixed)
                end
            end
        end
        ui.addTextArea(i+1,"<p align='center'><b><font size='"..size.."' face='Soopafresh,Segoe,Verdana'>"..str.."</font></b></p>",name,x-250,y-50,500,nil,nil,nil,0,fixed)
        if not name then _S.omo.welcomed={} end
    end,
    callbacks={
        newGame=function()
            for name,player in pairs(players) do
                if _S.omo and (not _S.omo.welcomed[name] or _S.omo.welcomed[name]<os.time()-3000) then
                    _S.omo.welcomed[name]=nil
                    local id=_S.omo.startID
                    for i=1,10 do
                        ui.removeTextArea(id+i,name)
                    end
                end
            end
        end,
        newPlayer=function(player)
            _S.omo.welcomed[player.name]=os.time()
            _S.omo.display(player.name,moduleName,400,200,100,3,true)
        end,
        mouse={
            pr=1,
            fnc=function(player,x,y)
                if player.omo then
                    local str=player.omo.str or _S.omo.emotes[math.random(#_S.omo.emotes)]
                    _S.omo.display(nil,str,x,y,player.omo.size or 64,3)
                    if player.omo.str then player.omo=nil end
                    return true
                end
            end
        },
        eventLoop=function(time,remaining)
            for name,time in pairs(_S.omo.welcomed) do
                if time<os.time()-10000 then
                    _S.omo.welcomed[name]=nil
                    for i=1,10 do
                        ui.removeTextArea(_S.omo.startID+i,name)
                    end
                    break
                end
            end
        end,
        chatCommand={
            omo={
                rank=RANKS.ROOM_ADMIN,
                hide=true,
                fnc=function(player,...)
                    local arg={...}
                    local size
                    for k,v in ipairs(arg) do
                        if v:match("%[size=(%d+)]") then
                            size=v:match("%[size=(%d+)]")
                            table.remove(arg,k)
                        elseif v=="[br]" then
                            arg[k]="\n"
                        end 
                    end
                    activateSegment(player.name,"omo")
                    player.omo={str=#arg>0 and table.concat(arg," "),size=size}
                end
            },
            clear={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player)
                    local id=_S.omo.startID
                    for i=1,10 do
                        ui.removeTextArea(id+i)
                    end
                end
            }
        }
    }
}