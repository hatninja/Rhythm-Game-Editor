local LON = {}

function LON.encode(t)
	local s = "{"
	local prev = 0 --Testing for sequence breaks
	for i,v in ipairs(t) do
		if type(v) ~= "function" and type(v) ~= "userdata" then
			local data = tostring(v)
			if type(v) == "table" then data = LON.encode(v) end
			if type(v) == "string" then data = '[['..data..']]' end
			
			if i-1 == prev then
				s=s..data..","
				prev = i
			else
				s=s.."["..i.."]="..data..","
			end
		end
	end
	for k,v in pairs(t) do
		if type(k) == "string" and type(v) ~= "function" and type(v) ~= "userdata" then
			local data = tostring(v)
			if type(v) == "table" then data = LON.encode(v) end
			if type(v) == "string" then data = '[['..data..']]' end
		
			s=s..k.."="..data..","
		end
	end
	s=s:gsub(",}","}")
	return s.."}"
end

function LON.decode(s)
	return load("return"..s)()
end

return LON