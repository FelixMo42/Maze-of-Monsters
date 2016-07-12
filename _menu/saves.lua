menu.saves = {}
menu.saves.ui = {}
menu.saves.ui[1] = button:new({x=40,y=60,text="reset"})

function menu.saves.draw()
	for i = 1,#menu.saves.ui do
		menu.saves.ui[i]:draw()
	end
end

function menu.saves.mousereleased(x, y, button, istouch)

end