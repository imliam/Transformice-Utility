_S.retro = {
    disabled=true,
    callbacks={
        newGame=function()
            for _,deco in ipairs(map.holes) do
                tfm.exec.addImage(_S.images.sprites.transformice.retrohole.img..".png","_100",deco.x+_S.images.sprites.transformice.retrohole.x,deco.y+_S.images.sprites.transformice.retrohole.y-15)
            end
        end,
    }
}