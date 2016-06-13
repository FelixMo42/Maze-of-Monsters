tile = {
	name = "grass",
	speed = 1,
	color = {0,255,0},
	data = ""
}

function tile:new(this)
	local this = this or {}
	for k in pairs(self) do
		if type(self[k]) == "table" and not this[k] then
			this[k] = table.copy(self[k])
		elseif not this[k] then
			this[k] = self[k]
		end
	end
	return this
end

function tile:draw(x,y,s)
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill",x*s,y*s,s,s)
	love.graphics.setColor(255,255,255)
	love.graphics.print(self.data,(x*s)+10,(y*s)+10)
end

tiles = {}
tiles.grass = tile:new()
tiles.wall = tile:new({name="wall",speed=0,color={0,100,0}})