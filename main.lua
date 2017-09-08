LON = require "lib.lon"
require "lib.class"

require "functions"

require "manager"
require "song"

require "state.game"

function love.load()
	love.graphics.setDefaultFilter("nearest","nearest",2)
	limits = love.graphics.getSystemLimits()
	print("Maximum Texture Size: "..limits.texturesize)
	
	changestate("Game","Cheer Readers","Cheer Readers")
end

function love.update(dt)
	if _G[state].update then _G[state].update(dt) end
end

function love.draw()
	if _G[state].draw then _G[state].draw() end
end

function love.keypressed(k,r)
	if _G[state].keypressed then _G[state].keypressed(k,r) end
	
	if k == "/" then
		local screenshot = love.graphics.newScreenshot()
		screenshot:encode('png', os.time() .. '.png')
	end
	if k == "." then debug = not debug end
end

function love.keyreleased(k) if _G[state].keyreleased then _G[state].keyreleased(k) end end
function love.textinput(t) if _G[state].textinput then _G[state].textinput(t) end end
function love.mousepressed(x,y,m) if _G[state].mousepressed then _G[state].mousepressed(x,y,m) end end
function love.mousereleased(x,y,m) if _G[state].mousereleased then _G[state].mousereleased(x,y,m) end end
function love.wheelmoved(x,y) if _G[state].wheelmoved then _G[state].wheelmoved(x,y) end end

function changestate(to, ...)
	if _G[to] then
		if _G[to].unload then _G[to].unload() end
		state = to
		if _G[to].load then _G[to].load(...) end
	else
		error("Invalid state name: "..to)
	end
end