--[[
	Scene: 
	-> Responsável por manter e gerenciar todos os gameObjects
	-> Chama as funções draw e update dos gameObjects
]]

Scene = {}
Scene.__index = Scene

local function new()
	local s = {}
	setmetatable(s, Scene)

	s.gameObjects = {}

	return s
end

function Scene:update(dt)
	for k,go in pairs(self.gameObjects) do
		--print("Updating ", go.name)
		go:update(dt)
	end
end

function Scene:draw()
	for k,go in pairs(self.gameObjects) do
		go:draw()
	end
end

function Scene:addGO(go)
	assert(go.isInstance, "GameObject needs to be an instance")
	self.gameObjects[#self.gameObjects+1] = go

end


setmetatable(Scene, {__call = function(_, ...) return new(...) end})