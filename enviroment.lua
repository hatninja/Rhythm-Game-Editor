function newEnviroment(dir)
	return {
		love = love,
		math = math,
		table = table,
		setfenv = setfenv,
		require = function(from)
			local code = love.filesystem.load(dir.."/"..from..".lua")
			setfenv(code,self.env)
			return code()
		end,
		print = function(msg) print("["..game.."] "..tostring(msg)) end,
		pairs = pairs,
		ipairs = ipairs,
		
		sound = {
			newImage = function(img)
				return love.graphics.newImage(dir.."/base/"..img)
			end,
			newSource = function(snd)
				return love.audio.newSource(dir.."/sounds/"..snd, "static")
			end,
			play = function(source,bpm)
				source:stop();source:play()
			end,
		},
		
		getPreviousNodes = function()
			local t = {}
			for i,node in ipairs(Game.beatmap) do
				table.insert(t,1,{node[1], Game.totalcount - math.floor(Game.song:timeToCount(node[2])*16)})
			end
			return t
		end,
		
		class = class,
		interpolate = interpolate,
		Game = {}
	}
end