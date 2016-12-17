--[[
	Component: Classe que retorna a base para a criação de novos componentes
	Uso: Component(nome)
		Retorna um esqueleto de componente com o nome dado
	Callbacks suportadas:
		:new(...)
			É chamada logo depois da criação da base do componente.
			Serve pra inicializar as propriedades iniciais do componente
			Variáveis passadas no codigo principal são repassadas diretamente para esta função
		:init()
			É chamada pela entidade pai, quando ela está sendo instanciada
			Serve para inicializar variáveis que dependem de algo externo, como outro componente
		:update(dt)
			É chamada pela entidade pai, teoricamente em todo love.update
		:draw()
			É chamada pela entidade pai, teoricamente em todo love.draw
			Se o componente desenha alguma coisa na tela, é aqui que fica o código pra desenhar
		:destroy()
			É chamada pela entidade pai, quando ela está sendo destruída
			Serve pra finalizar alguma coisa com alguma coisa externa, caso necessário
]]
Component = {}
local meta = {}
meta.__index = meta

local function new(name)
	local comp = {}
	setmetatable(comp, meta)

	comp.isComponent = true
	comp.name = name

	comp.clone = function(self)
		newComp = {}
		for k,v in pairs(self) do
			newComp[k] = v
		end
		return newComp
	end

	comp.newComp = function(self, ...)
		local t = {}

		for k,v in pairs(self) do
			t[k] = v
		end
		if (self.new) then
			return self.new(t, ...)
		else
			return t
		end
	end
	
	setmetatable(comp, {__call = function(_, ...) return comp:newComp(...) end})
	return comp
end

--Faz com que seja possível chamar a função new assim: Component(); Ao inves de assim: Component.new()
setmetatable(Component, {__call = function(_, ...) return new(...) end})