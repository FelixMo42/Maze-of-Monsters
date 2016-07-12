--console
	console = {"log started"}
		console.x = 590
		console.y = 10
		console.w = 200
		console.h = 580

	function console.log(text)
		console[#console+1] = text or "no text"
	end

	function console:draw()
		local b = 5
		love.graphics.setColor(100,100,100,100)
		love.graphics.rectangle("fill",console.x, console.y, console.w, console.h)
		love.graphics.setColor(255,255,255)
		for i = 1,#console do
			love.graphics.printf("- "..console[i],console.x+5,console.y+b+(i-1)*(love.graphics.getFont():getHeight()+5),console.w-5)
			b = b + math.floor(love.graphics.getFont():getWidth(console[i])/console.w)*love.graphics.getFont():getHeight()
		end
	end

--table
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

--math
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

--vector2

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