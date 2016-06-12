require("_game/tile")
require("_game/map")
require("_game/sprite")

game = {}

function game.load()
	--other
		width = love.graphics.getWidth()
		height = love.graphics.getHeight()
	--mouse
		mouse = {}
		mouse.tile = vector2:new(0,0)
		mouse.pos = vector2:new(0,0)
		mouse.dragge = 0
	--map
		map.people = {npcSprite:new({pos=vector2:new(5,5)})}
		map:creatPeopleMap()
		for x = 2,9 do
			map[x][2] = tiles.wall
		end
end

function game.update(dt)
	--player
		playerSprite:update(dt)
end

function game.draw()
	--map
		map:draw()
	--player
		playerSprite:draw()
end

function game.resize(w, h)
	--update mesures
		width = love.graphics.getWidth()
		height = love.graphics.getHeight()
end

function game.mousemoved(x,y,dx,dy)
	--mouse
		mouse.pos = vector2:new(x,y)
		mouse.tile.x = math.floor((x/map.s)-map.pos.x)
		mouse.tile.y = math.floor((y/map.s)-map.pos.y)
	--map
		map:mousemoved(x,y,dx,dy)
end

function game.mousepressed(x, y, button, istouch)
	--mouse
		mouse.dragge = map.pos:new()
end

function game.mousereleased(x, y, button, istouch)
	--mouse
		mouse.pos = vector2:new(x,y)
		mouse.tile.x = math.floor((x/map.s)-map.pos.x)
		mouse.tile.y = math.floor((y/map.s)-map.pos.y)
	--player
		if mouse.dragge.x == map.pos.x and mouse.dragge.y == map.pos.y then
			playerSprite:mousereleased(x,y)
		end
		mouse.dragge = vector2:new(-1,-1)
end

function game.wheelmoved(x,y)
	--map
		map:wheelmoved(x,y)
end