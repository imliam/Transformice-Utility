_S.addspawn = {
    toSpawn={},
    toDespawn={},
    callbacks={
        newGame=function()
            _S.addspawn.toSpawn={}
        end,
        summoningStart=function(player,type,x,y,ang)
            table.insert(_S.addspawn.toSpawn, {name=player.name, type=type, x=x,y=y, ang=ang, vx=0, vy=0, interval=6, tick=0, despawn=120})
        end,
        eventLoop=function(time,remaining)
            for k,v in pairs(_S.addspawn.toSpawn) do
                if v.tick>=v.interval then
                    table.insert(_S.addspawn.toDespawn,{id=tfm.exec.addShamanObject(v.type, v.x, v.y, v.ang, v.vx or 0, v.vy or 0),despawn=os.time()+(v.despawn*500)})
                    v.tick=0
                end
                v.tick=v.tick+1
            end
        end
    }
}