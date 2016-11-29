--[[
	Componente Transform
	-> Guarda a posição, orientação e escala do objeto;
	-> Vem padrão em todos os objetos, pois a maioria dos componentes precisam dessas informações
]]
Transform = {}
Transform.__index = Transform

local function new(x, y, o, sx, sy)
	local t = {}
	setmetatable(t, Transform)

	t.isComponent = true
	t.name = "transform"
	t.x = x or 0
	t.y = y or 0
	t.o = o or 0
	t.sx = sx or 1
	t.xy = sy or 1

	return t
end

function Transform:clone()
	return new(self.x, self.y, self.o, self.sx, self.sy)
end

setmetatable(Transform, {__call = function(_, ...) return new(...) end})