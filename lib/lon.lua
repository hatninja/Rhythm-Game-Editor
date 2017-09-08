--Makeshift lon library!
local lfs = love.filesystem
local lon = {}

function lon.decode(dir)
	local content = lfs.read(dir)
	local code = loadstring("return"..content)
	setfenv(code, {})
	return code()
end

function lon.encode(dir)
end

return lon