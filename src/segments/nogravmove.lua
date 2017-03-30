_S.nogravmove = {
    disabled=true,
    callbacks={
        newGame=function()
            local attachImage = getValueFromXML(tfm.get.room.xmlMapInfo.xml, "spriteImage") or "broom"
            for name,player in pairs(players) do
                _S.images.selectImage(player,attachImage)
            end
        end,
        roundEnd=function()
            for name,player in pairs(players) do
                player.sprite=nil
            end
        end,
        keyboard={
            [KEYS.UP]=function(player,down,x,y)
                if down then
                    tfm.exec.movePlayer(player.name,0,0,false,0,-50,false)
                else
                    tfm.exec.movePlayer(player.name,0,0,false,-1,-1,false)
                    tfm.exec.movePlayer(player.name,0,0,false,1,1,true)
                end
            end,
            [KEYS.DOWN]=function(player,down,x,y)
                if down then
                    tfm.exec.movePlayer(player.name,0,0,false,0,50,false)
                else
                    tfm.exec.movePlayer(player.name,0,0,false,-1,-1,false)
                    tfm.exec.movePlayer(player.name,0,0,false,1,1,true)
                end
            end,
            [KEYS.LEFT]=function(player,down,x,y)
                if down then
                    tfm.exec.movePlayer(player.name,0,0,false,-50,0,false)
                else
                    tfm.exec.movePlayer(player.name,0,0,false,-1,-1,false)
                    tfm.exec.movePlayer(player.name,0,0,false,1,1,true)
                end
            end,
            [KEYS.RIGHT]=function(player,down,x,y)
                if down then
                    tfm.exec.movePlayer(player.name,0,0,false,50,0,false)
                else
                    tfm.exec.movePlayer(player.name,0,0,false,-1,-1,false)
                    tfm.exec.movePlayer(player.name,0,0,false,1,1,true)
                end
            end,
        }
    }
}