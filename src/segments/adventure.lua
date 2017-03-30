_S.adventure = {
    disabled=true,
    id=0,
    players={},
    callbacks={
        newGame=function()
            local adventureId = getValueFromXML(tfm.get.room.xmlMapInfo.xml, "advId") or 1
            ui.setMapName(string.format("<J>Transformice<BL> - @200%s", (adventureId-1 or 1)))
            _S.adventure.id = adventureId
            if adventureId == 2 then
                local fromagnus = tfm.exec.addShamanObject(6300, 1780, 300)
                tfm.exec.addImage("15265a4df9d.png", "#"..fromagnus, -15, -50, nil)
            elseif adventureId == 3 then
                for player, data in pairs(tfm.get.room.playerList) do
                    _S.adventure.players[player] = {up = false}
                end
            elseif adventureId == 4 then
                local colors = {0xFB4047, 0xFE9926, 0xE7E433, 0xB9E52A, 0x89EAF9, 0x2E8BD8, 0x8E3F97}
                local id = math.random(#colors)
                local color1 = colors[id]
                table.remove(colors, id)
                id = math.random(#colors)
                local color2 = colors[id]
                local playerLen = table.getl(tfm.get.room.playerList)
                local count = 0
                for player, data in pairs(tfm.get.room.playerList) do
                    count = count+1
                    if count < playerLen then
                        tfm.exec.setNameColor(player, color1)
                    else
                        tfm.exec.setNameColor(player, color2)
                        tfm.exec.movePlayer(player, 5340, 0, false, 0, 0, false)
                    end
                end
            end
        end,
        eventLoop = function()
            if _S.adventure.id == 3 then
                for player, data in pairs(tfm.get.room.playerList) do
                    if _S.adventure.players[player] then
                        if _S.adventure.players[player].up then
                            tfm.exec.movePlayer(player, 0, 0, false, 0, -5, false)
                        else
                            tfm.exec.movePlayer(player, 0, 0, false, 0, 5, false)
                        end
                        _S.adventure.players[player].up = not _S.adventure.players[player].up
                    end
                end
            end
        end
    },
}