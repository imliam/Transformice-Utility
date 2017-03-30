_S.explosion = {
    callbacks={
        mouse={
            pr=1,
            fnc=function(player,x,y)
                tfm.exec.explosion(x,y,50,100)
            end
        }
    }
}