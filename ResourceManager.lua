local ResourceManager = {}

local resources = {}

local creatorFunctions = {
	texture = function(name)
		return love.graphics.newImage("textures/"..name)
	end,
	tileset = function(name)
		local file = string.gsub(name, "../", "", 1)
		return love.graphics.newImage(file)
	end
}

ResourceManager.get = function(type, name)
	if not resources[type] then
		resources[type] = {}
	end
	if not resources[type][name] then
		print("Adding "..name.."("..type..")")
		resources[type][name] = creatorFunctions[type](name)
	end

	return resources[type][name]
end

ResourceManager.add = function(type, name)
	if creatorFunctions[type] then
		creatorFunctions[type](name)
	else
		if (type == "animsheet") then
			if not resources.anim then
				resources.anim = {}
			end
			local animS = require("textures."..name)
			for i,a in ipairs(animS) do
				print("Adding "..a.name.."(anim)")
				resources.anim[a.name] = a
			end
		end
	end
end

return ResourceManager