local floor = math.floor
local abs = math.abs

--Rhythm
function BPM(seconds) return 1/seconds*60 end
function seconds(BPM) return 1/BPM*60 end

function getTimeStamp(seconds) return floor(seconds/60)..":"..floor(seconds%60).."."..floor((seconds*60)%60) end

function max(a,b) return a > b and a or b end
function min(a,b) return a < b and a or b end
function clamp(n,max,min) return n < min and min or n > max and max or n end
function wrap(n,max,min) return min + (n-min) % (max-min) end
function round(n,d) return floor(n/(d or 1)+0.5)*(d or 1) end

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

function interpolate(a,b,lambda)
	return a+(lambda*(b-a))
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

--Elegant waveform generator function
function generateWaveform(sound,pps)
	local limit = limits.texturesize

	local soundData = love.sound.newSoundData(sound)
	local sampleRate = soundData:getSampleRate()
	local sampleCount = soundData:getSampleCount()
	
	local height = 100 --Height of waveform image.
	local width = limit --Our maximum width
	
	local totalwidth = (sampleCount/sampleRate)*pps
	local wraps = math.ceil(totalwidth/width)
	
	if height*wraps > limit then --Readjust height if the final image will be too big.
		height = floor(height*(limit/(height*wraps)))
	end
	
	local imageData = love.image.newImageData(width,height*wraps)
	local quads = {}
	
	for w=0,wraps-1 do
		for x=0, width-1 do
			local highest = -1/height
			local lowest = 1/height
		--	Min-Max is more than enough for seeing beats, averages just make it look messy.
		--	local highavg = 0
		--	local lowavg = 0
			
			for s=(sampleRate*(x+(w*width)))/pps*2, (sampleRate*(x+1+(w*width)))/pps*2 do
				if s < sampleCount*2 then
					local sample = soundData:getSample(floor(s))
					highest = min(sample,highest)
					lowest = max(sample,lowest)
		--			highavg = (min(sample,0)+highavg)/2
		--			lowavg = (max(sample,0)+lowavg)/2
				end
			end
			
			for y=0, height-1 do
				if y > (highest+1)*(height/2)-1 and y < (lowest+1)*(height/2)-1 then --Debug conditions: max or y == 0 or y == height-1 or
					imageData:setPixel(x,y+w*height,255,255,255,255)
				end
		--		if y > (highavg+1)*(height/2)-1 and y < (lowavg+1)*(height/2)-1 then --Debug conditions: max or y == 0 or y == height-1 or
		--			imageData:setPixel(x,y+w*height,128,128,128,255)
		--		end
			end
		end
		
		quads[#quads+1] = love.graphics.newQuad(0,w*height, width, height, width, height*wraps)
	end
	
	print("Waveform generated for \""..sound.."\"\t"..wraps.." quads\t"..wraps*height.." pixels high\t"..limit.." is the texture limit")
	return love.graphics.newImage(imageData), quads, width, height
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


--Web color code to R,G,B,A
function WEB(code)
	if code:sub(1,1) ~= "#" then error("Invalid Color Code!") end
	if #code <= 4 then return tonumber(code:sub(2,2),16),tonumber(code:sub(3,3),16),tonumber(code:sub(4,4),16),255
	elseif #code <= 5 then return tonumber(code:sub(2,2),16),tonumber(code:sub(3,3),16),tonumber(code:sub(4,4),16),tonumber(code:sub(5,5),16)
	elseif #code <= 7 then return tonumber(code:sub(2,3),16),tonumber(code:sub(4,5),16),tonumber(code:sub(6,7),16),255
	elseif #code <= 8 then return tonumber(code:sub(2,3),16),tonumber(code:sub(4,5),16),tonumber(code:sub(6,7),16),tonumber(code:sub(8,9),16)
	end
end