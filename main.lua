--Principais
require("GameObject")
require("Scene")

--Componentes
require("Transform")
require("Renderer")
require("BoxCollider")
require("SpriteAnimator")
require("PlayerInput")
require("CharacterMotor")

--Outros
require("Color")
ResourceMgr = require("ResourceManager")

local bump = require("lib.bump")
local bumpdebug = require("lib.bump_debug")

local pprintList = {}

function love.load()

	physics = bump.newWorld(128)	--Tem que colocar isso em algum outro lugar

	love.graphics.setBackgroundColor(150,150,220)

	ResourceMgr.add("animsheet", "pixelChar")
	boxTex = ResourceMgr.get("texture", "tile.png")
	smallBoxTex = ResourceMgr.get("texture", "tile8.png")


	boxGO = GameObject("box", {Renderer(boxTex), BoxCollider()})
	smallBoxGO = GameObject("smallBox", {Renderer(), SpriteAnimator("idle"), BoxCollider(), CharacterMotor(), PlayerInput()})

	--Cria cena de teste
	scene = Scene()
	scene:loadMap("level1")	--Carrega um mapa da pasta maps

	scene:addGO(smallBoxGO:newInstance({x = 400}))

	pprint("Pressione Z para morrer", "morte")
	

end

function love.update(dt)
	scene:update(dt)
end

function love:draw()
	scene:draw()

	--bumpdebug.draw(physics)

	love.graphics.setColor(0, 0, 0)
	local j = 0
	for i,v in ipairs(pprintList) do
		love.graphics.print(v, 10, j*10)
		pprintList[i] = nil
		j = j + 1
	end
	for k,v in pairs(pprintList) do
		love.graphics.print(v, 10, j*10)
		j = j + 1
	end
end

--Print para depurar valores contínuos
function pprint(text, name)
	if name then
		pprintList[name] = text
	else
		pprintList[#pprintList+1] = text
	end
end