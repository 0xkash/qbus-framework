QBShared = {}

QBShared.Debug = function(obj, depth)

		if type(obj) == "string" then
			-- Dump the string so that escape sequences are printed.
			return string.format("%q", obj)
		elseif type(obj) == "table" and depth < max_depth and not coerceable(obj) then
			local str = "{"
			
			for k, v in pairs(obj) do
				local pair = pretty(k, 0).." = "..recurse(v, depth + 1)
				str = str..(str == "{" and pair or ", "..pair)
			end
			
			return str.."}"
		else
			-- tostring() can fail if there is an error in a __tostring metamethod.
			local success, value = pcall(function() return tostring(obj) end)
			return (success and value or "<!!error in __tostring metamethod!!>")
		end

	end