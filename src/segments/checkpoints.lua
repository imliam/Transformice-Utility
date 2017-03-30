_S.checkpoints = {
    callbacks={
        playerRespawn=function(player)
            if player.checkpoint then
                tfm.exec.movePlayer(player.name,player.checkpoint.x,player.checkpoint.y)
                if player.checkpoint.id then system.removeTimer(player.checkpoint.id) end
                if player.checkpoint.cheese then
                    player.checkpoint.id=system.newTimer(function()
                        if player and player.checkpoint then 
                            tfm.exec.giveCheese(player.name)
                            player.checkpoint.id=nil
                        end
                    end,1000,false)
                end
            end
        end,
        playerDied=function(player)
            if player.checkpoint then
                if player.checkpoint.id then system.removeTimer(player.checkpoint.id) end
            end
        end,
        playerWon=function(player)
            if player.checkpoint then
                player.checkpoint=nil
                ui.removeTextArea(-1,player.name)
            end
        end,
        newGame=function()
            for n,p in pairs(players) do
                if p.checkpoint then
                    p.checkpoint=nil
                    ui.removeTextArea(-1,p.name)
                end
            end
        end,
        keyboard={
            [KEYS.E]=function(player,down,x,y)
                if player.lastSpawn and player.lastSpawn+3000<=os.time() and (not player.checkpoint or player.checkpoint.timestamp+3000<=os.time()) then
                    player.checkpoint={
                        timestamp=os.time(),
                        x=x,
                        y=y,
                        cheese=tfm.get.room.playerList[player.name].hasCheese
                    }
                    ui.addTextArea(-1,"",player.name,x-2,y-2,4,4,0x44cc44,0xffffff,0.5)
                end
            end,
            [KEYS.DELETE]=function(player,down,x,y)
                if player.checkpoint then
                    player.checkpoint=nil
                    ui.removeTextArea(-1,player.name)
                end
            end
        }
    }
}