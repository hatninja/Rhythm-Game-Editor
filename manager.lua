--Used in the game state.
--Manages everything to do with the custom game code.

local newEnviroment = require "enviroment"
local real_g = _G

Manager = class:new()
function Manager:init(game)
	print("Initializing Game: ",game)
	
	local dir = "Games/"..game
	if love.filesystem.isFile(dir.."/data.lon") then
		local data = LON.decode(love.filesystem.read(dir.."/data.lon"))
		self.data = data
	end
	
	if love.filesystem.isFile(dir.."/main.lua") then
		self.code = love.filesystem.load(dir.."/main.lua")
		if self.code then
			self.env = newEnviroment(dir,game)
			setfenv(self.code,self.env)
			self.code()
			
			setfenv(function() 
				if Game.load then
					Game.load()
				end
			end,self.env)()
		end
	end
end

function Manager:reset()
	setfenv(1, self.env)
	if Game.reset then
		Game.reset(dt)
	end
	setfenv(1, real_g)
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
	graphics.reset()
	setfenv(1, real_g)
end


function Manager:press(b)
	setfenv(1, self.env)
	if Game.press then
		Game.press(b)
	end
	setfenv(1, real_g)
end


function Manager:count(c,tc)
	setfenv(1, self.env)
	if Game.count then
		Game.count(c,tc)
	end
	if Game.cue then
		for i,node in ipairs(real_g.Game.beatmap) do
			if self.data.nodes[node.id].cues then
				for i2,cue in ipairs(self.data.nodes[node.id].cues) do
					if node.count+math.round(cue,1/16) == tc then
						Game.cue(i2,node)
					end
				end
			end
		end
	end
	setfenv(1, real_g)
end