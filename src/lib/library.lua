function inSquare(x1,y1,x2,y2,r)
    return x1>x2-r and x1<x2+r and y1>y2-r and y1<y2+r
end

function string.split(str,s)
    if not str then
        return nil
    end
    local res = {}
    for part in string.gmatch(str, "[^" .. s .. "]+") do
        table.insert(res, part)
    end
    return res
end

function string.escape(str)
    return string.gsub(str, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1")
end

function table.getl(rawTable)
    local count = 0
    for index in pairs(rawTable) do
        count = count+1
    end
    return count
end

function unpack(t,i,j) local i,j=i or 1,j or #t if i<=j then return t[i],unpack(t,i+1,j) end end

function table.random(t,recursive,associative)
    local tbl={}
    if associative then
        for k,v in pairs(t) do
            table.insert(tbl,v)
        end
    else
        for k,v in ipairs(t) do
            table.insert(tbl,v)
        end
    end
    local val=tbl[math.random(#tbl)]
    if recursive and type(val)=="table" then
        return table.random(t,true)
    else
        return val
    end
end

function pythag(x1,y1,x2,y2,r)
    local x=x2-x1
    local y=y2-y1
    local r=r+r
    return x*x+y*y<r*r
end

function distance(x1,y1,x2,y2)
    return math.sqrt((x2-x1)^2+(y2-y1)^2)
end

function upper(str)
    if not str then return nil end
    return equalAny(str:sub(1,1), "+", "*") and str:sub(1,2):upper()..str:sub(3):lower() or str:sub(1,1):upper()..str:sub(2):lower()
end

function equalAny(v, ...)
    for _, a in pairs({...}) do
        if a == v then
            return true
        end
    end
end

function dateToTimestamp(timeToConvert)
    local pattern = "(%d+)/(%d+)/(%d+)"
    local runday, runmonth, runyear = timeToConvert:match(pattern)
    return os.time({year=runyear,month=runmonth,day=runday,hour=0,min=0,sec=0})
end
day=86400000

function printInfo(tbl, value, name, tabs)
    tabs=tabs or ""
    local t=type(value)
    print(tabs .. t .. " " .. tostring(tbl) .. " = " .. tostring(value),name)
    if t=="table" then
        for n,v in pairs(value) do
            if v==value then
                print(tabs.."\tself "..n,name)
            else
                printInfo(n,v,name,tabs.."\t")
            end
        end
    end
end
