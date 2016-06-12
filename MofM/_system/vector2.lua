vector2 = {
	type = "vector2",
	x,y=0,0,
}

function vector2:new(x,y)
	local this = {x=x or self.x,y=y or self.y}
	setmetatable(this, self)
	self.__index = self
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