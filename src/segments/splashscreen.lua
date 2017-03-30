_S.splashScreen = {
    disabled=true,
    welcomed={},
    callbacks={
        newPlayer=function(player)
            _S.splashScreen.welcomed[player.name]={time=os.time(),img=tfm.exec.addImage("150da3fae92.png","&100",100,100,player.name)}
        end,
        eventLoop=function(time,remaining)
            for name,tbl in pairs(_S.splashScreen.welcomed) do
                if tbl.time<os.time()-10000 then
                    for i=1,10 do
                        tfm.exec.removeImage(tbl.img)
                    end
                    _S.splashScreen.welcomed[name]=nil
                    break
                end
            end
        end,
    }
}
