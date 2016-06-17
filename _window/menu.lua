menu = {}

function menu.load()
	menu.tab = "inventory"
	menu.tabs = {}
	menu.tabs[1] = button:new({
		x = 20, y = 20,
		w = 100, h = 20,
		text = "states"
	})
	menu.tabs[2] = button:new({
		x = 120, y = 20,
		w = 100, h = 20,
		text = "inventory"
	})
	menu.tabs[3] = button:new({
		x = 220, y = 20,
		w = 100, h = 20,
		text = "saves"
	})
	menu.ui = {}
	menu.ui[1] = button:new({
		rx = 20, y = 20,
		w = 20, h = 20,
		e = 0, s = 0,
		color = {0,0,0},
		lineColor = {255,255,255},
		textColor = {255,255,255},
		text = "X",
		func = function() window = "game" end
	})
	playerSprite = charecter:new(playerSprite)
	require("_menu/inventory")
end

function menu.draw()
	love.graphics.setColor(100,100,100)
	love.graphics.rectangle("fill",0,0,width,height)
	for k = 1,#menu.tabs do
		love.graphics.setColor(0,0,0)
		love.graphics.rectangle("fill",menu.tabs[k].x,20,100,18)
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle("line",menu.tabs[k].x,20,100,30)
		if k > 1 then
			love.graphics.line(menu.tabs[k].x,39 , menu.tabs[k].x+100,39)
		end
		love.graphics.setColor(255,255,255)
		love.graphics.printf(menu.tabs[k].text, menu.tabs[k].x, 30-love.graphics.getFont():getHeight()/2, 100, "center")
	end
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",20,40,width-40,height-60)
	love.graphics.setColor(255,255,255)
	love.graphics.line(20,39 , 20,height-20 , width-20,height-20 , width-20,40 , #menu.tabs*100+20,39)
	for i = 1,#menu.ui do
		menu.ui[i]:draw()
	end
	menu[menu.tab].draw()
end

function menu.mousepressed(x, y, button, istouch)
	for i = 1,#menu.tabs do
		if menu.tabs[i]:onPressed() then
			menu.tab = menu.tabs[i].text
			table.insert(menu.tabs,1,menu.tabs[i])
			table.remove(menu.tabs,i+1)
		end
	end
	for i = 1,#menu.ui do
		menu.ui[i]:onPressed()
	end
	if menu[menu.tab].mousepressed then
		menu[menu.tab].mousepressed(x, y, button, istouch)
	end
end

function menu.mousemoved(x,y,dx,dy)
	if menu[menu.tab].mousemoved then
		menu[menu.tab].mousemoved(x,y,dx,dy)
	end
end

function menu.mousereleased(x, y, button, istouch)
	if menu[menu.tab].mousereleased then
		menu[menu.tab].mousereleased(x, y, button, istouch)
	end
end

function menu.resize(w,h)
	for i = 1,#menu.ui do
		menu.ui[i]:update()
	end
end

menu.states = {}

function menu.states.draw()
	local p = playerSprite
	love.graphics.setColor(255,255,255)
	love.graphics.print("level: "..p.level.." --  ".."xp: "..p.xp.."/"..25*2^p.level,30,50)
end

menu.saves = {}

function menu.saves.draw()
end