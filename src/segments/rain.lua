_S.rain = {
    disabled=true,
    ticks=0,
    ID=40,
    callbacks={
        eventLoop=function(time,remaining)
            _S.rain.ticks=_S.rain.ticks+1
            if _S.rain.ticks%2==0 then
                tfm.exec.addShamanObject(_S.rain.ID, math.random()*map.length, -800, math.random()*360)
            end
            
        end
    }
}