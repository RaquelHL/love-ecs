--Principais
require("GameObject")
require("Scene")

--Componentes
require("Transform")
require("Renderer")
require("BoxCollider")
require("PlayerInput")
require("CharacterMotor")

--Outros
require("Color")

local bump = require("lib.bump")

local pprintList = {}

function love.load()

	physics = bump.newWorld(64)	--Tem que colocar isso em algum outro lugar

	love.graphics.setBackgroundColor(150,150,220)

	boxTex = love.graphics.newImage("textures/tile.png")
	smallBoxTex = love.graphics.newImage("textures/tile8.png")

	boxGO = GameObject("box", {Renderer(boxTex), BoxCollider()})
	smallBoxGO = GameObject("smallBox", {Renderer(smallBoxTex, Color.green), BoxCollider(), CharacterMotor(), PlayerInput()}):newInstance({x = 200})

	--Cria cena de teste
	scene = Scene()
	scene:addGO(boxGO:newInstance({x = 100, y = 100, sx = 2, sy = 2}))
	scene:addGO(boxGO:newInstance({x = 228, y = 196, sx = 4, sy = 0.5}))
	scene:addGO(boxGO:newInstance({x = 452, y = 100, sx = 0.5, sy = 1.5}))
	scene:addGO(boxGO:newInstance({x = 250, y = 150, sx = 2.5, sy = 0.2}))
	
	scene:addGO(smallBoxGO)

end

function love.update(dt)
	scene:update(dt)
end

function love:draw()
	scene:draw()


	love.graphics.setColor(0, 0, 0)
	for i,v in ipairs(pprintList) do
		love.graphics.print(v, 10, i*10)
	end
	pprintList = {}
end

--Print para depurar valores contínuos
function pprint(text)
	pprintList[#pprintList+1] = text
end