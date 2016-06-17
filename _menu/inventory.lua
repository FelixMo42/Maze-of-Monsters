menu.inventory = {}
menu.inventory.dragge = vector2:new(0,0)
menu.poses = {}

for x = 1,5 do
	for y = 1,6 do
		menu.poses[#menu.poses+1] = {x=x*80+100,y=y*80-20}
	end
end 

for k in pairs(playerSprite.equips) do
	menu.poses[#menu.poses+1] = {x=40,y=(#menu.poses-29)*80-20,t=playerSprite.equips[k].type}
end

function menu.inventory.draw()
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
		for i = 1,#menu.poses do
			if x >= menu.poses[i].x and y >= menu.poses[i].y and x <= menu.poses[i].x+60 and y <= menu.poses[i].y+60 then
				if not menu.poses[i].t or menu.poses[i].t == menu.selected.type then
					menu.selected.x, menu.selected.y = menu.poses[i].x, menu.poses[i].y
				end
				break
			else
				menu.selected.x, menu.selected.y = menu.selected.prev.x, menu.selected.prev.y
			end
		end
		menu.selected = nil
	end
end