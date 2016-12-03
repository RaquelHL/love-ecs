--[[
	Scene: 
	-> Responsável por manter e gerenciar todos os gameObjects
	-> Chama as funções draw e update dos gameObjects
]]

Scene = {}
Scene.__index = Scene

local function new()
	local s = {}
	setmetatable(s, Scene)

	s.gameObjects = {}

	return s
end

function Scene:update(dt)
	for k,go in pairs(self.gameObjects) do
		--print("Updating ", go.name)
		go:update(dt)
	end
end

function Scene:draw()
	for k,go in pairs(self.gameObjects) do
		go:draw()
	end
end

function Scene:addGO(go)
	assert(go.isInstance, "GameObject needs to be an instance")
	self.gameObjects[#self.gameObjects+1] = go

end

function Scene:loadMap(name)
	map = require("maps."..name)
	map.tiles = {}

	for i,ts in ipairs(map.tilesets) do
		ts.texture = ResourceMgr.get("tileset", ts.image)
		local curID = ts.firstgid
		ts.lastid = curID + ts.tilecount
		for j=0, (ts.imageheight/ts.tileheight)-1 do
			for i=0, (ts.imagewidth/ts.tilewidth)-1 do
				map.tiles[curID] = love.graphics.newQuad(i*ts.tilewidth, j*ts.tileheight, ts.tilewidth, ts.tileheight, ts.imagewidth, ts.imageheight)
				curID = curID + 1
			end
		end
	end

	local function getTileSet(id)
		for i,ts in ipairs(map.tilesets) do
			if (id>=ts.firstgid and id < ts.lastid) then
				return i
			end
		end
		return 0
	end

	for k,l in pairs(map.layers) do
		if (l.properties.static) then 	--Estatico, nunca muda. Poe tudo num spriteBatch em um gameObject
			local layerGO = GameObject(l.name)	 
			local batchs = {}	--Precisa de um spritebatch para cada tileset
		    local curTile = 1

		    --Pra não criar um collider por tile, detecta os tiles adjacentes pra criar um collider só

		    local colX = 0	
		    local colY = 0
		    local colW = 0
		    local colCount = 0

		    for j=0,map.height-1 do
		    	for i=0,map.width-1 do
		    		if(l.data[curTile] ~= 0) then
			    		local tsID = getTileSet(l.data[curTile])
			    		if not batchs[tsID] then 	--Só cria um batch pro tileset se ele for usado
			    			batchs[tsID] = love.graphics.newSpriteBatch(map.tilesets[tsID].texture, map.width * map.height, "static")
			    		end
			    		batchs[tsID]:add(map.tiles[l.data[curTile]], i*map.tilewidth, j*map.tileheight)

			    		--Trata da criação do boxCollider

			    		if(l.properties.collision) then
				    		if(colW==0)then
				    			colX = i*map.tilewidth
				    			colY = j*map.tileheight
				    		end
				    		colW = colW + 1
				    	end
			    	end

			    	--Se tiver um tile vazio ou acabou o mapa, e os tiles anteriores tinham colisão, fecha um collider
			    	if ((l.data[curTile] == 0 or i == (map.width-1)) and l.properties.collision and colW>0) then
		    			colCount = colCount + 1
		    			local colliderGO = GameObject("col"..colCount, {BoxCollider(colW*map.tilewidth, map.tileheight, colX, colY)})
		    			layerGO:addChild(colliderGO)

		    			colW = 0
		    		
			    	end
			    	curTile = curTile + 1
		    	end
		    end

		    for i,b in ipairs(batchs) do
		    	local tsGO = GameObject("tileset "..i, {Renderer(b)})
		    	layerGO:addChild(tsGO)
		    end

		    self:addGO(layerGO:newInstance())

		end
	end
	if(map.backgroundcolor) then
		love.graphics.setBackgroundColor(map.backgroundcolor)
	end
	love.window.setMode(map.width*map.tilewidth, map.height*map.tileheight, flags)
end

setmetatable(Scene, {__call = function(_, ...) return new(...) end})