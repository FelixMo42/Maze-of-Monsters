abilitie = {
	name = "",
	RT = true,
	type = "abilitie",
	mana = 0,
	speed = 50,
	func = function() end
}

function abilitie:new(this)
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

abilities = {}
	abilities["skip turn"] = abilitie:new({name = "skip turn", RT = false, speed = 0})
	abilities["retreat"] = abilitie:new({name="retreat", RT = false, speed = 0})
	abilities["retreat"].func = function() window = "game" end
	abilities["attack"] = abilitie:new({name="attack"})
	abilities["attack"].func = function(p,t)
		local p = p or player[math.floor(turn/2)*2-turn+2]
		local t = t or player[math.loop(math.floor(turn/2)*2-turn+1,2)]
		local n = love.math.random(100)
		local a = math.max(p:GTS(p.equips.weapon.Wtype,10) + p.equips.weapon.atk - t:GTS("def",5),0)
		local d = t:GTS("dodge",5) - p:GTS("aim",5)
		if n >= 95 then
			t.hp = t.hp - a
		end
		if n - d >= 100/3 then
			t.hp = t.hp - a
		end
	end
	abilities["defend"] = abilitie:new({name = "defend", speed = 25})
	abilities["defend"].func = function(p,t)
		local p = p or player[math.floor(turn/2)*2-turn+2]
		local t = t or player[math.floor(turn/2)*2-turn+2]
		t.bonuses["def"] = {t = 1, b = 10}
		t.skills.def:addXP(10)
	end
	abilities["dodge"] = abilitie:new({name = "dodge", speed = 25})
	abilities["dodge"].func = function(p,t)
		love.event.quit()
		local p = p or player[math.floor(turn/2)*2-turn+2]
		local t = t or player[math.floor(turn/2)*2-turn+2]
		t.bonuses["dodge"] = {t = 1, b = 10}
		t.skills.def:addXP(10)
	end
	abilities["heal"] = abilitie:new({name = "heal", speed = 25, mana = 10})
	abilities["heal"].func = function(p,t)
		local p = p or player[math.floor(turn/2)*2-turn+2]
		local t = t or player[math.floor(turn/2)*2-turn+2]
		t.hp = t.hp + 10 + p:GTS("healing",10)
	end
	abilities["fire blast"] = abilitie:new({name = "fire blast", mana = 20})
	abilities["fire blast"].func = function(p,t)
		local p = p or player[math.floor(turn/2)*2-turn+2]
		local t = t or player[math.loop(math.floor(turn/2)*2-turn+1,2)]
		local n = love.math.random(100)
		local a = math.max(p:GTS("pyromancy",10) + self.equips.Matk - t:GTS("def",5),0)
		local d = t:GTS("dodge",5) - p:GTS("aim",5)
		if n >= 95 then
			t.hp = t.hp - a
		end
		if n - d >= 100/3 then
			t.hp = t.hp - a
		end
	end
	abilities["power slash"] = abilitie:new({name = "power slash", mana = 10})
	abilities["power slash"].func = function(p,t)
		local p = p or player[math.floor(turn/2)*2-turn+2]
		local t = t or player[math.loop(math.floor(turn/2)*2-turn+1,2)]
		local n = love.math.random(100)
		local a = math.max(p:GTS(p.equips.weapon.Wtype,10) + p.equips.weapon.atk - t:GTS("def",5),0)
		local d = t:GTS("dodge",5) - p:GTS("aim",5)
		if n >= 95 then
			t.hp = t.hp - a
		end
		if n - d >= 100/3 then
			t.hp = t.hp - a * 2
		end
	end
	abilities["quick draw"] = abilitie:new({name = "quick draw", mana = 10, speed = 25})
	abilities["quick draw"].func = abilities["attack"].func
	abilities["armour pircing strick"] = abilitie:new({name = "armour pircing strick", mana = 10, speed = 60})
	abilities["armour pircing strick"].func = function(p,t)
		local p = p or player[math.floor(turn/2)*2-turn+2]
		local t = t or player[math.loop(math.floor(turn/2)*2-turn+1,2)]
		local n = love.math.random(100)
		t:GTS("def",5)
		local a = math.max(p:GTS(p.equips.weapon.Wtype,10) + p.equips.weapon.atk - t.def.level - t.states.con,0)
		local d = t:GTS("dodge",5) - p:GTS("aim",5)
		if n >= 95 then
			t.hp = t.hp - a
		end
		if n - d >= 100/3 then
			t.hp = t.hp - a * 1.25
		end
	end

skill = {
	name = "basic",
	state = "dex",
	level = 1, xp = 0,
	gotten = false,
	type = "skill",
	abilities = {}
}

function skill:add(this)
	local this = this or {}
	for k in pairs(self) do
		if not this[k] then
			this[k] = self[k]
		end
	end
	return this
end

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
	skills["sword"].abilities[1] = {a = abilities["power slash"], r = 1}
	skills["sword"].abilities[2] = {a = abilities["quick draw"], r = 2}
	skills["sword"].abilities[3] = {a = abilities["armour pircing strick"], r = 3}
skills["speed"] = skill:new({state="dex",name="speed"})
skills["dodge"] = skill:new({state="dex",name="dodge"})
skills["aim"] = skill:new({state="dex",name="aim"})
skills["def"] = skill:new({state="con",name="def"})
skills["healing"] = skill:new({state="wis",name="healing"})
skills["pyromancy"] = skill:new({state="int",name="pyromancy"})