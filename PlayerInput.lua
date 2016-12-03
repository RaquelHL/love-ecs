--[[
	Componente PlayerInput
	-> Controla o CharacterMotor com a entrada do jogador
	-> Requer um CharacterMotor pra funcionar
]]

PlayerInput = {}
PlayerInput.__index = PlayerInput

local function new()
	local pi = {}
	setmetatable(pi, PlayerInput)

	pi.isComponent = true
	pi.name = "input"

	return pi
end

function PlayerInput:init()
	assert(self.go, self.name.." component has no GameObject")
	assert(self.go.characterMotor, self.name.." needs a CharacterMotor component")

	self.motor = self.go.characterMotor

end

function PlayerInput:update(dt)
	local changeX = 0
	if (love.keyboard.isDown("left")) then
		changeX = -1
	end
	if (love.keyboard.isDown("right")) then
		changeX = 1
	end
	self.motor:move(changeX)

	if (love.keyboard.isDown("up") and self.motor.isGrounded) then
		self.motor:jump()
	end
	if (love.keyboard.isDown("z")) then
		self.motor:die()
	end
end

function PlayerInput:clone()
	return new()
end

setmetatable(PlayerInput, {__call = function(_, ...) return new(...) end})