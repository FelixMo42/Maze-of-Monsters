--system
	require("_system/console")
	require("_system/button")
	require("_system/vector2")
--windows
	require("game")
	require("combat")

function love.load()
	game.load()
	combat.load(charecter:new(),charecter:new())
	window = "game"
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

function love.resize(w, h)
	if _G[window].resize then
		_G[window].resize(w, h)
	end
end

function love.mousemoved(x,y,dx,dy)
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
	if _G[window].mousereleased then
		_G[window].mousereleased(x, y, button, istouch)
	end
end

function love.wheelmoved(x,y)
	if _G[window].wheelmoved then
		_G[window].wheelmoved(x,y)
	end
end