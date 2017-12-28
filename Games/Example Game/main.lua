--Initialize your game, same way you would a love2d project.
function Game.load()
	beatbop = 0
	offbeatbop = 0
end

--Reset your game scene.
function Game.reset()
end

--Get beats as they happen!
function Game.count(count,totalcount)
	if count == 0 then
		beatbop = 100
	elseif count == 0.5 then
		offbeatbop = 100
	end
end

--Love2d
function Game.update(dt)
	beatbop = math.max(beatbop-beatbop*dt*10,0)
	offbeatbop = math.max(offbeatbop-offbeatbop*dt*10,0)
end

function Game.draw()
	graphics.print("Beat",0,beatbop)
	graphics.print("Off-Beat",100,offbeatbop)
end