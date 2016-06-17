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
		p[i]:load()
	end
	combat.ui = {}
	combat.line = 150
	for i = 1,#p[1].abilities do
		combat.ui[#combat.ui+1] = button:new{
			y = (i-1) * 20, rx = 0,
			h = 20, w = 100,
			e = 0,
			data = p[1].abilities[i],
			text = p[1].abilities[i].name
		}
	end
	for i = 1,#p do
		combat.ui[#combat.ui+1] = button:new({
			x = (i-0.65) * 300, ry = combat.line-75,
			w = 100, h = 200,
			data = i,
			text = p[i].name
		})
	end
end

function combat.draw()
	love.graphics.setColor(0,255,0)
	love.graphics.rectangle("fill",0,height-combat.line,width,combat.line)
	love.graphics.setColor(0,0,255)
	love.graphics.rectangle("fill",0,0,width,height-combat.line)
	for i = 1,#combat.ui do
		combat.ui[i]:draw()
	end
	local m = 55
	love.graphics.setLineWidth(5)
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle("fill",-10,-10,140,#p*m+32,10)
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("line",-8,-10,140,#p*m+32,10)
	love.graphics.setLineWidth(2)
	for i = 1,#p do
		love.graphics.setColor(0,0,0)
		love.graphics.print(p[i].name..": ",10,(i-1)*m+10)
		love.graphics.setColor(185,0,0)
		love.graphics.rectangle("fill",10,(i-1)*m+10+17,110,17+17)
		love.graphics.setColor(255,0,0)
		love.graphics.rectangle("fill",12,(i-1)*m+12+17,math.min((p[i].hp/p[i].Thp),1)*106,13)
		love.graphics.setColor(0,0,255)
		love.graphics.rectangle("fill",12,(i-1)*m+12+(17*2),math.min((p[i].mana/p[i].Tmana),1)*106,13)
		love.graphics.setColor(255,255,255)
		love.graphics.print("HP: "..p[i].hp.."/"..p[i].Thp,14,(i-1)*m+10+19)
		love.graphics.print("mana: "..p[i].mana.."/"..p[i].Tmana,14,(i-1)*m+10+19+17)
	end
	love.graphics.setLineWidth(1)
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
		if p[1].act.RT then
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
		end
	--get enemy move
		for i = 2,#p do
			p[i].act = abilities.attack
			p[i].act.p = p[i]
			p[i].act.t = p[1]
			--[[
			if p[i].hp <= 30 and p[i].mana >= 10 then
				p[i].act = abilities.heal
				p[i].act.p = p[i]
				p[i].act.t = p[i]
			else
				p[i].act = abilities.attack
				p[i].act.p = p[i]
				p[i].act.t = p[1]
			end
			]]
		end
	--use moves
		local pl = {p[1]}
		for i = 2,#p do
			for l = #pl,1,-1 do
				if p[i].act.speed-p[i]:GTS("speed") < pl[l].act.speed-pl[l]:GTS("speed") then
					table.insert(pl,l,p[i])
					break
				end
				if l == 1 then
					pl[#pl+1] = p[i]
				end
			end
		end
		for i = 1,#pl do
			if pl[i].mana >= pl[i].act.mana then
				pl[i].act.func(pl[i].act.p,pl[i].act.t)
				pl[i].mana = pl[i].mana - pl[i].act.mana
			end
			if pl[i].act.t.hp <= 0 then
				pl[i]:addXP(pl[i].act.t.rewards.xp)
			end
			pl[i].act.t = nil
		end
	--next turn
		turn = turn + 1
		for i in pairs(p) do
			for k in pairs(p[i].bonuses) do
				p[i].bonuses[k].t = p[i].bonuses[k].t - 1
				if p[i].bonuses[k].t <= 0 then
					p[i].bonuses[k] = nil
				end
			end
			if p[i].hp <= 0 then
				table.remove(p,i)
			end	
		end
		if #p <= 1 then
			window = "game"
		end
end

function combat.resize(w,h)
	for i = 1,#combat.ui do
		combat.ui[i]:update()
	end
end