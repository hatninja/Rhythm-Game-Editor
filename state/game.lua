Game = {}

local floor,min,max = math.floor,math.min,math.max

local beepsnd = love.audio.newSource("beep.wav","static")

function Game.load(gamedir,songdir,beatmap)
	Game.song = Song:new(songdir)	
	Game.song:play()
	Game.managers = {Manager:new(gamedir)}
	Game.count = 0
	Game.totalcount = 0
	Game.nextbeat = Game.song.offset
	Game.beatmap = {}
	
	Game.paused = false
	
	--Editor stuff
	gridzoom = 200
	waveformimg, waveform_quads, waveform_quadwidth = generateWaveform("Songs/"..songdir.."/song.mp3", 1/gridzoom)
	
	accuracy = 2
	cueplacement = false
	metronome = false
end

function Game.draw()
	Game.managers[1]:draw()

	local duration = Game.song:getDuration()
	
	--[[Beatmap panel]]
	love.graphics.setColor(100,100,100)
	love.graphics.rectangle("fill",0,500,800,100)
	
	love.graphics.push()
	love.graphics.translate(-Game.song:getPos()*gridzoom+400,500)
	
	--Seconds
	love.graphics.setColor(130,130,130)
	for i=max(floor(Game.song:getPos())-400/gridzoom,0),min(floor(Game.song:getPos())+400/gridzoom,duration) do
		love.graphics.line(i*gridzoom,0,i*gridzoom,100)
	end

	--Waveform
	love.graphics.setColor(255,255,255,255)
	for i=1,#waveform_quads do
		if (i-1)*waveform_quadwidth < Game.song:getPos()*gridzoom+400 or (i)*waveform_quadwidth > Game.song:getPos()*gridzoom-400 then
			love.graphics.draw(waveformimg,waveform_quads[i],(i-1)*waveform_quadwidth,0)
		end
	end
	
	--Start/End
	love.graphics.setColor(0,255,0); love.graphics.line(0,0,0,100)
	love.graphics.setColor(255,0,0); love.graphics.line(duration*gridzoom,0,duration*gridzoom,100)
	
	
	--Off-Beats
	love.graphics.setColor(0,200,200)
	for i=Game.song.offset+Game.song.rate/2, duration, Game.song.rate do
		love.graphics.line(i*gridzoom,25,i*gridzoom,75)
	end
	
	--Beats
	love.graphics.setColor(0,255,255)
	for i=Game.song.offset, duration, Game.song.rate do
		love.graphics.line(i*gridzoom,10,i*gridzoom,90)
	end
	
	for i,node in ipairs(Game.beatmap) do
		if node[2] > Game.song:getPos()-400/gridzoom and node[2] < Game.song:getPos()+400/gridzoom then
			local yoffset = 0
			for i2,onode in ipairs(Game.beatmap) do
				if onode[2] == node[2] then
					if i < i2 then yoffset = yoffset-10
					else yoffset = yoffset+10
					end
				end
			end
			
			love.graphics.setColor(255,255,255)
			love.graphics.circle("fill", node[2]*gridzoom,50+yoffset,10)
			love.graphics.setColor(0,0,0)
			love.graphics.circle("line", node[2]*gridzoom,50+yoffset,10)
			love.graphics.print(node[1], node[2]*gridzoom-3,43+yoffset)
		end
	end
	
	love.graphics.pop()
	
	--Position
	love.graphics.setColor(0,0,255)
	love.graphics.line(400,500,400,600)

	--FPS
	love.graphics.setColor(255,255,255)
	love.graphics.print(love.timer.getFPS())
end

function Game.update(dt)
	if not Game.paused then
		for i,game in ipairs(Game.managers) do game:update(dt) end
		
		while Game.song:getPos() > Game.nextbeat do
			if Game.count == 0 and metronome then love.audio.stop(beepsnd);love.audio.play(beepsnd) end
			Game.nextbeat = Game.nextbeat + Game.song.rate/16
		
			for i,game in ipairs(Game.managers) do game:count(Game.count, Game.totalcount) end
			
			Game.count = (Game.count + 1) % 16
			Game.totalcount = Game.totalcount + 1
		end
	end
end

function Game.keypressed(k)
	if tonumber(k) then
		local num = tonumber(k)
		local tocount = Game.song:timeToCount(Game.song:getPos())
		table.insert(Game.beatmap, {num, Game.song:countToTime(math.floor(tocount*accuracy)/accuracy)})
	end
	if k == "backspace" then
		Game.song:pause()
		Game.song:stop()
		
		Game.count = 0
		Game.totalcount = 0
		Game.nextbeat = Game.song.offset
	end
	if k == "p" then
		if Game.paused then Game.resume()
		else Game.pause()
		end
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