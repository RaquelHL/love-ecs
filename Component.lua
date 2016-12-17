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

	comp.requiredComponents = {}

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
	
	comp.require = function(self, ...)
		local args = {...}
		for i,v in ipairs(args) do
			self.requiredComponents[#self.requiredComponents+1] = v
		end
	end

	comp.initComp = function(self)
		assert(self.go, self.name.." component has no GameObject")
		for i,v in ipairs(self.requiredComponents) do
			assert(self.go[v], self.name.." needs a "..v.." component")
		end

		if (self.init) then
			self:init()
		end
	end

	setmetatable(comp, {__call = function(_, ...) return comp:newComp(...) end})
	return comp
end

--Faz com que seja possível chamar a função new assim: Component(); Ao inves de assim: Component.new()
setmetatable(Component, {__call = function(_, ...) return new(...) end})