skill = {
	name = "basic",
	state = "dex",
	level = 0,
	xp = 0,
	type = "skill",
	abilities = {}
}

function skill:new(this)
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

function skill:addXP(xp)
	self.xp = self.xp + xp
	repeat
		if self.xp >= 25*2^self.level then
			self.xp = self.xp - (25*2^self.level)
			self.level = self.level + 1
		else
			return
		end
	until true
end

skills = {}
	skills["sword"] = skill:new({state="str",name="sword"})
	skills["speed"] = skill:new({state="dex",name="speed"})
	skills["dodge"] = skill:new({state="dex",name="dodge"})
	skills["aim"] = skill:new({state="dex",name="aim"})
	skills["def"] = skill:new({state="con",name="def"})
	skills["healing"] = skill:new({state="wis",name="healing"})
	skills["pyromancy"] = skill:new({state="int",name="pyromancy"})

abilitie = {
	name = "",
	type = "abilitie",
	mana = 0,
	speed = 50,
	func = function() end
}

function abilitie:new(this)
	local this = this or {}
	this.bonuses = {}
	setmetatable(this, self)
	self.__index = self
	return this
end

abilities = {}
	abilities["attack"] = abilitie:new({name="attack"})
	abilities["attack"].func = function(p,t)
		local p = p or player[math.floor(turn/2)*2-turn+2]
		local t = t or player[math.loop(math.floor(turn/2)*2-turn+1,2)]
		local n = math.random(100)
		local a = math.max(p:GTS(p.equips.weapon.type) + p.equips.weapon.atk - t:GTS("def"),0)
		local d = t:GTS("dodge") - p:GTS("aim")
		if n >= 95 then
			t.hp = t.hp - a
		end
		if n - d >= 100/3 then
			t.hp = t.hp - a
		end
	end
	abilities["skip turn"] = abilitie:new({name = "skip turn", speed = 0})
	abilities["defend"] = abilitie:new({name = "defend", speed = 25})
	abilities["defend"].func = function(p,t)
		local p = p or player[math.floor(turn/2)*2-turn+2]
		local t = t or player[math.floor(turn/2)*2-turn+2]
		t.bonuses["def"] = {t = 1, b = 10}
	end
	abilities["dodge"] = abilitie:new({name = "dodge", speed = 25})
	abilities["dodge"].func = function(p,t)
		love.event.quit()
		local p = p or player[math.floor(turn/2)*2-turn+2]
		local t = t or player[math.floor(turn/2)*2-turn+2]
		t.bonuses["dodge"] = {t = 1, b = 10}
	end
	abilities["heal"] = abilitie:new({name = "heal", speed = 25, mana = 10})
	abilities["heal"].func = function(p,t)
		local p = p or player[math.floor(turn/2)*2-turn+2]
		local t = t or player[math.floor(turn/2)*2-turn+2]
		t.hp = t.hp + 10 + p:GTS("healing")
	end
	abilities["fire blast"] = abilitie:new({name = "fire blast", mana = 20})
	abilities["fire blast"].func = function(p,t)
		local p = p or player[math.floor(turn/2)*2-turn+2]
		local t = t or player[math.loop(math.floor(turn/2)*2-turn+1,2)]
		local n = math.random(100)
		local a = math.max(p:GTS("pyromancy") + self.equips.Matk - t:GTS("def"),0)
		local d = t:GTS("dodge") - p:GTS("aim")
		if n >= 95 then
			t.hp = t.hp - a
		end
		if n - d >= 100/3 then
			t.hp = t.hp - a
		end
	end 