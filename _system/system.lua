system = {}

function system.loadTable()
	function table.removeValue(t,v)
		for i = 1,#t do
			if t[i] == v then
				table.remove(t,i)
			end 
		end
	end

	function table.copy(object)
	    local lookup_table = {}
	    local function _copy(object)
	        if type(object) ~= "table" then
	            return object
	        elseif lookup_table[object] then
	            return lookup_table[object]
	        end
	        local new_table = {}
	        lookup_table[object] = new_table
	        for index, value in pairs(object) do
	            new_table[_copy(index)] = _copy(value)
	        end
	        return setmetatable(new_table, getmetatable(object))
	    end
	    return _copy(object)
	end

	function table.contains(t,e)
		for k, value in pairs(t) do
			if value == e then
				return true,k
			end
		end
		return false
	end
end

function system.loadMath()
	function math.sign(n) return n>0 and 1 or n<0 and -1 or 0 end

	function math.lerp(a,b,t) return (1-t)*a + t*b end

	function math.loop(v,m)
		repeat
			v = v - m
		until v <= m 
		repeat
			v = m + v
		until v >= 1
		return v
	end
end

function system.loadVector2()
	vector2 = {
		type = "vector2",
		x,y=0,0,
	}

	function vector2:new(x,y)
		local this = {x=x,y=y}
		for k in pairs(self) do
			if type(self[k]) == "table" and not this[k] then
				this[k] = table.copy(self[k])
			elseif not this[k] then
				this[k] = self[k]
			end
		end
		return this
	end

	function vector2.__add(a,b)
		local vec = {}
		if type(b) ~= "number" and b.type == "vector2" then
			vec = {x=a.x+b.x,y=a.y+b.y}
		else
			vec = {x=a.x+b,y=a.y+b}
		end
		return vector2:new(vec.x,vec.y)
	end

	function vector2.__sub(a,b)
		local vec = {}
		if type(b) ~= "number" and b.type == "vector2" then
			vec = {x=a.x-b.x,y=a.y-b.y}
		else
			vec = {x=a.x-b,y=a.y-b}
		end
		return vector2:new(vec.x,vec.y)
	end

	function vector2.__mul(a,b)
		local vec = {}
		if type(b) ~= "number" and b.type == "vector2" then
			vec = {x=a.x*b.x,y=a.y*b.y}
		else
			vec = {x=a.x*b,y=a.y*b}
		end
		return vector2:new(vec.x,vec.y)
	end

	function vector2.__div(a,b)
		local vec = {}
		if type(b) ~= "number" and b.type == "vector2" then
			vec = {x=a.x/b.x,y=b.y/b.y}
		else
			vec = {x=a.x/b,y=a.y/b}
		end
		return vector2:new(vec.x,vec.y)
	end

	function vector2.__pow(a,b)
		local vec = {}
		if type(b) ~= "number" and b.type == "vector2" then
			vec = {x=a.x^b.x,y=b.y^b.y}
		else
			vec = {x=a.x^b,y=a.y^b}
		end
		return vector2:new(vec.x,vec.y)
	end

	function vector2.__eq(a,b)
		local vec = {}
		if type(b) ~= "number" and b.type == "vector2" then
			if a.x == b.x and a.y == b.y then
				return true
			end
			return false 
		end
	end

	function vector2.__unm(a)
		return vector2:new(-a.x,-a.y)
	end
end

function system.loadString()
	function string.lines(str)
		local t = {}
		local function helper(line) table.insert(t, line) return "" end
		helper((str:gsub("(.-)\r?\n", helper)))
		return t
	end
end

system.loadTable()
system.loadMath()
system.loadVector2()
system.loadString()