--[[
	Componente Transform
	-> Guarda a posição, orientação e escala do objeto;
	-> Vem padrão em todos os objetos, pois a maioria dos componentes precisam dessas informações
]]

Transform = Component("transform")

function Transform:new(x, y, o, sx, sy)	
	self.x = x or 0
	self.y = y or 0
	self.o = o or 0
	self.sx = sx or 1
	self.sy = sy or 1

	return self
end

function Transform:translate(x, y)
	self.x = x
	self.y = y
end