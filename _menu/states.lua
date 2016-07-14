menu.states = {}
menu.states.selected = "sword"
menu.states.ap = 1

function menu.states.draw()
	local text = ""
	local p = playerSprite
	love.graphics.setColor(255,255,255)
	text = text..p.name.." -- level: "..p.level.." -- ".."xp: "..p.xp.."/"..25*2^p.level.." -- ability points: "..p.ap
	text = text.."\n\n------------ states ------------\n"
	text = text.."state points: "..p.sp.."\n"
	local i,y,x = 1,105,25
	for k in pairs(p.states) do
		text = text..k.." "..p.states[k].."  "
		if mouse.pos.x >= x and mouse.pos.x <= x + f12:getWidth(k.."   "..p.states[k]) and mouse.pos.y >= y and mouse.pos.y <= y + 13 then
			love.graphics.rectangle("line",x,y,f12:getWidth(k.."   "..p.states[k]),14)
		end
		x = x + f12:getWidth(k.."   "..p.states[k]) + 2
		if math.floor(i/2) == i/2 then
			text = text.."\n"
			x,y = 25,y + 14
		end
		i = i + 1
	end
	text = text.."\n------------ skilles ------------\n"
	for i = 1,#p.skills do
		if i ==  menu.states.ap then
			text = text.."- "
		end
		text = text.."lv "..p.skills[i].level.." "..p.skills[i].name.." - "..p.skills[i].xp.."/"..25*2^p.skills[i].level.." xp\n"
	end
	love.graphics.print(text,30,50)
	love.graphics.rectangle("line",190,85,width-240,height-125)
	love.graphics.setFont(f40)
	love.graphics.print("<",210,85+(width-125)/2-20)
	love.graphics.print(">",210+width-240-40-f40:getWidth(">"),85+(width-125)/2-20)
	love.graphics.setFont(f20)
	love.graphics.printf(menu.states.selected,190,86,width-240,"center")
	love.graphics.setFont(f12)
	if menu.states.selectend then
		local t = #skills[menu.states.selected].abilities
		for i = 1,t do
			local s = skills[menu.states.selected].abilities[t+1-i].a.name
			love.graphics.printf(s,190,(height-125)/t*(t+1-i)-15,width-240,"center")
			love.graphics.printf(skills[menu.states.selected].abilities[t+1-i].r,190,(height-125)/t*(t+1-i),width-240,"center")
			local x = 190+(190+width-240-190-f12:getWidth(s.."  "))/2
			if mouse.pos.x >= x and mouse.pos.x <= x + f12:getWidth(s.."  ") and mouse.pos.y >= (height-125)/t*(t+1-i)-15 and mouse.pos.y <= (height-125)/t*(t+1-i)-15 + 30 then
				love.graphics.rectangle("line",x,(height-125)/t*(t+1-i)-15,f12:getWidth(s.."  "),30)
			end
		end
	end
end

function menu.states.mousereleased()
	local i,y,x,p = 1,105,25,playerSprite
	for k in pairs(p.states) do
		if mouse.pos.x >= x and mouse.pos.x <= x + f12:getWidth(k.."   "..p.states[k]) and mouse.pos.y >= y and mouse.pos.y <= y + 13 then
			if p.sp > 0 then
				p.states[k] = p.states[k] + 1
				p.sp = p.sp - 1
			end
			return
		end
		x = x + f12:getWidth(k.."   "..p.states[k]) + 2
		if math.floor(i/2) == i/2 then
			x = 25
			y = y + 14
		end
		i = i + 1
	end
	if menu.states.selected then
		local t = #skills[menu.states.selected].abilities
		for i = 1,t do
			local s = skills[menu.states.selected].abilities[t+1-i].a.name
			local x = 190+(190+width-240-190-f12:getWidth(s.."  "))/2
			if mouse.pos.x >= x and mouse.pos.x <= x + f12:getWidth(s.."  ") and mouse.pos.y >= (height-125)/t*(t+1-i)-15 and mouse.pos.y <= (height-125)/t*(t+1-i)-15 + 30 then
				if not skills[menu.states.selected].abilities[t+1-i].a.gotten and skills[menu.states.selected].abilities[t+1-i].r <= skills[menu.states.selected].level then
					skills[menu.states.selected].abilities[t+1-i].a.gotten = true
					playerSprite.abilities[#playerSprite.abilities+1] = skills[menu.states.selected].abilities[t+1-i].a
				end
				return
			end
		end
	end
	if mouse.pos.x >= 190 and mouse.pos.x <= 260 and mouse.pos.y >= 85 and mouse.pos.y <= 85+height-125 then
		menu.states.ap = math.max(menu.states.ap-1,1)
		menu.states.selected = playerSprite.skills[menu.states.ap].name
		return
	end
	if mouse.pos.x >= 190+width-310 and mouse.pos.x <= 260+width-310 and mouse.pos.y >= 85 and mouse.pos.y <= 85+height-125 then
		menu.states.ap = math.min(menu.states.ap+1,#playerSprite.skills)
		menu.states.selected = playerSprite.skills[menu.states.ap].name
		return
	end
end