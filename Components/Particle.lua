--[[
	Componente de partículas

	Métodos de partícula
	https://love2d.org/wiki/love.graphics.newParticleSystem
]]
Particle = Component("particle")

function Particle:new(tex, offsetX, offsetY)
	-- Img é a textura a ser usada e buffer é o número de partículas permitido para existir simultaneamente
	self.texture = tex
	self.ParticleSystem = love.graphics.newParticleSystem(tex, 100)
	self.offsetX = offsetX or 0
	self.offsetY = offsetY or 0
	
	-- Configurações padrão de partículas
	self.ParticleSystem:setParticleLifetime(1,2) -- Partículas existirão por 2 a 5 segundos
	self.ParticleSystem:setEmissionRate(20) -- Serão emitidas 20 partículas por segundo
	self.ParticleSystem:setSizeVariation(0.5, 2) -- Variação de tamanho das partículas
	self.ParticleSystem:setLinearAcceleration(-100, -100, 100, 100) -- Acelerações minx, miny, maxx, maxy
	self.ParticleSystem:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- RGBA inicial e RGBA final

	return self
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