--Beatmap class, handles beatmap loading/saving and editing.
local lfs = love.filesystem

Beatmap = class:new()
function Beatmap:init(songdir,beatmapdir)
	self.song = song
	self.data = lfs.isFile(beatmapdir) and LON.decode(lfs.read(beatmapdir))
	self.nodemap = self.data and self.data.nodemap or {}
	self.tagmap = self.data and self.data.tagmap or {}
end

function Beatmap:newNode(a,b)
	table.insert(self.nodemap,{
		count=a,
		id=b,
	})
end

function Beatmap:iterateNodes()
	local i,n=1,#self.nodemap
	return function()
		i=i+1
		if i < n then return self.nodemap[i] end
	end
end