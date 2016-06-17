--system
	require("_system/console")
	require("_system/button")
--windows
	require("_window/game")
	require("_window/combat")
	require("_window/menu")

function love.load()
	--mouse
		mouse = {}
		mouse.tile = vector2:new(0,0)
		mouse.pos = vector2:new(0,0)
		mouse.dragge = 0
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
	game.load()
	menu.load()
	combat.load(charecter:new(),charecter:new())
	window = "menu"
end

function love.update(dt)
	if _G[window].update then
		_G[window].update(dt)
	end
end

function love.draw()
	if _G[window].draw then
		_G[window].draw()
	end
end

function love.resize(w,h)
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
	if _G[window].resize then
		_G[window].resize(w, h)
	end
end

function love.mousemoved(x,y,dx,dy)
	--mouse
		mouse.pos = vector2:new(x,y)
		mouse.tile.x = math.floor((x/map.s)-map.pos.x)
		mouse.tile.y = math.floor((y/map.s)-map.pos.y)
	if _G[window].mousemoved then
		_G[window].mousemoved(x,y,dx,dy)
	end
end

function love.mousepressed(x, y, button, istouch)
	if _G[window].mousepressed then
		_G[window].mousepressed(x, y, button, istouch)
	end
end

function love.mousereleased(x, y, button, istouch)
	--mouse
		mouse.pos = vector2:new(x,y)
		mouse.tile.x = math.floor((x/map.s)-map.pos.x)
		mouse.tile.y = math.floor((y/map.s)-map.pos.y)
	if _G[window].mousereleased then
		_G[window].mousereleased(x, y, button, istouch)
	end
end

function love.wheelmoved(x,y)
	if _G[window].wheelmoved then
		_G[window].wheelmoved(x,y)
	end
end