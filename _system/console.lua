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

--extra functions

function table.removeValue(t, v)
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

function table.contains(t, e)
	for k, value in pairs(t) do
		if value == e then
			return true,k
		end
	end
	return false
end

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