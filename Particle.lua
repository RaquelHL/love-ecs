--[[
	Componente de partículas

	Métodos de partícula
	https://love2d.org/wiki/love.graphics.newParticleSystem
]]
Particle = {}
Particle.__index = Particle

local function new(tex, offsetX, offsetY)
	-- Img é a textura a ser usada e buffer é o número de partículas permitido para existir simultaneamente
	local part = {}
	setmetatable(part, Particle)	--Faz com que part tenha todas as funções declaradas em Particle

	part.isComponent = true
	part.name = "particle"
	part.texture = tex
	part.ParticleSystem = love.graphics.newParticleSystem(tex, 100)
	part.offsetX = offsetX or 0
	part.offsetY = offsetY or 0
	
	-- Configurações padrão de partículas
	part.ParticleSystem:setParticleLifetime(1,2) -- Partículas existirão por 2 a 5 segundos
	part.ParticleSystem:setEmissionRate(20) -- Serão emitidas 20 partículas por segundo
	part.ParticleSystem:setSizeVariation(0.5, 2) -- Variação de tamanho das partículas
	part.ParticleSystem:setLinearAcceleration(-100, -100, 100, 100) -- Acelerações minx, miny, maxx, maxy
	part.ParticleSystem:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- RGBA inicial e RGBA final

	return part
end

function Particle:init()

end

function Particle:update(dt)
	self.ParticleSystem:update(dt)
end

function Particle:draw()
	love.graphics.draw(self.ParticleSystem, self.go.transform.x + self.offsetX, self.go.transform.y + self.offsetY)
end

function Particle:start()
	self.ParticleSystem:start()
end

function Particle:stop()
	self.ParticleSystem:stop()
end

function Particle:clone()
	return new(self.texture, self.offsetX, self.offsetY)
end

setmetatable(Particle, {__call = function(_, ...) return new(...) end})
