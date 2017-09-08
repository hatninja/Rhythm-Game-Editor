--Used in the game state.
--Manages everything to do with the custom game code.

local real_g = _G

Manager = class:new()
function Manager:init(game)
	print("Initializing Game: ",game)
	
	local dir = "Games/"..game
	if love.filesystem.isFile(dir.."/data.lon") then
		local data = LON.decode(dir.."/data.lon")
	end
	
	if love.filesystem.isFile(dir.."/main.lua") then
		self.code = love.filesystem.load(dir.."/main.lua")
		if self.code then
			setfenv(self.code,library_newEnviroment(dir))
			self.code()
		end
	end
end

function Manager:run(func)
	if self.code then
		setfenv(func, self.env)
		func()
	end
end

function Manager:update(dt)
	setfenv(1, self.env)
	if Game.update then
		Game.update(dt)
	end
	setfenv(1, real_g)
end

function Manager:draw()
	setfenv(1, self.env)
	if Game.draw then
		Game.draw(dt)
	end
	setfenv(1, real_g)
end

function Manager:count(c,tc)
	setfenv(1, self.env)
	if Game.count then
		local prevnodes = getPreviousNodes()
		Game.count(c,tc,prevnodes)
	end
	setfenv(1, real_g)
end