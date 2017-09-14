--For Manager.lua, this is a seperate file to make things cleaner.
return function(dir,game)
	local env = {
		--Simplified Lua 5.1
		assert = assert,
		gcinfo = gcinfo,
		error = error,
		getmetatable = getmetatable,
		ipairs = ipairs,
		next = next,
		pairs = pairs,
		pcall = pcall,
		print = function(msg) print("["..game.."] "..tostring(msg)) end,
		rawequal = rawequal,
		rawget = rawget,
		rawset = rawset,
		select = select,
		setmetatable = setmetatable,
		tonumber = tonumber,
		tostring = tostring,
		type = type,
		unpack = unpack,
		xpcall = xpcall,
		setfenv = setfenv,

		
		table = {
			concat = table.concat,
			insert = table.insert,
			maxn = table.maxn,
			remove = table.remove,
			sort = table.sort,
			unpack = table.unpack,
		},
		math = {
			abs = math.abs,
			acos = math.acos,
			asin = math.asin,
			atan = math.atan,
			atan2 = math.atan2,
			ceil = math.ceil,
			cos = math.cos,
			cosh = math.cosh,
			deg = math.deg,
			exp = math.exp,
			floor = math.floor,
			fmod = math.fmod,
			frexp = math.frexp,
			huge = math.huge,
			ldexp = math.ldexp,
			log = math.log,
			log10 = math.log10,
			max = math.max,
			min = math.min,
			modf = math.modf,
			pi = math.pi,
			pow = math.pow,
			rad = math.rad,
			random = math.random,
			sin = math.sin,
			sinh = math.sinh,
			sqrt = math.sqrt,
			tan = math.tan,
			tanh = math.tanh,
			--
			interpolate = interpolate,
			round = round,
		},
		string = {
			byte = string.byte,
			char = string.char,
			dump = string.dump,
			find = string.find,
			format = string.format,
			gmatch = string.gmatch,
			gsub = string.gsub,
			len = string.len,
			lower = string.lower,
			match = string.match,
			rep = string.rep,
			reverse = string.reverse,
			sub = string.sub,
			upper = string.upper,
		},	
		graphics = { --Hoo boy, that's a lot of functions...
			newImage = function(img)
				return love.graphics.newImage(dir.."/base/"..img)
			end,
			newQuad = love.graphics.newQuad,
			newCanvas = love.graphics.newCanvas,
			newFont = love.graphics.newFont,
			newImageFont = love.graphics.newImageFont,
			newMesh = love.graphics.newMesh,
			newParticleSystem = love.graphics.newParticleSystem,
			newShader = love.graphics.newShader,
			newSpriteBatch = love.graphics.newSpriteBatch,
			newText = love.graphics.newText,
			newVideo = love.graphics.newVideo,
			setNewFont = love.graphics.setNewFont,
			
			draw = love.graphics.draw,
			print = love.graphics.print,
			printf = love.graphics.printf,
			
			rectangle = love.graphics.rectangle,
			circle = love.graphics.circle,
			line = love.graphics.line,
			polygon = love.graphics.polygon,
			arc = love.graphics.arc,
			clear = love.graphics.clear,
			discard = love.graphics.discard,
			ellipse = love.graphics.ellipse,
			point = love.graphics.point,
			stencil = love.graphics.stencil,
			
			push = love.graphics.push,
			pop = love.graphics.pop,
			translate = love.graphics.translate,
			scale = love.graphics.scale,
			rotate = love.graphics.rotate,
			shear = love.graphics.shear,
			
			getBackgroundColor = love.graphics.getBackgroundColor,
			getBlendMode = love.graphics.getBlendMode,
			getCanvas = love.graphics.getCanvas,
			getColor = love.graphics.getColor,
			getColorMask = love.graphics.getColorMask,
			getDefaultFilter = love.graphics.getDefaultFilter,
			getFont = love.graphics.getFont,
			getLineJoin = love.graphics.getLineJoin,
			getLineStyle = love.graphics.getLineStyle,
			getLineWidth = love.graphics.getLineWidth,
			getPointSize = love.graphics.getPointSize,
			getScissor = love.graphics.getScissor,
			getShader = love.graphics.getShader,
			getStencilTest = love.graphics.getStencilTest,
			
			intersectScissor = love.graphics.intersectScissor,
			reset = love.graphics.reset,
			
			setBackgroundColor = love.graphics.setBackgroundColor,
			setBlendMode = love.graphics.setBlendMode,
			setCanvas = love.graphics.setCanvas,
			setColor = love.graphics.setColor,
			setColorMask = love.graphics.setColorMask,
			setDefaultFilter = love.graphics.setDefaultFilter,
			setFont = love.graphics.setFont,
			setLineJoin = love.graphics.setLineJoin,
			setLineStyle = love.graphics.setLineStyle,
			setLineWidth = love.graphics.setLineWidth,
			setPointSize = love.graphics.setPointSize,
			setScissor = love.graphics.setScissor,
			setShader = love.graphics.setShader,
			setStencilTest = love.graphics.setStencilTest,
			
			getDimensions = love.graphics.getDimensions,
			getHeight = love.graphics.getHeight,
			getWidth = love.graphics.getWidth,
		},
		
		sound = {
			newSource = function(snd)
				return love.audio.newSource(dir.."/sounds/"..snd, "static")
			end,
			play = function(source)
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
	env.require = function(from) return setfenv(love.filesystem.load(dir.."/"..from..".lua"),env)() end
	return env
end