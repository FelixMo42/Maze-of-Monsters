map = {
	people = {},
	peopleMap = {},
	s = 60
}

map.pos = vector2:new(-1,-1)

for x = 1,10 do
	map[x] = {}
	for y = 1,10 do
		map[x][y] = tile
	end
end

function map:new(this)
	local this = this or {}
	for k in pairs(self) do
		if type(self[k]) == "table" and not this[k] then
			this[k] = table.copy(self[k])
		elseif not this[k] then
			this[k] = self[k]
		end
	end
	map:creatPeopleMap()
	return this
end

function map:draw()
	--draw tiles
		for x = math.floor(-self.pos.x), math.ceil(-self.pos.x) + love.graphics.getWidth()/self.s do
			x = x<1 and 1 or x
			if x>#self then break end
			for y = math.floor(-self.pos.y), math.ceil(-self.pos.y) + love.graphics.getHeight()/self.s  do
				y = y<1 and 1 or y
				if y>#self[x] then break end
				self[x][y]:draw(x+self.pos.x,y+self.pos.y,self.s)
			end
		end
	--draw lines
		love.graphics.setColor(000,000,000)
		local bx, by = self.pos.x-math.ceil(self.pos.x),self.pos.y-math.ceil(self.pos.y)
		for x = 0,love.graphics.getWidth()/self.s+1 do
			for y = 0,love.graphics.getHeight()/self.s+1 do
				love.graphics.rectangle("line",(x+bx)*self.s,(y+by)*self.s,self.s,self.s)
			end
		end
	--selecter
		love.graphics.setColor(0,0,255,100)
		local bx, by = map.pos.x-math.floor(map.pos.x),map.pos.y-math.floor(map.pos.y)
		love.graphics.rectangle("fill",(map.pos.x+mouse.tile.x)*map.s,(map.pos.y+mouse.tile.y)*map.s,map.s,map.s)
	--player
		for x = math.floor(-self.pos.x), math.ceil(-self.pos.x) + love.graphics.getWidth()/self.s do
			x = x<1 and 1 or x
			if x>#self then break end
			for y = math.floor(-self.pos.y), math.ceil(-self.pos.y) + love.graphics.getHeight()/self.s  do
				y = y<1 and 1 or y
				if y>#self[x] then break end
				if self.peopleMap[x] and self.peopleMap[x][y] then
					self.peopleMap[x][y]:draw()
				end
			end
		end
end

function map:mousemoved(x,y,dx,dy)
	if love.mouse.isDown(1, 3) then
		if map.pos.x + (dx/map.s) >= -1 then
			map.pos.x = map.pos.x + (dx/map.s)
		end
		if map.pos.y + (dy/map.s) >= -1 then
			map.pos.y = map.pos.y + (dy/map.s)
		end
	end
end

function map:wheelmoved(x,y)
	-- should I zoom?
	if map.s + y > 10 and map.s + y < 200 then
		-- translate screen to keep the same center
		map.pos.x = map.pos.x - ((width/map.s)-(width/(map.s+y)))/2
		map.pos.y = map.pos.y - ((height/map.s)-(height/(map.s+y)))/2
		-- zoom
		map.s = map.s + y
		-- update mouse position
		mouse.x = math.floor(love.mouse.getX()/map.s+map.pos.x)
		mouse.y = math.floor(love.mouse.getY()/map.s+map.pos.y)
	end
end

function map:exist(x,y)
	if map[x] and map[x][y] then
		return true
	end
	return false
end

function map:creatPeopleMap()
	self.peopleMap = {}
	for i = 1,#self.people do
		if not self.peopleMap[self.people[i].pos.x] then
			self.peopleMap[self.people[i].pos.x] = {}
		end
		if not self.peopleMap[self.people[i].pos.x][self.people[i].pos.y] then
			self.peopleMap[self.people[i].pos.x][self.people[i].pos.y] = {}
		end
		self.peopleMap[self.people[i].pos.x][self.people[i].pos.y] = self.people[i]
	end
end

function map:tileWalkeble(x,y)
	if self:exist(x,y) and map[x][y].speed > 0 and not (map.peopleMap[x] and map.peopleMap[x][y]) then
		return true
	end
	return false
end

function map.people.__newindex(a,b,c)
	if not map.peopleMap[c.pos.x] then
		map.peopleMap[c.pos.x] = {}
	end
	map.peopleMap[c.pos.x][c.pos.y] = c
end