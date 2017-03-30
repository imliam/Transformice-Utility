function showChangelog(days,num,player)
    days=days or 7
    num=num or 5
    local str=translate("changelogtitle",player.lang)
    local toshow=0
    for i,log in ipairs(changelog) do
        local d=dateToTimestamp(log.date)
        if (not log.modules or log.modules[module]) and os.time()-d < day*days then
            str=str.."\n"..log.date.." - "..table.concat(log.changes,"\n"..log.date.." - ")
            toshow=toshow+1
        end
        if i==num then break end
    end
    if toshow==0 then
        return nil
    end
    return str
end

changelog={
    {
        date = "01/04/2017",
        changes = {"#utility 2.0 is now open source!"}
    },
}