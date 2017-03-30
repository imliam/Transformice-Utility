-- Execute the eventRoundEnd() function to act as a pseudo-event whenever tfm.exec.newGame is executed

_newGame=tfm.exec.newGame
function tfm.exec.newGame(map,flip) eventRoundEnd() _newGame(map,flip) end

function eventRoundEnd()
    notifyListeners(function(sn,s)
        if not s.disabled or (map.segments and map.segments[sn]) then
            local cb=s.callbacks.roundEnd
            if cb then
                cb()
            end
        end
    end)
end