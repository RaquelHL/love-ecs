--[[
	Componente PlayerInput
	-> Atualiza a posição do jogador de acordo com as teclas pressionadas
	-> Esse componente varia de jogo pra jogo
	-> Tem jeito de deixar ele genérico pra todos os jogos, registrando eventos de teclas com callbacks, mas acho que só vai deixar mais confuso
]]

PlayerInput = {}
PlayerInput.__index = PlayerInput

local function new()
	local pi = {}
	setmetatable(pi, PlayerInput)

	pi.isComponent = true
	pi.name = "input"
	pi.speed = 100

	return pi
end

function PlayerInput:update(dt)
	assert(self.go, self.name.." component has no GameObject")
	if (love.keyboard.isDown("left")) then
		self.go.transform.x = self.go.transform.x - self.speed * dt
	end
	if (love.keyboard.isDown("right")) then
		self.go.transform.x = self.go.transform.x + self.speed * dt
	end
	if (love.keyboard.isDown("up")) then
		self.go.transform.y = self.go.transform.y - self.speed * dt
	end
	if (love.keyboard.isDown("down")) then
		self.go.transform.y = self.go.transform.y + self.speed * dt
	end
end

function PlayerInput:clone()
	return new()
end

setmetatable(PlayerInput, {__call = function(_, ...) return new(...) end})