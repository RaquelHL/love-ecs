--[[
	GameObject: Classe base para todo o sistema
	-> Mantém e gerencia seus componentes
	-> É responsável pelos seus filhos
]]

GameObject = {}
GameObject.__index = GameObject


local function new(name, components)
	components = components or {}
	local go = {}
	setmetatable(go, GameObject)

	go.isInstance = false
	go.name = name or "GameObject"
	go.components = {}

	go:addComponent(Transform()) --	Teoricamente todo gameObject precisa de um transform
	
	for k,c in pairs(components) do
		go:addComponent(c)
	end
	go.children = {}

	return go
end

function GameObject:addComponent(c)
	c.go = self
	self.components[c.name] = c
	self[c.name] = c
end

function GameObject:update(dt)
	for k,c in pairs(self.components) do 	
		if c.update then
			c:update(dt)
		end
	end
	for k,ch in pairs(self.children) do
		if ch.update then
			ch:update(dt)
		end
	end
end

function GameObject:draw()
	for k,c in pairs(self.components) do
		if c.draw then
			c:draw()
		end
	end
	for k,ch in pairs(self.children) do
		if ch.draw then
			ch:draw()
		end
	end
end

function GameObject:addChild(ch)
	assert(ch.isInstance, "Child must be a instance")
	ch.parent = self
	self.children[#self.children+1] = ch
end

function GameObject:newInstance(args)
	args = args or {}
	local go = GameObject()
	setmetatable(go, GameObject)
	for k,v in pairs(self) do 	--Copia valores
		if v ~= self.components then
			go[k] = v
		end
	end

	for k,c in pairs(self.components) do
		go:addComponent(c:clone())
	end

	go.name = args.name or self.name

	if go.transform then
		go.transform.x = args.x or go.transform.x
		go.transform.y = args.y or go.transform.y
	end

	go.active = true
	go.isInstance = true

	return go
end

setmetatable(GameObject, {__call = function(_, ...) return new(...) end})