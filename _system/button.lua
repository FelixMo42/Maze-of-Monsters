button = {
	x = 10,y = 10,
	h = 20,w = 100,
	e = 10, s = 2,
	color = {255,255,255},
	textColor = {000,000,000},
	lineColor = {000,000,000},
	text = "PLAY"
}

function button:new(this)
	local this = this or {}
	for k in pairs(self) do
		if type(self[k]) == "table" and not this[k] then
			this[k] = table.copy(self[k])
		elseif not this[k] then
			this[k] = self[k]
		end
	end
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
		love.graphics.setColor(self.color)
		love.graphics.rectangle("fill",self.x-self.s,self.y-self.s,self.w+self.s*2,self.h+self.s*2,self.e)
		love.graphics.setColor(self.lineColor)
		love.graphics.rectangle("line",self.x-self.s,self.y-self.s,self.w+self.s*2,self.h+self.s*2,self.e)
	else
		love.graphics.setColor(self.color)
		love.graphics.rectangle("fill",self.x,self.y,self.w,self.h,self.e)
		love.graphics.setColor(self.lineColor)
		love.graphics.rectangle("line",self.x,self.y,self.w,self.h,self.e)
	end
	love.graphics.setColor(self.textColor)
	love.graphics.printf(self.text, self.x, self.y+self.h/2-love.graphics.getFont():getHeight()/2, self.w, "center")
end

--drop menu

dropMenu = button:new({
	text = "settings",
	droped = false,
	children = {}
})

function dropMenu:draw()
	if self.droped then
		for i = 1,#self.children do
			self.children[i]:draw()
		end
	end
	if self.x+self.w >= love.mouse.getX() and love.mouse.getX() >= self.x and self.y+self.h >= love.mouse.getY() and love.mouse.getY() >= self.y then
		love.graphics.setColor(self.color)
		love.graphics.rectangle("fill",self.x-2,self.y-2,self.w+4,self.h+4,self.e)
		love.graphics.setColor(self.lineColor)
		love.graphics.rectangle("line",self.x-2,self.y-2,self.w+4,self.h+4,self.e)
	else
		love.graphics.setColor(self.color)
		love.graphics.rectangle("fill",self.x,self.y,self.w,self.h,self.e)
		love.graphics.setColor(self.lineColor)
		love.graphics.rectangle("line",self.x,self.y,self.w,self.h,self.e)
	end
	love.graphics.setColor(self.textColor)
	love.graphics.printf(self.text, self.x, self.y+self.h/2-love.graphics.getFont():getHeight()/2, self.w, "center")
end

function dropMenu:onPressed()
	local t = false
	if self.x+self.w >= love.mouse.getX() and love.mouse.getX() >= self.x and self.y+self.h >= love.mouse.getY() and love.mouse.getY() >= self.y then
		self.droped = not self.droped
		t = true
	end
	if self.droped then
		for i = 1,#self.children do
			t = t or self.children[i]:onPressed()
		end
	end
	return t
end

function dropMenu:update()
	if self.droped then
		for i = 1,#self.children do
			self.children[i]:update()
		end
	end
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