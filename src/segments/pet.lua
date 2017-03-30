_S.pet = {
    pets={},
    defaultPlayer=function(player)
        player.activeSegments.pet=true
    end,
    callbacks={
        newGame=function()
            for name,pet in pairs(_S.pet.pets) do
                pet.id=tfm.exec.addShamanObject(6300,map.spawns[1] and map.spawns[1].x or 400,map.spawns[1] and map.spawns[1].y or 200,0,0,false)
                pet.farAway=0
                _S.pet.showImage(pet,"right")
            end
        end,
        eventLoop=function(time,remaining)
            for name,pet in pairs(_S.pet.pets) do
                if tfm.get.room.objectList[pet.id] and pet.stay > 0 and tfm.get.room.playerList[name] then
                    local x = 0
                    local y = 0
                    if pet.stay == 1 then
                        x=-(tfm.get.room.objectList[pet.id].x-tfm.get.room.playerList[name].x)
                        y=-(tfm.get.room.objectList[pet.id].y-tfm.get.room.playerList[name].y)
                    
                    elseif pet.stay == 2 then
                        if math.random(10) < 5 then
                            if math.random(10) < 2 then
                                x=-(tfm.get.room.objectList[pet.id].x-math.random(800))
                            else
                                x=(tfm.get.room.objectList[pet.id].x-math.random(800))
                            end
                            y=(tfm.get.room.objectList[pet.id].y-math.random(400))
                        else
                            if math.random(5) < 2 then
                                if _S.images.sprites[pet.sprite.category][pet.sprite.id].petaction then
                                    _S.images.sprites[pet.sprite.category][pet.sprite.id].petaction(pet)
                                end
                            else
                                if math.random(0, 1) == 1 then
                                    x=-(tfm.get.room.objectList[pet.id].x-math.random(-50, 50))
                                else
                                    x=(tfm.get.room.objectList[pet.id].x-math.random(-50, 50))
                                end                                 
                            end
                        end
                    elseif pet.stay == 3 then
                        if tfm.get.room.objectList[pet.treat] then
                            x=-(tfm.get.room.objectList[pet.id].x-tfm.get.room.objectList[pet.treat].x)
                            y=-(tfm.get.room.objectList[pet.id].y-tfm.get.room.objectList[pet.treat].y)
                            if pythag(tfm.get.room.objectList[pet.id].x, tfm.get.room.objectList[pet.id].y, tfm.get.room.objectList[pet.treat].x, tfm.get.room.objectList[pet.treat].y, 60) then
                                pet.ttick = pet.ttick+1
                                tfm.exec.displayParticle(30, tfm.get.room.objectList[pet.treat].x, tfm.get.room.objectList[pet.treat].y, 0, -1, 0, 0)
                                if pet.ttick == 20 then
                                    for i = 0, 10 do
                                        tfm.exec.displayParticle(5, tfm.get.room.objectList[pet.treat].x, tfm.get.room.objectList[pet.treat].y, math.cos(i), math.sin(i), 0, 0)
                                    end
                                    tfm.exec.removeObject(pet.treat)
                                    pet.treat=false
                                    pet.stay=2
                                end
                            end
                        else
                            pet.treat=false
                            pet.stay=2
                        end
                    elseif pet.stay == 4 then
                        if tfm.get.room.objectList[pet.ball] then
                            x=-(tfm.get.room.objectList[pet.id].x-tfm.get.room.objectList[pet.ball].x)
                            y=-(tfm.get.room.objectList[pet.id].y-tfm.get.room.objectList[pet.ball].y)  
                            if pythag(tfm.get.room.objectList[pet.id].x, tfm.get.room.objectList[pet.id].y, tfm.get.room.objectList[pet.ball].x, tfm.get.room.objectList[pet.ball].y, 20) then
                                bx=(tfm.get.room.objectList[pet.ball].x-tfm.get.room.objectList[pet.id].x)
                                by=(tfm.get.room.objectList[pet.ball].y-tfm.get.room.objectList[pet.id].y)  
                                tfm.exec.moveObject(pet.ball, 0, 0, false, bx, by, true)
                            end 
                        else
                            pet.treat=false
                            pet.stay=2
                        end
                    end
                    if (math.abs(x)>300 or math.abs(y)>300) then
                        pet.farAway=pet.farAway+1
                        if pet.farAway==16 then
                            if pet.stay ~= 2 then
                                tfm.exec.moveObject(pet.id,tfm.get.room.playerList[name].x,tfm.get.room.playerList[name].y,false,0,0)
                                for i = 0, 5 do
                                    tfm.exec.displayParticle(9, tfm.get.room.playerList[name].x, tfm.get.room.playerList[name].y, math.cos(i), math.sin(i), 0, 0)
                                end
                            end
                            pet.farAway=0
                        end
                    end
                    local maxpower=30
                    local highest=0
                    if math.abs(x)>math.abs(y) then highest=math.abs(x) else highest=math.abs(y) end
                    local multiplier=highest/maxpower
                    if x==0 then x=1 end if y==0 then y=1 end
                    --if (tfm.get.room.objectList[pet.id].x or 0 >(map.length or 800)-100 and x>0) or (tfm.get.room.objectList[pet.id].x or 0 <100 and x<0) then x=x*-1 end
                    
                    if pet.stay==1 then
                        tfm.exec.moveObject(pet.id,0,0,false,math.abs(x)<120 and 1 or (x/multiplier),(y/multiplier)+(math.abs(x)>120 and -40 or 1),false)
                    elseif pet.stay==2 then
                        tfm.exec.moveObject(pet.id,0,0,false,math.abs(x)<70 and 1 or (x/multiplier),(y/multiplier)+(math.abs(x)>120 and -40 or 1),false)
                    elseif pet.stay==3 then
                        tfm.exec.moveObject(pet.id,0,0,false,math.abs(x)<70 and 1 or (x/multiplier),(y/multiplier)+(math.abs(x)>120 and -40 or 1),false)
                    elseif pet.stay==4 then
                        tfm.exec.moveObject(pet.id,0,0,false,math.abs(x)<90 and 1 or (x/multiplier),(y/multiplier)+(math.abs(x)>120 and -40 or 1),false)
                    end
                    local direction=x<0 and "left" or "right"
                    if pet.direction~=direction then
                        pet.direction=direction
                        _S.pet.showImage(pet,direction)
                    end
                    
                end
            end
        end,
        playerLeft=function(player)
            if _S.pet.pets[player.name] then
                tfm.exec.removeObject(_S.pet.pets[player.name].id)
                _S.pet.pets[player.name]=nil
            end
        end,
        chatCommand={
            pet={
                rank=RANKS.ROOM_ADMIN,
                fnc=function(player,...)
                    local arg={...}
                    if arg[1]=="here" and _S.pet.pets[player.name] then
                        tfm.exec.moveObject(_S.pet.pets[player.name].id,tfm.get.room.playerList[player.name].x,tfm.get.room.playerList[player.name].y)
                    elseif arg[1]=="spawn" and not _S.pet.pets[player.name] then
                        local category="main"
                        local id="pusheen"
                        if arg[2] then
                            for cat,tbl in pairs(_S.images.sprites) do
                                if tbl[arg[2]:lower()] then
                                    category=cat
                                    id=arg[2]:lower()
                                    break
                                end
                            end
                        end
                        _S.pet.pets[player.name]={
                            name=player.name,
                            id=tfm.exec.addShamanObject(6300,tfm.get.room.playerList[player.name].x,tfm.get.room.playerList[player.name].y,0,0,0,false),
                            direction="right",
                            sprite={
                                category=category,
                                id=id
                            },
                            farAway=0,
                            stay = 1,
                            treat = false,
                            ttick = 0,
                            ball = false
                        }
                        _S.pet.showImage(_S.pet.pets[player.name],"right")
                        for i = 0, 10 do
                            tfm.exec.displayParticle(9, tfm.get.room.playerList[player.name].x, tfm.get.room.playerList[player.name].y, math.cos(i), math.sin(i), 0, 0)
                        end
                    elseif arg[1]=="despawn" and _S.pet.pets[player.name] then
                        tfm.exec.removeObject(_S.pet.pets[player.name].id)
                        if _S.pet.pets[player.name].ball then
                            tfm.exec.removeObject(_S.pet.pets[player.name].ball)
                        end
                        if _S.pet.pets[player.name].treat then
                            tfm.exec.removeObject(_S.pet.pets[player.name].treat)
                        end
                        _S.pet.pets[player.name]=nil
                    end
                    if _S.pet.pets[player.name] then
                        if not _S.pet.pets[player.name].treat then
                            if arg[1]=="stay" and _S.pet.pets[player.name]  then
                                _S.pet.pets[player.name].stay=0
                            elseif arg[1]=="follow" and _S.pet.pets[player.name] then
                                _S.pet.pets[player.name].stay=1
                            elseif arg[1]=="free" and _S.pet.pets[player.name] then
                                _S.pet.pets[player.name].stay=2
                            elseif arg[1]=="ball" and _S.pet.pets[player.name] then
                                if arg[2]=="here" then
                                    pos = tfm.get.room.playerList[player.name]
                                    tfm.exec.moveObject(_S.pet.pets[player.name].ball, pos.x, pos.y-40, false, 0, 0, false)
                                elseif arg[2]=="set" then
                                    _S.pet.pets[player.name].ball=tonumber(arg[3]) or _S.pet.pets[player.name].ball
                                    _S.pet.pets[player.name].stay=4
                                elseif arg[2]=="id" then
                                    tfm.exec.chatMessage(_S.pet.pets[player.name].ball, player.name)
                                else
                                    if _S.pet.pets[player.name].ball then
                                        tfm.exec.removeObject(_S.pet.pets[player.name].ball)
                                        _S.pet.pets[player.name].ball=false
                                    end
                                    pos = tfm.get.room.playerList[player.name]
                                    _S.pet.pets[player.name].ball = tfm.exec.addShamanObject(6, pos.x, pos.y-40, 0, 0, 0)
                                    tfm.exec.addImage("1515419b6f5.png", "#".._S.pet.pets[player.name].ball, -15, -15, nil)
                                    _S.pet.pets[player.name].stay=4
                                    tfm.exec.addPhysicObject(1, 0, map.height/2, {height = map.height*2, miceCollision = false, type = 12})
                                    tfm.exec.addPhysicObject(2, map.length, map.height/2, {height = map.height*2, miceCollision = false, type = 12})
                                end
                            end
                        else
                            tfm.exec.chatMessage(translate("peteating",player.lang), player.name)
                        end
                    end
                    if arg[1]=="treat" and _S.pet.pets[player.name] then
                        if _S.pet.pets[player.name].treat then
                            tfm.exec.removeObject(_S.pet.pets[player.name].treat)
                            _S.pet.pets[player.name].treat=false
                        else
                            pos = tfm.get.room.playerList[player.name]
                            _S.pet.pets[player.name].treat = tfm.exec.addShamanObject(1, pos.x, pos.y, 0, 0, 0)
                            tfm.exec.addImage("1514f246497.png", "#".._S.pet.pets[player.name].treat, -15, -15, nil)
                            _S.pet.pets[player.name].stay=3
                            _S.pet.pets[player.name].ttick=0
                        end
                    end
                end
            }
        }
    },
    showImage=function(pet,direction)
        if pet.sprite.img then tfm.exec.removeImage(pet.sprite.img) end
        local directory=_S.images.sprites[pet.sprite.category][pet.sprite.id][direction] or _S.images.sprites[pet.sprite.category][pet.sprite.id]
        local dirroot=_S.images.sprites[pet.sprite.category][pet.sprite.id]
        pet.sprite.img=tfm.exec.addImage(directory.img..".png","#"..pet.id,directory.x or dirroot.x or -50,4+(directory.y or dirroot.y or -50))
    end,
}