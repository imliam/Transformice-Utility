_S.doge = {
    disabled=true,
    callbacks={
        eventLoop=function(time,remaining)
            for n,p in pairs(players) do
                local phrases=translate("doge",p.lang)
                ui.addTextArea(-50, "<font face='Comic sans MS' color='#"..string.format("%X",math.random(0,0xFFFFFF)).."' size='17'>"..phrases[math.random(#phrases)].."</font>", nil, math.random(100,map.length-100), math.random(40,map.height-40), nil, nil, 0)
            end
        end 
    }
}