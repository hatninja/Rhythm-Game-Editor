Game = {}

local lg = love.graphics
local floor,min,max = math.floor,math.min,math.max

local beepsnd = love.audio.newSource("beep.wav","static")

function Game.load(songdir,beatmap,gamedir)
	Game.managers = {Manager:new(gamedir)}
	Game.active = 1
	
	Game.song = Song:new(songdir)	
	Game.song:play()
	
	Game.nextcount = Game.song.offset --Determines when the next 1/16th will be
	Game.count = 0
	
	Game.beatmap = {}
	
	Game.paused = false
	
	--We are going to need an editor state for this.
	gridzoom = 200
	
	accuracy = 2
	cueplacement = false
	metronome = false
end

function Game.draw()
	Game.managers[Game.active]:draw()
	
	Game.drawBeatmap()
	
	if debug then
		lg.print(Game.count,0,500)
		lg.print(love.timer.getFPS())
	end
end

function Game.drawBeatmap()
	local duration = Game.song:getDuration()
	local pos = Game.song:getPos() --It will change over time in the same update.
	
	--[[Beatmap panel]]
	lg.setColor(0,0,0,200)
	lg.rectangle("fill",0,500,800,100)
	
	lg.setColor(255,255,255)
	lg.line(0,500,800,500)
		
	lg.push()
	lg.translate(-pos*gridzoom+400,500)
	
	--Seconds
	lg.setColor(130,130,130)
	for i=max(floor(pos)-400/gridzoom,0),min(floor(pos)+400/gridzoom,duration) do
		lg.line(i*gridzoom,0,i*gridzoom,100)
	end

	--Waveform
	lg.setColor(255,255,255)
	Game.song:draw()
	
	--Start/End
	lg.setColor(0,255,0); lg.line(0,0,0,100)
	lg.setColor(255,0,0); lg.line(duration*gridzoom,0,duration*gridzoom,100)

	--Off-Beats
	lg.setColor(0,200,200)
	for i=Game.song.offset+Game.song.rate/2, duration, Game.song.rate do
		lg.line(i*gridzoom,25,i*gridzoom,75)
	end
	
	--Beats
	lg.setColor(0,255,255)
	for i=Game.song.offset, duration, Game.song.rate do
		lg.line(i*gridzoom,10,i*gridzoom,90)
	end
	
	--Nodes
	for i,node in ipairs(Game.beatmap) do
		local nodePos = Game.song:countToTime(node.count)
		if nodePos > pos-400/gridzoom and nodePos < pos+400/gridzoom then
			local yoffset = 0
			for i2,node2 in ipairs(Game.beatmap) do
				if node2.count == node.count then
					if i < i2 then yoffset = yoffset-10
					else yoffset = yoffset+10
					end
				end
			end
			
			lg.setColor(255,255,255)
			lg.circle("fill", nodePos*gridzoom,50+yoffset,10)
			lg.setColor(0,0,0)
			lg.circle("line", nodePos*gridzoom,50+yoffset,10)
			lg.print(node.id, nodePos*gridzoom-3,43+yoffset)
		end
	end
	
	--Position
	lg.setColor(0,0,255)
	lg.line(pos*gridzoom,0,pos*gridzoom,100)
	lg.setColor(255,255,255)
	
	lg.pop()
end

function Game.update(dt)
	if Game.song:isPlaying() then
		for i,game in ipairs(Game.managers) do game:update(dt) end
		
		while Game.song:getPos() > Game.nextcount do
			Game.nextcount = Game.nextcount + Game.song.rate/16
		
			for i,game in ipairs(Game.managers) do game:count(Game.count-math.floor(Game.count),Game.count) end
			
			Game.count = Game.count + 1/16
		end
	end
end

function Game.keypressed(k)
	if tonumber(k) then
		local num = tonumber(k)
		table.insert(Game.beatmap, {id=num, count=round(Game.song:timeToCount(Game.song:getPos()),1/2)})
	end
	if k == "backspace" then
		Game.pause()
		Game.song:stop()
		
		Game.count = 0
		Game.totalcount = 0
		Game.nextcount = Game.song.offset
		
		for i,game in ipairs(Game.managers) do game:reset() end
	end
	if k == "p" then
		if Game.paused then Game.resume()
		else Game.pause()
		end
	end
	if k == "space" then
		Game.managers[Game.active]:press(1)
	end
end

function Game.keyreleased(k)
	if k == "space" then
		Game.managers[Game.active]:press(-1)
	end
end

function Game.pause()
	Game.paused = true
	Game.song:pause()
end

function Game.resume()
	Game.paused = false
	Game.song:play()
end