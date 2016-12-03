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
local bumpdebug = require("lib.bump_debug")

local pprintList = {}

function love.load()

	physics = bump.newWorld(128)	--Tem que colocar isso em algum outro lugar

	love.graphics.setBackgroundColor(150,150,220)

	boxTex = love.graphics.newImage("textures/tile.png")
	smallBoxTex = love.graphics.newImage("textures/tile8.png")

	boxGO = GameObject("box", {Renderer(boxTex), BoxCollider()})
	smallBoxGO = GameObject("smallBox", {Renderer(smallBoxTex, Color.green), BoxCollider(), CharacterMotor(), PlayerInput()})

	--Cria cena de teste
	scene = Scene()
	scene:loadMap("level1")	--Carrega um mapa da pasta maps

	scene:addGO(smallBoxGO:newInstance({x = 400}))


	

end

function love.update(dt)
	scene:update(dt)
end

function love:draw()
	scene:draw()

	--bumpdebug.draw(physics)

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