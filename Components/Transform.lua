--[[
	Componente Transform
	-> Guarda a posição, orientação e escala, locais e globais, do objeto;
	-> É necessário usar as funções pra modificar os valores, pra poder repassar as novas informações pros filhos
	-> Vem padrão em todos os objetos, pois a maioria dos componentes precisam dessas informações
]]

Transform = Component("transform")

function Transform:new(x, y, o, sx, sy)	
	self.localPos = vector(x or 0, y or 0)
	self.pos = vector(self.localPos.x, self.localPos.y)
	self.localO = o or 0
	self.o = self.localO
	self.localScale = vector(sx or 1, sy or 1)
	self.scale = vector(self.localScale.x, self.localScale.y)

	return self
end



function Transform:move(x, y)
	if (type(x) == "number") then
		self.localPos.x = self.localPos.x + x
		self.localPos.y = self.localPos.y + y
	else
		self.localPos = self.localPos + x
	end
	self:refresh()
end

function Transform:moveTo(x, y)
	if (type(x) == "number") then
		self.localPos.x = x
		self.localPos.y = y
	else
		self.localPos = x
	end
	self:refresh()
end

function Transform:rotate(o)
	self.localO = self.localO + o
	self:refresh()
end

function Transform:rotateTo(o)
	self.localO = o
	self:refresh()
end

function Transform:lookAt(a)
	if(type(a) == "table") then
		if(a.isComponent and a.name == "transform")then
			a = a.pos
		else
			if (a.isGameObject) then
				a = a.transform.pos
			end
		end
	end
	self:rotateTo(self.pos:angleTo(a))
end

function Transform:forward()
	return vector.fromAngle(self.o)
end

function Transform:setScale(x, y)
	if (type(x) == "number") then
		self.localScale.x = x
		self.localScale.y = y
	else
		self.localScale = x
	end
	self:refresh()
end

function Transform:refresh()
	if (self.go.parent) then
		local nO = self.go.parent.transform.o + math.atan2(self.localPos.y,self.localPos.x)
		local hip = self.localPos:magnitude()
		local x = hip * math.cos(nO)
		local y = hip * math.sin(nO)
		
		self.pos = self.go.parent.transform.pos + vector(x,y)--self.localPos:clone():rotate(self.go.parent.transform.o)
		self.o = self.go.parent.transform.o + self.localO
		self.scale = self.go.parent.transform.scale * self.localScale
	else
		self.pos = self.localPos
		self.o = self.localO
		self.scale = self.localScale
	end
	for k,v in pairs(self.go.children) do
		v.transform:refresh()
	end
	
	if self.go.collider and self.go.collider.autoScale then
		self.go.collider:autoUpdate()
	end
end