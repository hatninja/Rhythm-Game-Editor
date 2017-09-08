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
			self.env = newEnviroment(dir)
			setfenv(self.code,self.env)
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
--	if not self.data.nodes[1].cues[1] then return end
	setfenv(1, self.env)
	if Game.draw then
		Game.draw(dt)
	end
	graphics.reset()
	setfenv(1, real_g)
end

function Manager:count(c,tc)
	setfenv(1, self.env)
	if Game.count then
		local prevnodes = getPreviousNodes()
		Game.count(c,tc,prevnodes)
	end
	
	if Game.cue then
		for i,node in pairs(real_g.Game.beatmap) do
			local nodedata = self.data.nodes[node[1]]
			if nodedata and nodedata.cues then
				for index,time in ipairs(nodedata.cues) do
					if tc == real_g.Game.song:timeToCount(node[2])+time then
						Game.cue(index,node)
					end
				end
			end
		end
	end
	setfenv(1, real_g)
end