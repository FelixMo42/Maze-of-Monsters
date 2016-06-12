charecter = {
	Thp = 100,
	hp = 100,
	mana = 100,
	states = {
		dex = 0,
		str = 0,
		con = 0,
		wis = 0,
		int = 0,
		cha = 0
	},
	skills = {},
	bonuses = {},
	abilities = {
		abilities["skip turn"],
		abilities["attack"],
		abilities["defend"],
		abilities["heal"]
	},
	equips = {
		weapon = weapon:new(),
		armor = armor:new()
	},
}

function charecter:new(this)
	local this = this or {}
	for k in pairs(self) do
		if type(self[k]) == "table" and not this[k] then
			this[k] = table.copy(self[k])
		end
	end
	setmetatable(this, self)
	self.__index = self
	return this
end

function charecter:GTS(s, b)
	local t = b or 0
	if self.bonuses[s] then
		t = t + self.bonuses[s].b
	end
	if self.skills[s] then
		t = t + self.skills[s].level
		t = t + self.states[self.skills[s].state]
	elseif skills[s] then
		self.skills[s] = skills[s]:new{name=s,xp=10}
	end
	for k in pairs(self.equips) do
		if self.equips[k].bonuses[s] then
			t = t + self.equips[k].bonuses[s]
		end
	end
	return t
end

defChar = {}