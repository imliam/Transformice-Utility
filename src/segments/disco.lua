_S.disco = {
    disabled=true,
    callbacks={
        eventLoop=function(time,remaining)
            for n,p in pairs(tfm.get.room.playerList) do
                tfm.exec.setNameColor(n,math.random(0,0xFFFFFF))
            end
        end
    }
}