--[[
	GameObject: Classe base para todo o sistema
	-> Mantém e gerencia seus componentes
	-> É responsável pelos seus filhos
]]

GameObject = {}
GameObject.__index = GameObject

GameObject.debugCollider = false	--Desenha retangulos que representam a posição real dos colliders

local function new(name, components)
	components = components or {}
	local go = {}
	setmetatable(go, GameObject)

	go.isGameObject = true
	go.isInstance = false
	go.nInstances = 0	--Por enquanto só pra dar nome pras instancias
	go.name = name or "GameObject"
	go.components = {}

	go.toDestroy = false

	go:addComponent(Transform()) --	Teoricamente todo gameObject precisa de um transform
	
	for k,c in pairs(components) do
		go:addComponent(c)
	end
	go.children = {}

	return go
end

function GameObject:addComponent(c)
	if self.components[c.name] then
		print("Tentou adicionar mais de um componente("..c.name..") do mesmo tipo!")
		return
	end
	c.go = self
	self.components[c.name] = c
	self[c.name] = c

	if self.isInstance then
		c:init()
	end
end

function GameObject:removeComponent(c)
	local name = c.name or c
	self.components[name] = nil
	self[name] = nil
end

function GameObject:init()
	for k,c in pairs(self.components) do
		c:initComp()
	end
	for k,ch in pairs(self.children) do
		if ch.init then
			ch:init(dt)
		end
	end

end

function GameObject:update(dt)
	for k,c in pairs(self.components) do 	
		if c.update  and not self.toDestroy then 	--Se um componente destruir o GO, os proximos componentes podem dar problema 
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
	ch.parent = self
	if self.scene then
		ch.scene = self.scene
	end
	self.children[#self.children+1] = ch
end

function GameObject:setScene(s)
	self.scene = s
 	for k,ch in pairs(self.children) do
 		ch.setScene(s)
 	end
end

function GameObject:destroy()
	self.toDestroy = true
 	for k,c in pairs(self.components) do 	
 		if c.destroy then
 			c:destroy()
 		end
 	end
 	for k,ch in pairs(self.children) do
 		ch:destroy()
 	end
 	self.scene:removeGO(self)
 end

setmetatable(GameObject, {__call = function(_, ...) return new(...) end})