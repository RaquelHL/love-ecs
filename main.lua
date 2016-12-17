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

	physics = bump.newWorld(168)	--Tem que colocar isso em algum outro lugar

	local oneway = function(world, col, x,y,w,h, goalX, goalY, filter)
  		local cols, len = world:project(col.item, x,y,w,h, goalX, goalY, filter)
		return goalX, math.min(goalY,col.item.transform.y), cols, len
	end
	local slope = function(world, col, x,y,w,h, goalX, goalY, filter)

		col.normal = {x = 0, y = 0}	--Até provado o contrario, não teve realmente uma colisão
  		local range = math.abs(col.other.collider.rightY-col.other.collider.leftY)

  		local charBase = math.min(math.max(col.item.transform.x + col.item.collider.w/2,col.other.transform.x), col.other.transform.x + col.other.collider.w)
  		local xNormal = (charBase - col.other.transform.x) / col.other.collider.w
  		if (col.other.collider.rightY < col.other.collider.leftY) then
  			xNormal = 1 - xNormal
  		end
  		local slopeY = (col.other.transform.y+col.other.collider.h) - ((xNormal * range) * col.other.collider.h) - math.min(col.other.collider.rightY, col.other.collider.leftY) * col.other.collider.h
  		slopeY = slopeY - col.item.collider.h
		if (goalY>slopeY) then
			col.normal = {x = 0, y = -1}	--Foi provado o contrario, teve colisão
		end

		return goalX, math.min(goalY,slopeY), {}, 0
	end

	physics:addResponse("slope", slope)

	love.graphics.setBackgroundColor(150,150,220)

	ResourceMgr.add("animsheet", "PixelChar")
	boxTex = ResourceMgr.get("texture", "tile.png")
	smallBoxTex = ResourceMgr.get("texture", "tile8.png")


	boxGO = GameObject("box", {Renderer(boxTex), BoxCollider()})
	smallBoxGO = GameObject("Player", {Renderer(), SpriteAnimator("idle"), BoxCollider(), CharacterMotor(), PlayerInput()})

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