local lfs = love.filesystem
local la = love.audio
Song = class:new()

function Song:init(name)
	local dir = "Songs/"..name
	local data = LON.decode(love.filesystem.read(dir.."/data.lon"))
	
	self.title = data.title or "N/A"
	self.author = data.author or "N/A"
	
	self.offset = data.offset or 0
	self.rate = 1/(data.bpm or 120)*60
	--self.rates = {} --Perhaps we should do something like this for tempo changes.
	
	local extension = ".mp3"
	if not lfs.isFile(dir.."/song"..extension) then extension = ".wav" end
	if not lfs.isFile(dir.."/song"..extension) then extension = ".ogg" end
	if lfs.isFile(dir.."/song"..extension) then
		self.song = la.newSource(dir.."/song"..extension)
	end
	
	self.waveform, self.waveform_quads, self.waveform_width, self.waveform_height = generateWaveform(dir.."/song"..extension, 200)
end

function Song:countToTime(count) return self.offset+self.rate*count end
function Song:timeToCount(time) return (time-self.offset)/self.rate end

function Song:getPos() return self.song:tell() end
function Song:setPos(to) return self.song:seek(to) end
function Song:getDuration() return self.song:getDuration() end
function Song:isPlaying() return self.song:isPlaying() end
function Song:play() self.song:play() end
function Song:resume() self.song:resume() end
function Song:pause() self.song:pause() end
function Song:stop() self.song:stop() end

function Song:draw()
	for i=1,#self.waveform_quads do
		love.graphics.draw(self.waveform,self.waveform_quads[i],(i-1)*self.waveform_width,0,0,1,100/self.waveform_height)
		if debug then love.graphics.print(i,(i-1)*self.waveform_width,0) end
	end
end