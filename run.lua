local lt,lg,le = love.timer,love.graphics,love.event
local gt = lt.getTime

function love.run()
	love.math.setRandomSeed(os.time())
	math.randomseed(os.time())
	
	love.load()

	lt.step()
	
	local dt = 0

	while true do
		local st = gt()
		--Event poll
		le.pump()
		for name, a,b,c,d,e,f in le.poll() do
			if name == "quit" then
				if not love.quit or not love.quit() then
					return a
				end
			end
			love.handlers[name](a,b,c,d,e,f)
		end

		--Update
		lt.step()
		dt = lt.getDelta()
		love.update(dt)

		lg.clear(lg.getBackgroundColor())
		lg.origin()
		love.draw()
		lg.present()
		
		lt.sleep(max(1/200 - (gt()-st),0))
	end
end