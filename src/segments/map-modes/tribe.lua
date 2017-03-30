_S.mapMode_tribe = {
    disabled=true,
    callbacks={
        newGame=function()
            tfm.exec.setGameTime(999999)
        end,
        playerDied=function(player)
            tfm.exec.respawnPlayer(player.name)
        end
    }
}
