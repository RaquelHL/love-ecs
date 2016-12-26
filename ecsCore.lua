--Principais
require("GameObject")
require("Scene")

--Componentes
require("Component")
require("Components.Transform")
require("Components.Renderer")
require("Components.BoxCollider")
require("Components.SpriteAnimator")

ResourceMgr = require("lib.resourceManager")

require("lib.color")
require("lib.cector")


local bump = require("lib.bump")
local bumpdebug = require("lib.bump_debug")



local ecs = {}

ecs.scenes = {}
ecs.currentScene = nil

ecs.debugPhysics = false

local function init()

	physics = bump.newWorld(168)	--Tem que colocar isso em algum outro lugar?
	initExtraPhysics()

	return ecs
end

function ecs:registerScene(scene)
	self.scenes[scene.name] = scene
end

function ecs:loadScene(s)
	if type(s) == "string" then
		if self.scenes[s] then
			self.currentScene = s
		else
			print("Invalid scene: '"..s.."'")
		end
	else
		if type(s) == "table" then
			self.currentScene = s.name
		end
	end
end

function ecs:update(dt)
	if self.currentScene then
		self.scenes[self.currentScene]:_update(dt)
	end
end

function ecs:draw()
	if self.currentScene then
		self.scenes[self.currentScene]:_draw()
	end
	if self.debugPhysics then
		bumpdebug.draw(physics)
	end
end

function ecs:mousepressed(x,y,b)
	if self.currentScene and self.scenes[self.currentScene].mousepressed then
		self.scenes[self.currentScene]:mousepressed(x,y,b)
	end
end

function ecs:keypressed(k)
	if self.currentScene and self.scenes[self.currentScene].keypressed then
		self.scenes[self.currentScene]:keypressed(k)
	end
end

function ecs:textinput(t)
	if self.currentScene and self.scenes[self.currentScene].textinput then
		self.scenes[self.currentScene]:textinput(t)
	end
end

function initExtraPhysics()

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
end

return init()