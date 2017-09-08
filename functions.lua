local floor = math.floor

--Geometry
function distanceto(x1,y1,x2,y2) return math.sqrt((x2-x1)^2+(y2-y1)^2) end
function angleto(x1,y1,x2,y2) return math.atan2(y2-y1, x2-x1) end

--Rhythm
function BPM(seconds) return 1/seconds*60 end
function seconds(BPM) return 1/BPM*60 end

function getTimeStamp(seconds) return floor(seconds/60)..":"..floor(seconds%60).."."..floor((seconds*60)%60) end

function beatToTime(bpm,beat,offset) return offset+(seconds(bpm)*beat) end
function timeToBeat(bpm,time) return floor(time/seconds(bpm)+0.5) end

function round(n) return floor(n+.5) end

--Sound
function playsound(source) love.audio.stop(source);love.audio.play(source) end

--Misc Function
function string.split(input,delimit)
	local t = {}
	local string = tostring(input)
	local delimiter = tostring(delimit) or ""
	
	if delimiter and delimiter ~= "" then
		while string:find(delimiter) do
			local beginning, ending = string:find(delimiter)
			table.insert(t,string:sub(1,beginning-1))
			string = string:sub(ending+1)
		end
		if not string:find(delimiter) then
			table.insert(t,string)
		end
	else
		for i = 1, #string do
			table.insert(t,string:sub(i,i))
		end
	end
	
	return t
end

function interpolate(a,b,lambda,exponent)
	if exponent then
		return a+(math.pow(lambda,exponent)*(b-a))
	else
		return a+(lambda*(b-a))
	end
end

function sum(...)
	local arg = {...}
	local sum = 0
	for i=1,#arg do
		sum = sum + arg[i]
	end
	return sum
end

function average(...)
	local arg = {...}
	local sum = 0
	local size = #arg
	for i=1,size do
		sum = sum + arg[i]
	end
	return sum/size
end

function clamp(num,min,max)
	if num < min then
		return min
	elseif num > max then
		return max
	end
	return num
end

--My totally elegant waveform generator function
function generateWaveform(sound,spp)
	local spp = spp*2

	local soundData = love.sound.newSoundData(sound)
	local length = soundData:getDuration()
	local sampleRate = soundData:getSampleRate()
	local sampleCount = soundData:getSampleCount()
	
	local width = limits.texturesize --Our maximum width
	local cwidth = math.floor(length/(spp/2))
	local height = 100
	local wraps = 1
	
	--Calculate the image size we'll need
	while cwidth > width do
		wraps = wraps + 1
		cwidth = cwidth - width
	end
	
	local quads = {}
	
	local imageData = love.image.newImageData(width,height*wraps)
	
	for w=1,wraps do
		for x=0, width-1 do
			if max then break end --We reached the max sample rate, we shouldn't continue looping.
			local highest = 1
			local lowest = -1
			local max = false
			
			
			for s=math.floor((sampleRate*(x+((w-1)*width)))*spp),math.floor((sampleRate*(x+1+((w-1)*width)))*spp) do
				if s < sampleCount*2 then
					local sample = soundData:getSample(s)
					if not highest or sample < highest then
						highest = sample
					elseif not lowest or sample > lowest then
						lowest = sample
					end
				else
					max = true
					break
				end
			end
			
			for y=0, height-1 do
				if y > (highest+1)*(height/2)-1 and y < (lowest+1)*(height/2)-1 then --Debug conditions: max or y == 0 or y == height-1 or
					imageData:setPixel(x,y+((w-1)*height),255,255,255,255)
				end
			end
		end
		
		quads[#quads+1] = love.graphics.newQuad(0,((w-1)*height), width, height, width, height*wraps)
	end
	
	print("Waveform generated:\t"..wraps.."quads")
	return love.graphics.newImage(imageData), quads, width
end

--cd Directory/; zip -r file.zip * -x "*.DS_Store"

--Functions by other people

--Taehl's hsl to rgb converter
function HSL(h, s, l, a)
	if s<=0 then return l,l,l,a end
	h, s, l = h/256*6, s/255, l/255
	local c = (1-math.abs(2*l-1))*s
	local x = (1-math.abs(h%2-1))*c
	local m,r,g,b = (l-.5*c), 0,0,0
	if h < 1     then r,g,b = c,x,0
	elseif h < 2 then r,g,b = x,c,0
	elseif h < 3 then r,g,b = 0,c,x
	elseif h < 4 then r,g,b = 0,x,c
	elseif h < 5 then r,g,b = x,0,c
	else              r,g,b = c,0,x
	end return (r+m)*255,(g+m)*255,(b+m)*255,a
end