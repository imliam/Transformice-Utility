_S.conj = {
    callbacks={
        mouse={
            pr=3,
            fnc=function(player,x,y)
                tfm.exec.addConjuration(x/10,y/10,player.conjTime*1000)
            end
        }
    }
}