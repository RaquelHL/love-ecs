require("ecsCore")

GUI = require("gui.coreGUI")

require("scripts.PlayerInput")
require("scripts.CharacterMotor")

local bump = require("lib.bump")
local bumpdebug = require("lib.bump_debug")

function love.load()

	physics = bump.newWorld(168)	--Tem que colocar isso em algum outro lugar

	local oneway = function(world, col, x,y,w,h, goalX, goalY, filter)
  		local cols, len = world:project(col.item, x,y,w,h, goalX, goalY, filter)
		return goalX, math.min(goalY,col.item.transform.pos.y), cols, len
	end
	local slope = function(world, col, x,y,w,h, goalX, goalY, filter)

		col.normal = {x = 0, y = 0}	--Até provado o contrario, não teve realmente uma colisão
  		local range = math.abs(col.other.collider.rightY-col.other.collider.leftY)

  		local charBase = math.min(math.max(col.item.transform.pos.x + col.item.collider.w/2,col.other.transform.pos.x), col.other.transform.pos.x + col.other.collider.w)
  		local xNormal = (charBase - col.other.transform.pos.x) / col.other.collider.w
  		if (col.other.collider.rightY < col.other.collider.leftY) then
  			xNormal = 1 - xNormal
  		end
  		local slopeY = (col.other.transform.pos.y+col.other.collider.h) - ((xNormal * range) * col.other.collider.h) - math.min(col.other.collider.rightY, col.other.collider.leftY) * col.other.collider.h
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

	player = GameObject("Player", {Renderer(), SpriteAnimator("idle"), BoxCollider(), CharacterMotor(), PlayerInput()}):newInstance({pos = vector(400,50)})

	--Cria cena de teste
	scene = Scene()

	pprint("teste", "a")

	--[[pai = GameObject("pai",{Renderer("tile8", Color(255, 0, 0, 128))}):newInstance()
	pai2 = GameObject("pai",{Renderer("tile8", Color(255, 0, 0, 128))}):newInstance()
	pai.transform:setScale(2,2)
	filho = GameObject("filho",{Renderer("tile8")}):newInstance()
	filho.transform:setScale(0.5,0.25)
	pai:addChild(filho)
	scene:addGO(pai)
	scene:addGO(pai2)
	pai.transform:moveTo(vector(400,200))
	filho.transform:moveTo(-20,50)]]

	scene:loadMap("level1")	--Carrega um mapa da pasta maps
	scene:addGO(player)


	debugTool.initInspector(player)

end

function love.update(dt)
	scene:update(dt)
	--pai2.transform:translate(30*dt,30*dt)
	--filho.transform:translate(5*dt,5*dt)
	--pai.transform:rotate(dt*0.5)
	--filho.transform:rotate(dt*0.5)
	--pai.transform:lookAt(pai2)
	--pai.transform:translate(pai.transform:forward()*30*dt)
end

function love:draw()
	scene:draw()
	--bumpdebug.draw(physics)
end


require("debugTool")
debugTool.enable()
