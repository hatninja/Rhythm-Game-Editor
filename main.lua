--Libraries
LON = require "lib.lon"
require "lib.class"

require "functions"

--Classes
require "manager"
require "song"

--States
require "state.game"

function love.load()
	--Set up graphics.
	limits = love.graphics.getSystemLimits()
	print("Maximum Texture Size: "..limits.texturesize)
	
	love.graphics.setDefaultFilter("nearest","nearest",0)
	
	
	changestate(Game,"running90s",nil,"Cheer Readers")
end

function love.update(dt)
	if state.update then state.update(dt) end
end

function love.draw()
	if state.draw then state.draw() end
end

function love.keypressed(k,r)
	if state.keypressed then state.keypressed(k,r) end
	
	if k == "." then debug = not debug end
	if k == "/" then love.graphics.newScreenshot():encode('png', os.time() .. '.png') end
end

function love.keyreleased(k) if state.keyreleased then state.keyreleased(k) end end
function love.textinput(t) if state.textinput then state.textinput(t) end end
function love.mousepressed(x,y,m) if state.mousepressed then state.mousepressed(x,y,m) end end
function love.mousereleased(x,y,m) if state.mousereleased then state.mousereleased(x,y,m) end end
function love.wheelmoved(x,y) if state.wheelmoved then state.wheelmoved(x,y) end end

function changestate(to, ...)
	if to then
		if to.unload then to.unload() end
		state = to
		if to.load then to.load(...) end
	else
		error("Invalid state name: "..to)
	end
end