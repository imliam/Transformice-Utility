_S.mapImage = {
    disabled=true,
    images={},
    layers={fg = "!", bg="?", gr="_"},
    callbacks={
        newGame=function()
            local layers = getValueFromXML(tfm.get.room.xmlMapInfo.xml, "IL") or false
            if layers then
                -- imgUrl,imgLayer,imgX,imgY;img...
                layers = string.split(layers, ";")
                _S.mapImage.images = {}
                for index, layerData in pairs(layers) do
                    table.insert(_S.mapImage.images, layerData)
                    layerData = string.split(layerData, ",")
                    local layerType = (_S.mapImage.layers[layerData[2]:sub(0,2)] or "")..(layerData[2]:sub(3) or "1")
                    tfm.exec.addImage(layerData[1] or "", layerType, layerData[3] or 0, layerData[4] or 0, nil)
                end
            end
        end,
        newPlayer=function(player)
            for index, layerData in pairs(_S.mapImage.images) do
                layerData = string.split(layerData, ",")
                local layerType = (_S.mapImage.layers[layerData[2]:sub(0,2)] or "")..(layerData[2]:sub(3) or "")
                tfm.exec.addImage(layerData[1] or "", layerType, layerData[3] or 0, layerData[4] or 0, player.name)
            end             
        end,
    },
}
