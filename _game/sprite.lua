sprite = {
	type = "charecter",
	name = "jhony deep"
}

sprite.pos = vector2:new(1,1)

function sprite:new(this)
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

function sprite:draw()
	local bx, by = map.pos.x-math.ceil(map.pos.x),map.pos.y-math.ceil(map.pos.y)
	love.graphics.setColor(255,255,0)
	love.graphics.rectangle("fill",(self.pos.x+map.pos.x)*map.s,(self.pos.y+map.pos.y)*map.s,map.s,map.s,map.s)
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("line",(self.pos.x+map.pos.x)*map.s,(self.pos.y+map.pos.y)*map.s,map.s,map.s,map.s)
end

playerSprite = sprite:new({path = {}})
playerSprite.Bpos = vector2:new(0,0)

function playerSprite:draw()
	local bx, by = map.pos.x-math.ceil(map.pos.x),map.pos.y-math.ceil(map.pos.y)
	love.graphics.setColor(255,255,0)
	love.graphics.rectangle("fill",(self.pos.x+self.Bpos.x+map.pos.x)*map.s,(self.pos.y+self.Bpos.y+map.pos.y)*map.s,map.s,map.s,map.s)
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("line",(self.pos.x+self.Bpos.x+map.pos.x)*map.s,(self.pos.y+self.Bpos.y+map.pos.y)*map.s,map.s,map.s,map.s)
end

function playerSprite:update(dt)
	if #self.path > 0 then
		local x,y = self.pos.x,self.pos.y
		local x2,y2 = self.path[#self.path].x,self.path[#self.path].y
		local t = (20-math.floor(math.sqrt((x-x2)^2+(y-y2)^2)*10))/2
		self.Bpos.x = self.Bpos.x + (math.lerp(x,x2,dt*t) - x)
		self.Bpos.y = self.Bpos.y + (math.lerp(y,y2,dt*t) - y)
		local bx, by = self.Bpos.x,self.Bpos.y
		if ((self.Bpos.y + y >= y2 and y - y2 <= 0) or (self.Bpos.y + y <= y2 and y - y2 >= 0)) and ((self.Bpos.x + x >= x2 and x - x2 <= 0) or (self.Bpos.x + x <= x2 and x - x2 >= 0)) then
			self.pos = self.path[#self.path]
			self.Bpos = vector2:new(0,0)
			table.remove(self.path,#self.path)
		end
	else
		if self.target then
			self.target:func()
			self.target = nil
		end
		if love.keyboard.isDown("w","up") and map:tileWalkeble(self.pos.x,self.pos.y-1) then
			self.path[1] = vector2:new(self.pos.x,self.pos.y-1)
		end
		if love.keyboard.isDown("s","down") and map:tileWalkeble(self.pos.x,self.pos.y+1) then
			self.path[1] = vector2:new(self.pos.x,self.pos.y+1)
		end
		if love.keyboard.isDown("d","right") and map:tileWalkeble(self.pos.x+1,self.pos.y) then
			self.path[1] = vector2:new(self.pos.x+1,self.pos.y)
		end
		if love.keyboard.isDown("a","left") and map:tileWalkeble(self.pos.x-1,self.pos.y) then
			self.path[1] = vector2:new(self.pos.x-1,self.pos.y)
		end
	end
end

function playerSprite:mousepressed()
	
	self.target = nil
end

function playerSprite:mousereleased()
	if map:tileWalkeble(mouse.tile.x,mouse.tile.y) then
		local path = self:pathfind(self.pos,mouse.tile,map)
		if #self.path > 0 then
			path[#path+1] = self.path[#path]
		end
		self.path = path
	end
	if map.peopleMap[mouse.tile.x] and map.peopleMap[mouse.tile.x][mouse.tile.y] then
		self.target = map.peopleMap[mouse.tile.x][mouse.tile.y]
		map.peopleMap[mouse.tile.x][mouse.tile.y] = nil
		local path = self:pathfind(self.pos,mouse.tile,map)
		table.remove(path,1)
		if #self.path > 0 then
			path[#path+1] = self.path[#path]
		end
		self.path = path
		map.peopleMap[mouse.tile.x][mouse.tile.y] = self.target
	end
end

function playerSprite:pathfind(start,target,map)
	local open = {}
	local closed = {}
	open[start.x.."_"..start.y] = start:new()
	open[start.x.."_"..start.y].g = 0 --dist from start
	open[start.x.."_"..start.y].h = math.floor(math.sqrt((start.x-target.x)^2+(start.y-target.y)^2)*10) --dist from end
	open[start.x.."_"..start.y].f = open[start.x.."_"..start.y].h --G+H
	local current = nil
	while true do
		for n in pairs(open) do
			if not current or current.f > open[n].f then
				current = open[n]
			end
		end
		if not current or closed[target.x.."_"..target.y] then
			break
		end
		open[current.x.."_"..current.y] = nil
		closed[current.x.."_"..current.y] = current
		local n = {}
		for x = current.x-1,current.x+1 do
			for y = current.y-1,current.y+1 do
				if x ~= current.x and  y ~= current.y and map:tileWalkeble(x,current.y) and map:tileWalkeble(current.x,y) then
					n[#n+1] = vector2:new(x,y) 
					n[#n].g = current.g + 14
					n[#n].h = math.floor(math.sqrt((x-target.x)^2+(y-target.y)^2)*10)
					n[#n].f = n[#n].g + n[#n].h
					n[#n].p = current
				elseif (x ~= current.x and y == current.y) or (x == current.x and  y ~= current.y) then
					n[#n+1] = vector2:new(x,y)
					n[#n].g = current.g + 10
					n[#n].h = math.floor(math.sqrt((x-target.x)^2+(y-target.y)^2)*10)
					n[#n].f = n[#n].g + n[#n].h
					n[#n].p = current
				end
			end
		end
		for i = 1,#n do
			if not closed[n[i].x.."_"..n[i].y] and map:tileWalkeble(n[i].x,n[i].y) then
				if not open[n[i].x.."_"..n[i].y] or open[n[i].x.."_"..n[i].y].f > n[i].f then
					open[n[i].x.."_"..n[i].y] = n[i]
				end
			end
		end
		n = nil
		current = nil
	end
	local path = {}
	if closed[target.x.."_"..target.y] then
		path[1] = closed[target.x.."_"..target.y]
		while path[#path].g ~= 0 do
			path[#path+1] = path[#path].p
		end
	else
		path[1] = start[start.x.."_"..start.y]
	end
	return path,closed,open
end

npcSprite = sprite:new({name = "goblin"})

function npcSprite:func()
	combat.load(playerSprite,self)
	window = "combat"
end