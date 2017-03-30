_S.tp = {
    callbacks={
        mouse={
            pr=1,
            fnc=function(player,x,y)
                for _,n in pairs(player.tp) do
                    tfm.exec.movePlayer(n,x,y)
                end
                player.tp=nil
                player.activeSegments.tp=false
            end
        }
    }
}