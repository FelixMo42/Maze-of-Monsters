menu.saves = {}
menu.saves.ui = {}

local b = button:new({x=40,y=60,text="reset"})
function b:func()
	playerSprite = playerSprite.blank:new()
	playerSprite.blank = playerSprite:new()
	playerSprite = charecter:new(playerSprite)
end

menu.saves.ui[1] = b:new()

function menu.saves.draw()
	for i = 1,#menu.saves.ui do
		menu.saves.ui[i]:draw()
	end
end

function menu.saves.mousereleased(x, y, button, istouch)
	for i = 1,#menu.saves.ui do
		menu.saves.ui[i]:onPressed()
	end
end