charecter = {
	level = 1, xp = 0,
	Thp = 100,hp = 100,
	Tmana = 100,mana = 100,
	rewards = {xp = 10},
	ap = 0, sp = 0,
	states = {
		dex = 0,
		str = 0,
		con = 0,
		wil = 0,
		int = 0,
		cha = 0
	},
	skills = {},
	bonuses = {},
	abilities = {
		abilities["skip turn"],
		abilities["retreat"],
		abilities["attack"],
		abilities["defend"],
		abilities["heal"]
	},
	equips = {
		weapon = weapon:new(),
		armor = armor:new(),
		weapons["longsword"]:new(),
		armors["ironarmor"]:new()
	},
}

function charecter:new(this)
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

function charecter:load()
	self.Thp = (self.states.con+1)*25
	self.hp = self.Thp
	self.Tmana = (self.states.wil+1)*25
	self.mana = self.Tmana
end

function charecter:GTS(s,xp,b)
	local t = b or 0
	if self.bonuses[s] then
		t = t + self.bonuses[s].b
	end
	if self.skills[s] then
		t = t + self.skills[s].level
		t = t + self.states[self.skills[s].state]
		self.skills[s]:addXP(xp or 0)
	elseif skills[s] then
		self.skills[s] = skills[s]:new({name=s,xp=xp or 0})
		self.skills[#self.skills+1] = self.skills[s]
	end
	for k in pairs(self.equips) do
		if self.equips[k].bonuses[s] then
			t = t + self.equips[k].bonuses[s]
		end
	end
	return t
end

function charecter:addXP(xp)
	self.xp = self.xp + xp
	repeat
		if self.xp >= 25*2^self.level then
			self.xp = self.xp - (25*2^self.level)
			self.level = self.level + 1
			self.ap = self.ap + 1
			self.sp = self.sp + math.floor(self.level*7.76)
		else
			return
		end
	until true
end

defChar = {}
defChar["goblin"] = charecter:new()