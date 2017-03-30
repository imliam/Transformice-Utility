_S.treelights = {
    disabled=true,
    decorations={},
    ids={0,1,2,4,9},
    callbacks={
        newGame=function()
            _S.treelights.decorations={}
            for _,deco in pairs(map.decorations) do
                if deco.id==57 then
                    table.insert(_S.treelights.decorations,deco)
                end
            end
        end,
        eventLoop=function(time,remaining)
            for _, deco in pairs(_S.treelights.decorations) do
                for k = 10,0,-1 do
                    tfm.exec.displayParticle(_S.treelights.ids[math.random(#_S.treelights.ids)],deco.x+math.random(-40,40),deco.y+math.random(-120,0),0,0,0,0)
                    tfm.exec.displayParticle(11,deco.x-2,deco.y-183,math.cos(k),math.sin(k),0,0)
                end
            end
        end
    }
}