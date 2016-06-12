require("_combat/item")
require("_combat/skill")
require("_combat/charecter")

combat = {}

function combat.load(...)
	p = {}
	turn = 1
	for i = 1,select('#',...) do
		p[i] = select(i,...)
		if defChar[p[i].name] then
			p[i] = defChar[p[i].name]:new(p[i])
		else
			p[i] = charecter:new(p[i])
		end
	end
	combat.ui = {}
	combat.state = {"hp","mana"}
	for i = 1,#p[1].abilities do
		combat.ui[#combat.ui+1] = button:new{
			y = (i-1) * 20,
			rx = 0,
			h = 20,
			w = 100,
			e = 0,
			text = p[1].abilities[i].name,
			data = p[1].abilities[i]
		}
	end
	for i = 1,#p do
		combat.ui[#combat.ui+1] = button:new({
			x = i * 200,
			y = 300,
			w = 100,
			h = 100,
			e = 100,
			data = i,
			text = p[i].name
		})
	end
end

function combat.draw()
	for i = 1,#combat.ui do
		combat.ui[i]:draw()
	end
	love.graphics.setColor(255,255,255)
	for i = 1,#combat.state do
		love.graphics.print(combat.state[i]..": "..p[1][combat.state[i]].." / "..p[2][combat.state[i]],0,(i-1)*15)
	end
	if p[1].act then
		love.graphics.print(p[1].act.name,0,30)
	end
end

function combat.mousepressed()
	--get move
		for i = 1,#combat.ui do
			if type(combat.ui[i]:onPressed()) == "table" then
				p[1].act = combat.ui[i]:onPressed()
			else 
				p[1].act = nil or p[1].act
			end
		end
		if p[1].act == nil or p[1].act.mana > p[1].mana then
			p[1].act = nil
			do return end
		end
	--get target
		for i = 1,#combat.ui do
			p[1].act.t = combat.ui[i]:onPressed()
			if type(p[1].act.t) == "number" then
				break
			else
				p[1].act.t = nil
			end
		end
		if p[1].act.t == nil then
			do return end
		end
		p[1].act.t = p[p[1].act.t]
		p[1].act.p = p[1]
	--get enemy move
		for i = 2,#p do
			if p[i].hp <= 30 and p[i].mana >= 10 then
				p[i].act = abilities.heal
				p[i].act.p = p[i]
				p[i].act.t = p[i]
			else
				p[i].act = abilities.attack
				p[i].act.p = p[i]
				p[i].act.t = p[1]
			end
		end
	--use moves
		local pl = {p[1]}
		for i = 2,#p do
			for l = #pl,1,-1 do
				if p[i].act.speed-p[i]:GTS("speed") < pl[l].act.speed-pl[l]:GTS("speed") then
					table.insert(pl[i],l)
				end
			end
		end
		for i = 1,#pl do
			if pl[i].mana >= pl[i].act.mana then
				pl[i].act.func(pl[i].act.p,pl[i].act.t)
				pl[i].mana = pl[i].mana - pl[i].act.mana
			end
			pl[i].act.t = nil
		end
	--next turn
		turn = turn + 1
		for i = 1,#p do
			for k in pairs(p[i].bonuses) do
				p[i].bonuses[k].t = p[i].bonuses[k].t - 1
				if p[i].bonuses[k].t <= 0 then
					p[i].bonuses[k] = nil
				end
			end
			if p[i].hp <= 0 then
				window = "game"
			end
		end
end