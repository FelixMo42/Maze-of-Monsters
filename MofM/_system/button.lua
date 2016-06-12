button = {
	x,y = 10,10,
	h,w = 80,260,
	e = 10,
	color = {255,255,255},
	textColor = {000,000,000},
	text = "PLAY"
}

function button:new(this)
	this = this or {}
	for k in pairs(self) do
		if type(self[k]) == "table" and not this[k] then
			this[k] = table.copy(self[k])
		end
	end
	setmetatable(this, self)
	self.__index = self
	this:update()
	return this
end

function button:func(self)
	return self.data
end

function button:update()
	if self.rw then
		self.w = love.graphics.getWidth() - self.rw - self.x
	end
	if self.rh then
		self.h = love.graphics.getHeight() - self.rh - self.y
	end 
	if self.rx then
		self.x = love.graphics.getWidth()- self.rx - self.w
	end
	if self.ry then
		self.y = love.graphics.getHeight() - self.ry - self.h
	end 
end

function button:onPressed()
	if self.x+self.w >= love.mouse.getX() and love.mouse.getX() >= self.x and self.y+self.h >= love.mouse.getY() and love.mouse.getY() >= self.y then
		return self:func(self) or true
	end
	return false
end

function button:draw()
	if self.x+self.w >= love.mouse.getX() and love.mouse.getX() >= self.x and self.y+self.h >= love.mouse.getY() and love.mouse.getY() >= self.y then
		love.graphics.setColor(self.color[1],self.color[2],self.color[3],self.color[4] or 255)
		love.graphics.rectangle("fill",self.x-2,self.y-2,self.w+4,self.h+4,self.e)
		love.graphics.setColor(000,000,000)
		love.graphics.rectangle("line",self.x-2,self.y-2,self.w+4,self.h+4,self.e)
	else
		love.graphics.setColor(self.color[1],self.color[2],self.color[3],self.color[4] or 255)
		love.graphics.rectangle("fill",self.x,self.y,self.w,self.h,self.e)
		love.graphics.setColor(000,000,000)
		love.graphics.rectangle("line",self.x,self.y,self.w,self.h,self.e)
	end
	love.graphics.setColor(self.textColor[1],self.textColor[2],self.textColor[3])
	love.graphics.printf(self.text, self.x, self.y+self.h/2-love.graphics.getFont():getHeight()/2, self.w, "center")
end