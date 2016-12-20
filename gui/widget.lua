--[[

]]
Widget = {}
local meta = {}
meta.__index = meta

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

		nWd.realX = nWd.x
		nWd.realY = nWd.y
		nWd.realW = nWd.w
		nWd.realH = nWd.h

		nWd.active = true

		nWd:refresh()	
		
		return nWd
	end

	setmetatable(wd, {__call = function(_, ...) return wd:newWidget(...) end})
	return wd
end

--Faz com que seja possível chamar a função new assim: Component(); Ao inves de assim: Component.new()
setmetatable(Widget, {__call = function(_, ...) return new(...) end})