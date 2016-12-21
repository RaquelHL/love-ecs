--[[

]]
Widget = {}
local meta = {}
meta.__index = meta

local nextID = 1
local widgetList = {}

local function new(default)
	local wd = {}
	setmetatable(wd, meta)

	wd.isWidget = true

	wd.newWidget = function(self, gui, args)
		assert(gui.isGUI, "Use a colon to call this function")
		local nWd = {}
		wd.gui = gui
		
		args = args or {}
		local defaultWd = default()
		for k,v in pairs(self) do
			nWd[k] = v
		end
		for k,v in pairs(defaultWd) do
			nWd[k] = args[k] or v
		end

		nWd.x = nWd.x or args.x or 0
		nWd.y = nWd.y or args.y or 0
		nWd.w = nWd.w or args.w or 0
		nWd.h = nWd.h or args.h or 0

		if (nWd.x < 0) then
			nWd.x = love.graphics.getWidth() + nWd.x
		end
		if (nWd.y < 0) then
			nWd.y = love.graphics.getHeight() + nWd.y
		end

		if nWd.w == "parent" then
			nWd.w = 9999
		end
		if nWd.h == "parent" then
			nWd.h = 9999
		end
		if nWd.maxW == "parent" then
			nWd.maxW = 9999
		end
		if nWd.maxH == "parent" then
			nWd.maxH = 9999
		end

		if nWd.h == "content" then
			nWd.h = -1
		end


		nWd.realX = nWd.x
		nWd.realY = nWd.y
		nWd.realW = nWd.w
		nWd.realH = nWd.h

		nWd.active = true

		nWd:refresh()	
		
		nWd.id = nextID
		widgetList[nWd.id] = nWd
		nextID = nextID + 1

		return nWd
	end

	setmetatable(wd, {__call = function(_, ...) return wd:newWidget(...) end})
	return wd
end

function Widget.get(id)
	return widgetList[id]
end

--Faz com que seja possível chamar a função new assim: Component(); Ao inves de assim: Component.new()
setmetatable(Widget, {__call = function(_, ...) return new(...) end})