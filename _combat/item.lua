item = {
	name = "item",
	type = "item",
	x = 1,y = 1,
	bonuses = {}
}

function item:new(this)
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

function item:draw(this)
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle("fill",self.x,self.y,60,60)
	love.graphics.setColor(0,0,0)
	love.graphics.printf(self.name,self.x,self.y+60/2-love.graphics.getFont():getHeight(),60,"center")
end

weapon = item:new{
	name = "short sword",
	type = "weapon",
	Wtype = "sword",
	Matk = 0,
	atk = 15,
	pos = {x=1,y=1},
	bonuses = {
		speed = 10,
		aim = 5
	}
}

weapons = {}

weapons["shortsword"] = weapon:new()
weapons["longsword"] = weapon:new({name = "long sword",atk = 1000})

armor = item:new{
	name = "leather armour",
	type = "armour",
	bonuses = {
		speed = 10,
		def = 5,
		dodge  = 5
	}	
}

armors = {}

weapons["leatherarmour"] = weapon:new()
armors["ironarmor"] = armor:new({name = "iron armor"})