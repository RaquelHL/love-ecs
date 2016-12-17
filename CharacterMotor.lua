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
	self.speed = 5			-- Velocidade de movimento


	--Não mexer
	self.gravity = 0
	self.speedX = 0
	self.speedY = 0
	self.isGrounded = false

	return self
end

function CharacterMotor:init()	
	--Baseado em http://error454.com/2013/10/23/platformer-physics-101-and-the-3-fundamental-equations-of-platformers/
	self.gravity = ((2*self.jumpHeight)/(self.jumpTime*self.jumpTime))
end

function CharacterMotor:update(dt)
	pprint("speedY = "..self.speedY)

	self.speedY = self.speedY + self.gravity*dt
	local nX, nY, cols, n = physics:move(self.go, self.go.transform.x + self.speedX, self.go.transform.y + self.speedY, function(a, b) 
		local charBase = a.transform.x+a.collider.w/2
		if(b.collider.isSlope and a.transform.y < b.transform.y + b.collider.h) then
	 		return "slope" 
	 	else
	 		return "slide"
	 	end
	end)
	
	self.isGrounded = false
	if (n>0) then
		for k,v in pairs(cols) do
			if (v.normal.y<0) then 	--Se a colisão está em baixo, reseta a velocidade Y se positiva
				self.speedY = math.min(0, self.speedY)
				self.isGrounded = true
			end
			if (v.normal.y>0) then 	--Se a colisão está em cima, reseta a velocidade Y se negativa
				self.speedY = math.max(0, self.speedY)
			end
		end
	end

	self.go.transform:translate(nX, nY)
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

	self.speedX = dir * self.speed
end

function CharacterMotor:jump()
	if not self.isAlive then
		return
	end
	self.speedY = - math.sqrt((2*self.gravity*self.jumpHeight))
	self.go.animator:setAnim("jump")
end

function CharacterMotor:die()
	self.isAlive = false
	self.go.animator:setAnim("die")
	self.speedX = 0
	self.speedY = 0
	pprint("Parabéns", "morte")
end