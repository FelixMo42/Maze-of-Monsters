menu.inventory = {}
menu.inventory.dragge = vector2:new(0,0)
menu.poses = {}

for x = 1,5 do
	for y = 1,6 do
		menu.poses[#menu.poses+1] = {x=x*80+100,y=y*80-20}
	end
end 

for k in pairs(playerSprite.equips) do
	if type(k) == "string" then
		menu.poses[#menu.poses+1] = {x=40,y=(#menu.poses-29)*80-20,t=playerSprite.equips[k].type}
		menu.poses[#menu.poses].item = playerSprite.equips[k]
		playerSprite.equips[k].x = 40
		playerSprite.equips[k].y = (#menu.poses-30)*80-20
		playerSprite.equips[k].pos = menu.poses[#menu.poses]
	else
		for i = 1,#menu.poses do
			if not menu.poses[i].item then
				menu.poses[i].item = playerSprite.equips[k]
				playerSprite.equips[k].x = menu.poses[i].x
				playerSprite.equips[k].y = menu.poses[i].y
				playerSprite.equips[k].pos = menu.poses[i]
				break
			end
		end
	end
end

function menu.inventory.draw()
	love.graphics.rectangle("fill",40,height-100,60,60)
	love.graphics.setColor(0,0,0)
	love.graphics.printf("trash", 40, height-100+60/2-14/2, 60, "center")
	for i = 1,#menu.poses do
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle("fill",menu.poses[i].x,menu.poses[i].y,60,60)
		love.graphics.setColor(0,0,0)
		if menu.poses[i].t then
			love.graphics.printf(menu.poses[i].t, menu.poses[i].x, menu.poses[i].y+60/2-14/2, 60, "center")
		end
	end
	for k in pairs(playerSprite.equips) do
		playerSprite.equips[k]:draw()
	end
end

function menu.inventory.mousepressed()
	for k in pairs(playerSprite.equips) do
		local i = playerSprite.equips[k]
		if mouse.pos.x >= i.x and mouse.pos.y >= i.y and mouse.pos.x <= i.x+60 and mouse.pos.y <= i.y+60 then
			menu.inventory.dragge.x = i.x - mouse.pos.x
			menu.inventory.dragge.y = i.y - mouse.pos.y
			menu.selected = i
			i.prev = {x=i.x,y=i.y}
		end
	end
end

function menu.inventory.mousemoved(x,y,dx,dy)
	if menu.selected then
		menu.selected.x, menu.selected.y = menu.inventory.dragge.x+x,menu.inventory.dragge.y+y
	end
end

function menu.inventory.mousereleased(x, y, button, istouch)
	if menu.selected then
		if x >= 40 and y >= height-100 and x <= 100 and y <= height-40 then
			table.removeValue(playerSprite.equips,menu.selected)
			return
		end
		for i = 1,#menu.poses do
			local pos = menu.poses[i]
			local item = menu.selected
			if x >= pos.x and y >= pos.y and x <= pos.x+60 and y <= pos.y+60 and (not pos.t or pos.t == item.type) then
				if pos.t then
					table.removeValue(playerSprite.equips,item)
					playerSprite.equips[#playerSprite.equips+1] = pos.item
					playerSprite.equips[pos.t] = item
				end
				-- old pos - item.pos
				item.pos.item = pos.item
				-- current item	- pos.item			
				if pos.item then
					pos.item.pos = item.pos
					pos.item.x, pos.item.y = item.pos.x, item.pos.y
				end
				-- current pos - pos
				pos.item = item
				-- old item - item
				item.pos = pos
				item.x, item.y = pos.x, pos.y
				break
			else
				menu.selected.x, menu.selected.y = menu.selected.prev.x, menu.selected.prev.y
			end
		end
		menu.selected = nil
		return true
	end
	return false
end