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
	self.precision = 1/16
	
	if lfs.isFile(dir.."/song.mp3") then self.song = la.newSource(dir.."/song.mp3")
	elseif lfs.isFile(dir.."/song.wav") then self.song = la.newSource(dir.."/song.wav")
	elseif lfs.isFile(dir.."/song.ogg") then self.song = la.newSource(dir.."/song.ogg")
	end
	--self.song:setPitch(0.75)
end

--Doesn't support tempo changes yet.
function Song:countToTime(count) return self.offset+self.rate*count end
function Song:timeToCount(time) return (time-self.offset)/self.rate end

function Song:getPos() return self.song:tell() end
function Song:setPos(to) return self.song:seek(to) end
function Song:getDuration() return self.song:getDuration() end
function Song:play() self.song:play() end
function Song:resume() self.song:resume() end
function Song:pause() self.song:pause() end
function Song:stop() self.song:stop() end