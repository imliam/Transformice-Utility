_S.insta = {
    callbacks={
        summoningStart=function(player,type,x,y,ang) 
            tfm.exec.addShamanObject(type,x,y,ang)
        end
    }
}
