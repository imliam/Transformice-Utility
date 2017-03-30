_S.movecheese = {
    disabled=true,
    cheesePositions={X={},Y={}},
    currentIndex=1,
    currentPos={-500, -500},
    loop=false,
    order=0,
    delay=1000,
    lastMove=os.time(),
    image=-1,
    --[[ TAGS:
        segments="movecheese" - enable the cheese movement
        CheeseX="x1,x2,x3" - horizontal coordinates for the cheese,
        CheeseY="y1,y2,y3" - vertical coordinates for the cheese
        FirstCoord="x,y" - sets the first coordinate for the cheese
        in both you can use:
            fixed - to make the cheese stay in the last location
            random - to make the coordinate be random
        Loop="0 or 1" - enables the move loop(0 false, 1 true)
        Delay="seconds" - the change delay, in seconds
        Order="type" - sets how the cheese should move:
            0 - following the xml order
            1 - when a player gets the cheese
            2 - random coordinate movement, given by the xml
            3 - when a player gets close to the cheese
    ]]--
    callbacks={
        newGame=function()
            local canLoop=getValueFromXML(tfm.get.room.xmlMapInfo.xml, "Loop") or 1
            local moveDelay=getValueFromXML(tfm.get.room.xmlMapInfo.xml, "Delay") or 1000
            local moveOrder=getValueFromXML(tfm.get.room.xmlMapInfo.xml, "Order") or 0
            local vX = getValueFromXML(tfm.get.room.xmlMapInfo.xml, "CheeseX") or "400"
            local vY= getValueFromXML(tfm.get.room.xmlMapInfo.xml, "CheeseY") or "200"
            local firstCoord = string.split(getValueFromXML(tfm.get.room.xmlMapInfo.xml, "FirstCoord") or "", ",")
            _S.movecheese.cheesePositions.X=string.split(vX, ",")
            _S.movecheese.cheesePositions.Y=string.split(vY, ",")
            _S.movecheese.loop=canLoop == 1
            _S.movecheese.order=tonumber(moveOrder) or 0
            _S.movecheese.delay=tonumber(moveDelay) or 1000
            _S.movecheese.lastMove = os.time()
            _S.movecheese.callbacks.moveCheese(table.unpack(firstCoord))
        end,
        eventLoop=function(time,remain)
            time = math.ceil(time/1000)
            local X = 0
            local Y = 0
            if time > 1 then
                    if _S.movecheese.currentIndex <= #_S.movecheese.cheesePositions.X or _S.movecheese.currentIndex <= #_S.movecheese.cheesePositions.Y then
                        if _S.movecheese.lastMove < os.time()-_S.movecheese.delay then
                            if _S.movecheese.order == 0 then
                                _S.movecheese.callbacks.moveCheese()
                            elseif _S.movecheese.order == 2 then
                                _S.movecheese.currentIndex = math.random(math.max(#_S.movecheese.cheesePositions.X, #_S.movecheese.cheesePositions.Y))
                                _S.movecheese.callbacks.moveCheese()
                            end
                        end
                    else
                        if _S.movecheese.loop then
                            _S.movecheese.currentIndex = 1
                        end
                    end
                for player, data in pairs(tfm.get.room.playerList) do
                    if not data.hasCheese then
                        if pythag(_S.movecheese.currentPos[1], _S.movecheese.currentPos[2], data.x, data.y, 25) then
                            tfm.exec.giveCheese(player)
                            if _S.movecheese.order == 1 then    
                                _S.movecheese.callbacks.moveCheese()
                            end
                        end
                        if _S.movecheese.order == 3 then
                            if pythag(_S.movecheese.currentPos[1], _S.movecheese.currentPos[2], data.x, data.y, 50) then
                                _S.movecheese.callbacks.moveCheese()
                            end
                        end
                    end
                end
            end
        end,
        moveCheese=function(givenX, givenY)
            _S.movecheese.lastMove = os.time()
            local i = _S.movecheese.currentIndex
            local X = givenX or _S.movecheese.cheesePositions.X[i] or _S.movecheese.cheesePositions.X[i-1]
            local Y = givenY or _S.movecheese.cheesePositions.Y[i] or _S.movecheese.cheesePositions.Y[i-1]
            if X == "fixed" then
                X = _S.movecheese.currentPos[1] or 0
            end
            if Y == "fixed" then
                Y = _S.movecheese.currentPos[2] or 0
            end 
            if X == "random" then
                X = math.random(50, map.length-50)
            end
            if Y == "random" then
                Y = math.random(50, map.height-50)
            end 
            tfm.exec.removeImage(_S.movecheese.image)
            X = tonumber(X) or 0
            Y = tonumber(Y) or 0
            _S.movecheese.image = tfm.exec.addImage("1507b11c813.png", "!100", (X)-23, (Y)-19, nil)
            _S.movecheese.currentPos = {X, Y}
            if not givenX then
                _S.movecheese.currentIndex = _S.movecheese.currentIndex+1
            end
        end,
    },
}