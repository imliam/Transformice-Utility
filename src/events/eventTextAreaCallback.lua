function eventTextAreaCallback(id,name,callback)
    local arg = string.split(callback, "%s")
    if arg[1] and _S[arg[1]] then
        local s=_S[arg[1]]
        local cb=s.callbacks.textArea
        if cb and cb[arg[2]] then
            cb[arg[2]](id,name,arg)
        end
    end
end