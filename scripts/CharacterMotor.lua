--[[
	CharacterMotor
	-> Controla a posição de um personagem
	-> Não faz muita coisa sozinho, precisa de outro componente pra controlar(Input ou uma IA)
]]
CharacterMotor = Component("characterMotor")
CharacterMotor:require("collider")

function CharacterMotor:new()
	self.isAlive = true

	--Propriedades ajustáveis
	self.jumpHeight = 4		-- Altura do pulo
	self.jumpTime = 0.44	-- Segundos que o pulo dura
	self.movSpeed = 5		-- Velocidade de movimento


	--Não mexer
	self.gravity = 0
	self.speed = vector(0,0)
	self.isGrounded = false

	return self
end

function CharacterMotor:init()	
	--Baseado em http://error454.com/2013/10/23/platformer-physics-101-and-the-3-fundamental-equations-of-platformers/
	self.gravity = ((2*self.jumpHeight)/(self.jumpTime*self.jumpTime))
end

function CharacterMotor:update(dt)
	self.speed.y = self.speed.y + self.gravity*dt
	local nX, nY, cols, n = physics:move(self.go, self.go.transform.pos.x + self.speed.x, self.go.transform.pos.y + self.speed.y, function(a, b) 
		local charBase = a.transform.pos.x+a.collider.w/2
		if(b.collider.isSlope and a.transform.pos.y < b.transform.pos.y + b.collider.h) then
	 		return "slope" 
	 	else
	 		return "slide"
	 	end
	end)
	
	self.isGrounded = false
	if (n>0) then
		for k,v in pairs(cols) do
			if (v.normal.y<0) then 	--Se a colisão está em baixo, reseta a velocidade Y se positiva
				self.speed.y = math.min(0, self.speed.y)
				self.isGrounded = true
			end
			if (v.normal.y>0) then 	--Se a colisão está em cima, reseta a velocidade Y se negativa
				self.speed.y = math.max(0, self.speed.y)
			end
		end
	end

	self.go.transform:moveTo(nX, nY)
end

function CharacterMotor:move(dir)
	if not self.isAlive then
		return
	end
	if (self.go.animator) then		
		if(self.isGrounded) then
			if (dir ~= 0) then
				if (self.go.animator.anim.name ~= "walk") then
					self.go.animator:setAnim("walk")
				end
			else
				if (self.go.animator.anim.name ~= "idle") then
					self.go.animator:setAnim("idle")
				end
			end
		end
		if dir~=0 then
			self.go.renderer.mirror = dir < 0
		end
	end

	self.speed.x = dir * self.movSpeed
end

function CharacterMotor:jump()
	if not self.isAlive then
		return
	end
	self.speed.y = - math.sqrt((2*self.gravity*self.jumpHeight))
	self.go.animator:setAnim("jump")
end

function CharacterMotor:die()
	self.isAlive = false
	self.go.animator:setAnim("die")
	self.speed.x = 0
	self.speed.y = 0
	pprint("Parabéns", "morte")
end