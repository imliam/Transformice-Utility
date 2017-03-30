-- Script to provision the module and initialise necessary methods

bindChatCommands()

for name,player in pairs(tfm.get.room.playerList) do
    eventNewPlayer(name)
end

selectMap()