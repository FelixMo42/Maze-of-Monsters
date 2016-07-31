menu.states = {}
menu.states.selected = "sword"
menu.states.ap = 1

function menu.states.setUpText()
	--set up text
	local text = ""
	local p = playerSprite
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
	--set up margin
	menu.states.text = text
	menu.states.margin = 0
	local lineList = text.lines(text)
	for i = 2,#lineList do
		if menu.states.margin < f12:getWidth(lineList[i]) then
			menu.states.margin = f12:getWidth(lineList[i])
		end
	end
	menu.states.margin = menu.states.margin + 50
end

function menu.states.load()
	menu.states.setUpText()
end

function menu.states.draw()
	love.graphics.print(menu.states.text,30,50)
	love.graphics.rectangle("line",menu.states.margin,80,width-menu.states.margin-40,height-120)
end

function menu.states.mousereleased()
	
end 