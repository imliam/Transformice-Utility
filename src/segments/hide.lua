_S.hide = {
    hidden={},
    movePlayer=function(player)
        if not player then return end --temp
        local p=tfm.get.room.playerList[player.name]
        local x=0
        if p.x<5 then x=400 elseif p.x>map.length-5 then x=map.length-400 end
        tfm.exec.movePlayer(player.name,x,-400,false,0,-5,false)
    end,
    callbacks={
        newGame=function()
            _S.hide.hidden={}
        end,
        playerLeft=function(player)
            _S.hide.hidden[player.name]=nil
        end,
        eventLoop=function(time,remaining)
            for n,p in pairs(_S.hide.hidden) do
                _S.hide.movePlayer(players[n])
            end
        end
    }
}