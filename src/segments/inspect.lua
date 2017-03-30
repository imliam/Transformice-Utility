_S.inspect = {
    defaultPlayer=function(player)
        player.activeSegments.inspect=true
    end,
    callbacks={
        newGame=function()
            ui.removeTextArea(-20)
        end,
        mouse={
            pr=1,
            fnc=function(player,x,y)
                if player.shift and not player.activeSegments.draw then
                    local theta,c,s,cx,cy
                    for i=#map.grounds,1,-1 do
                        local ground=map.grounds[i]
                        theta=math.rad(ground.rotation or 0)
                        c,s=math.cos(-theta),math.sin(-theta)
                        cx=ground.x+c*(x-ground.x)-s*(y-ground.y)
                        cy=ground.y+s*(x-ground.x)+c*(y-ground.y)
                        if (ground.type==13 and pythag(x,y,ground.x,ground.y,ground.length/2)) or (math.abs(cx-ground.x)<ground.length/2 and math.abs(cy-ground.y)<ground.height/2) then
                            local str=""
                            local properties={"type","id","x","y","height","length","friction","restitution","rotation","dynamic","mass","color"}
                            for _,property in ipairs(properties) do
                                if ground[property] then
                                    str=str.."<N>"..translate(property,player.lang)..": <VP>"..(
                                        (property=="color" and "<font color='#"..ground[property].."'>#"..(ground[property]).."</font>") or
                                        (property=="dynamic" and (ground["dynamic"]==0 and "False" or "True")) or
                                        (property=="type" and translate("groundList",player.lang)[ground[property]]) or
                                        (ground[property])
                                    ).."\n"
                                end
                            end
                            local w,h=map.length or 800,map.height or 400
                            ui.addTextArea(-20,"<font size='12'>"..str.."</font>",player.name,(x+150<=w and x) or (x<0 and 0) or (w-150),(y+180<=h and y>20 and y) or (y<20 and 25) or (h-180),nil,nil,nil,nil,0.5,false)
                            return
                        end
                    end
                end
                ui.removeTextArea(-20,player.name)
            end
        },
    }
}