--[[
	CharacterMotor
	-> Controla a posição de um personagem
	-> Não faz muita coisa sozinha, precisa de outro componente pra controlar(o jogador ou uma IA)
]]
CharacterMotor = {}
CharacterMotor.__index = CharacterMotor



local function new()
	local cm = {}
	setmetatable(cm, CharacterMotor)	

	cm.isCharacterMotor = true
	cm.name = "characterMotor"

	--Propriedades ajustáveis

	cm.jumpHeight = 2	--Sei lá em que unidade isso tá
	cm.jumpTime = 0.44	--Segundos

	cm.speed = 2		--Velocidade de movimento


	--Não mexer
	cm.gravity = 0
	cm.speedX = 0
	cm.speedY = 0
	cm.isGrounded = false

	return cm
end

function CharacterMotor:init()
	assert(self.go, self.name.." component has no GameObject")
	assert(self.go.collider, self.name.." needs a collider component")
	
	--Baseado em http://error454.com/2013/10/23/platformer-physics-101-and-the-3-fundamental-equations-of-platformers/
	self.gravity = ((2*self.jumpHeight)/(self.jumpTime*self.jumpTime))
end

function CharacterMotor:update(dt)
	
	pprint("speedY = "..self.speedY)

	self.speedY = self.speedY + self.gravity*dt
	local nX, nY, cols, n = physics:move(self.go, self.go.transform.x + self.speedX, self.go.transform.y + self.speedY)
	
	self.isGrounded = false
	if (n>0) then
		for k,v in pairs(cols) do
				pprint("v.normal = "..v.normal.x..","..v.normal.y)
			if (v.normal.y<0) then 	--Se a colisão está em baixo, reseta a velocidade Y se positiva
				self.speedY = math.min(0, self.speedY)
				self.isGrounded = true
			end
			if (v.normal.y>0) then 	--Se a colisão está em cima, reseta a velocidade Y se negativa
				self.speedY = math.max(0, self.speedY)
				self.isGrounded = true
			end
		end
	end

	self.go.transform:translate(nX, nY)
end

function CharacterMotor:move(dir)
	self.speedX = dir * self.speed
end

function CharacterMotor:jump()
	self.speedY = - math.sqrt((2*self.gravity*self.jumpHeight))
end



function CharacterMotor:clone()
	return new()
end

setmetatable(CharacterMotor, {__call = function(_, ...) return new(...) end})