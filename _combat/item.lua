item = {
	name = "item",
	type = "item",
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

weapon = item:new{
	name = "short sword",
	type = "sword",
	Matk = 0,
	atk = 10,
	bonuses = {
		speed = 10,
		aim = 5
	}
}

armor = item:new{
	name = "leather",
	type = "armour",
	bonuses = {
		speed = 10,
		def = 5,
		dodge  = 5
	}	
}