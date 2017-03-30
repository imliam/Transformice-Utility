_S.debug = {
    mapinfo="  ",
        callbacks={
        newGame=function()
            _S.debug.mapinfo="  "
            for k,v in ipairs({{"collision","C"},{"soulmate","S"},{"night","N"},{"portal","P"},{"aie","AIE"},{"mgoc","MGOC"},{"wind","W%s"},{"gravity","G%s"}}) do
                if map[v[1] ] then
                    if tonumber(map[v[1] ]) then
                        if not (v[1]=="wind" and map[v[1] ]==0) and not (v[1]=="gravity" and map[v[1] ]==10) then
                            _S.debug.mapinfo=_S.debug.mapinfo..(v[2]:format(tonumber(map[v[1] ]))).." "
                        end
                    else
                        _S.debug.mapinfo=_S.debug.mapinfo..v[2].." "
                    end
                end
            end
            for name,player in pairs(players) do
                if player.activeSegments.debug then
                    _S.debug.showMapInfo(player.name)
                end
            end
        end
    },
    showMapInfo=function(name)
        if #_S.debug.mapinfo>2 then
            ui.addTextArea(-18,_S.debug.mapinfo,name,5,380,nil,16,nil,nil,0.5,true)
        else
            ui.removeTextArea(-18,name)
        end
    end
}