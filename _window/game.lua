require("_game/tile")
require("_game/map")
require("_game/sprite")

game = {}

function game.load()
	--map
		map.people = {npcSprite:new({pos=vector2:new(5,5)})}
		map:creatPeopleMap()
		for x = 2,9 do
			map[x][2] = tiles.wall
		end
	--ui
		game.ui = {}
		game.ui[1] = dropMenu:new({y = 0, rx = 0, e = 0})
		game.ui[1].children[1] = button:new({rx = 0, y = 20, e = 0, text = "menu"})
		game.ui[1].children[1].func = function() window = "menu" end
		game.ui[1].children[2] = button:new({rx = 0, y = 40, e = 0, text = "quit"})
		game.ui[1].children[2].func = love.event.quit
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
	--ui
		for i = 1,#game.ui do
			game.ui[i]:draw()
		end
end

function game.mousemoved(x,y,dx,dy)
	--mouse
		mouse.pos = vector2:new(x,y)
		mouse.tile.x = math.floor((x/map.s)-map.pos.x)
		mouse.tile.y = math.floor((y/map.s)-map.pos.y)
	--map
		map:mousemoved(x,y,dx,dy)
end

function game.mousepressed(x,y,button,istouch)
	playerSprite:mousepressed(x, y, button, istouch)
	mouse.dragge = map.pos:new()
end

function game.mousereleased(x,y, button,istouch)
	local t = false
	--ui
		for i = 1,#game.ui do
			t = t or game.ui[i]:onPressed()
		end
		if t then 
			do return end 
		end
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

function game.resize(w,h)
	for i = 1,#game.ui do
		game.ui[i]:update()
	end
end

function game.quit()
	data = data.."playerSprite.pos.x = ".. playerSprite.pos.x..";playerSprite.pos.y = "..playerSprite.pos.y..";"
	data = data.."playerSprite.name = '".. playerSprite.name.."';"
end