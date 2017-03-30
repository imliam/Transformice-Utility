_S.fireworks = {
    disabled=true,
    counter=0,
    timedEvents={},
    players={},
    defaultPlayer=function(player)
        _S.fireworks.players[player] = os.time()
    end,
    spawnPoints = {
        -- {1=x, 2=y, 3=chance, 4=speed, 5=progress, 6=imageX, 7=imageY, 8=imageId, 9=activateDist, 10=baseVx, 11=maxOffsetVx}
        {20, 340, 0.3, 1.5, 1, 130, 333, -1, 60, 3.5, 1},
        {295, 340, 0.4, 2.5, 1, 348, 336, -1, 80, -2.5, 1},
        {480, 340, 0.4, 2.5, 1, 604, 232, -1, 80, 2.5, 1},
        {777, 340, 0.3, 1.5, 1, 604, 232, -1, 80, -3.5, 1}
    },
    explosionData = {
        --[[ FORMAT START
        {
            function(trailParticleId,extraParticles,centerX,centerY)
                -- trailParticleId is the particle id from the trail
                -- extraParticles gets passed on from this table to this function
                -- centerX is the center X coordinate from the explosion
                -- centerY ............. Y .............................
                -- do stuff here
            end,
            extraParticles,
            timeBeforeExplosion
        }
        FORMAT END ]]--
        {function(id,p,x,y) -- Star shaped, same color as trail
            _S.fireworks.drawParam2({x, y, 7.0, 0.4, 10, {id}})
        end, {}, 1000},
        {function(id,p,x,y) -- Default firework, same color as trail
            _S.fireworks.defaultEffect(id,p,x,y,true)
        end, {0,2}, 1000},
        {function(id,p,x,y)
            _S.fireworks.defaultEffect(id,p,x,y,true)
        end, REDWHITEBLUE, 1000},
        {function(id,p,x,y)
            _S.fireworks.defaultEffect(id,p,x,y,false)
        end, REDWHITEBLUE, 1000}
    },
    fireworkSets={
        --[[ FORMAT START
        {
            trailId or {trailId1, trailId2}, -- if it's a number, it will pick that, if it's a table, it will pick a random one
            explosionIndex, -- index in explosionData
            probability
        }
        FORMAT END]]--
        {REDWHITEBLUE, 4, 50}, -- red white blue default firework
        {REDWHITEBLUE, 3, 25}, -- red white blue default firework
        {{0, 2}, 2, 15}, -- white and gold default firework
        {REDWHITEBLUE, 1, 3}, -- Star shaped, same color as trail
    },
    setPositions=function()
        _S.fireworks.spawnPoints={}
        for i=100,(map.length or 800),200 do
            tfm.exec.chatMessage(i)
            table.insert(_S.fireworks.spawnPoints,{i, (map.height or 400)-20, 0.1, math.random(15,25)/10, 1, math.random(350,650), math.random(350,650), -1, 80, math.random(-35,35)/10, 1})
        end
    end,
    callbacks={
        --newGame=function()
        --  _S.fireworks.setPositions()
        --end,
        eventLoop=function(time,remaining)
            if _S.fireworks.counter % 3 == 0 then
                local b = 1000
                local e = b + 3000
                for i,sp in pairs(_S.fireworks.spawnPoints) do
                    for j = b, e, 1000 / (sp[4] + (sp[5] - 0.5) * 3) do
                        _S.fireworks.timedEvent(j, false, function(i)
                            _S.fireworks.fireIt(i)
                        end, i)
                    end
                end
            end
            local tR = {}
            for i,t in pairs(_S.fireworks.timedEvents) do
                if t[1] < os.time() then
                    t[3](unpack(t[4]))
                    if t[2] == true then
                        t[1] = t[1] + t[5]
                    else
                        tR[i] = true
                    end
                end
            end
            for i in pairs(tR) do
                _S.fireworks.timedEvents[i] = nil
            end
            _S.fireworks.counter = _S.fireworks.counter + 0.5
        end,
        keyboard={
            [KEYS.SPACE]=function(player,down,x,y)
                if down then
                    if _S.fireworks.players[player] < os.time()-500 then
                        _S.fireworks.players[player] = os.time()
                        _S.fireworks.selectAndFire(x,y)
                    end
                end
            end,
        },
    },
    timedEvent=function(ms, r, f, ...)
        _S.fireworks.timedEvents[#_S.fireworks.timedEvents + 1] = {os.time()+ms,r,f,arg,ms}
    end,
    fireIt=function(spI)
        local sp = _S.fireworks.spawnPoints[spI]
        if math.random() < sp[3] * sp[5] then
            local vx = sp[10] + math.random(-sp[11], sp[11])
            _S.fireworks.selectAndFire(sp[1], sp[2], vx)
        end
    end,
    selectAndFire=function(x, y, vx, setI)
        vx = vx == nil and math.random(-3, 3) or vx
        if setI == nil then
            -- calculate a random set based on probabilities
            local total = 0
            for _,s in ipairs(_S.fireworks.fireworkSets) do
                total = total + s[3]
            end
            local r = math.random(0, total - 1)
            total = 0
            for i,s in ipairs(_S.fireworks.fireworkSets) do
                total = total + s[3]
                if total > r then
                    setI = i
                    break
                end
            end
        end
        local fireworkSet = _S.fireworks.fireworkSets[setI]
        if fireworkSet ~= nil then
            local id = fireworkSet[1]
            if type(id) == 'table' then
                id = id[math.random(#id)]   
            end
            _S.fireworks.firework(id, x, y, vx, -20, 0, math.random(8, 9) / 10, 5, 30, _S.fireworks.explosionData[fireworkSet[2]])
        end
    end,
    firework=function(id, initX, initY, vx, vy, ax, ay, magnitude, length, explosion)
        local params = nil
        local xMultiplier = 3
        if explosion == nil then
            xMultiplier = 5
        end
        -- Launch firework
        for i = magnitude, 1, -1 do
            local timeT = xMultiplier * (-i / magnitude)
            local velX = timeT * ax + vx
            local velY = timeT * ay + vy
            local x = initX + (velX + vx) / 2 * timeT
            local y = initY + (velY + vy) / 2 * timeT
            if params == nil then
                params = {x, y, velX, velY, ax, ay, id} -- we use these to calculate our explosion position
            end
            for j = 1, magnitude - i do
                if id == -1 then
                    tfm.exec.displayParticle(9, x, y, velX, velY, ax, ay, nil)
                    tfm.exec.displayParticle(1, x, y, velX, velY, ax, ay, nil)
                else
                    tfm.exec.displayParticle(id, x, y, velX, velY, ax, ay, nil)
                end
            end
        end
        if explosion ~= nil then
            system.newTimer(function(timerId, expl, params)
                -- local tx = expl[3] / (math.pi * 10) -- guesstimation
                local t = explosion[3] / (math.pi * 10)
                local dx = params[3] * t + 0.5 * params[5] * t^2 -- change in x = vxi*changeintime+0.5*ax*t^2
                local x = params[1] + dx
                local dy = params[4] * t + 0.5 * params[6] * t^2 -- change in y = vyi*changeintime+0.5*ay*t^2
                local y = params[2] + dy
    
                local f = explosion[1]
                local particles = explosion[2]
                f(params[7], particles, x, y)
                system.removeTimer(timerId)
            end, math.max(explosion[3], 1000), false, explosion, params)
        end
    end,
    defaultEffect=function(id,p,x,y,rand)
        local minDist = 1
        local outerBorder = 20
        local maxDist = 30
        local totalParticles = rand and 40 or (id == -1 and 35 or 75)
        for i = 1, totalParticles do
            if rand then
                id = p[math.random(#p)]
            end
            local dist = math.min(math.random(minDist, maxDist), outerBorder)
            local angle = math.random(0, 360)
            local r = math.rad(angle)
            local dx = math.cos(r)
            local dy = math.sin(r)
            local vx = dist * dx / 10
            local vy = dist * dy / 10
            local ax = -vx / dist / 15
            local ay = (-vy / dist / 15) + 0.05
            if id == -1 then
                tfm.exec.displayParticle(9, x + dx, y + dy, vx, vy, ax, ay, nil)
                tfm.exec.displayParticle(1, x + dx, y + dy, vx, vy, ax, ay, nil)
            else
                tfm.exec.displayParticle(id, x + dx, y + dy, vx, vy, ax, ay, nil)
            end
        end
    end,
    drawParam2=function(arg)
        local x,y,k,a,m,particles=arg[1],arg[2],arg[3],arg[4],arg[5],arg[6]
        local b=a/k
        local dx,dy=0,0
        for t=0,math.pi*2,math.pi/36 do -- step math.pi/18 is every 10 degrees
            dx=x+((a-b)*math.cos(t)+b*math.cos(t*((a/b)-1)))*m
            dy=y+((a-b)*math.sin(t)-b*math.sin(t*((a/b)-1)))*m
            _S.fireworks.velocityEffect(x,y,dx,dy,particles)
        end
    end,
    velocityEffect=function(x,y,dx,dy,particles)
        local dist = distance(x, y, dx, dy)
        local angle = math.atan2(dy - y, dx - x)
        local vx = dist * math.cos(angle)
        local vy = dist * math.sin(angle)
        local ax = -vx / dist / 15
        local ay = (-vy / dist / 15) + 0.05 -- +0.05 for gravity
        for _,p in ipairs(particles) do
            if p == -1 then
                tfm.exec.displayParticle(9, dx, dy, vx, vy, ax, ay, nil)
                tfm.exec.displayParticle(1, dx, dy, vx, vy, ax, ay, nil)
            else
                tfm.exec.displayParticle(p, dx, dy, vx, vy, ax, ay, nil)
            end
        end
    end
}