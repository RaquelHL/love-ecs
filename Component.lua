--[[
	Arquivo modelo de componente
]]
Component = {}
Component.__index = Component

local function new(...)
	local comp = {}
	setmetatable(comp, Component)	--Faz com que comp tenha todas as funções declaradas em Component

	comp.isComponent = true
	comp.name = "component"

	--Lida com argumentos

	return comp
end

--(Opcional) Chamado quando o GameObject pai está sendo instanciado
function Component:init()

end

--(Opcional) Chamado a cada love.update
function Component:update(dt)

end

--(Opcional) Chamado a cada love.draw
function Component:draw()

end

--Retorna uma copia do componente
function Component:clone()
	return new()
end

--Faz com que seja possível chamar a função new assim: Component(); Ao inves de assim: Component.new()
setmetatable(Component, {__call = function(_, ...) return new(...) end})