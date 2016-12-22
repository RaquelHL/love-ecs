local ResourceManager = {}

local resources = {}

ResourceManager.textureFolder = "textures"
ResourceManager.scenesFolder = "scenes"

local creatorFunctions = {
	texture = function(name)
		local img = nil
 		if(love.filesystem.exists(ResourceManager.textureFolder.."/"..name)) then
 			img = love.graphics.newImage(ResourceManager.textureFolder.."/"..name)
 		else
 			if love.filesystem.exists(ResourceManager.textureFolder.."/"..name..".png") then
 				img = love.graphics.newImage(ResourceManager.textureFolder.."/"..name..".png")
 			end
 		end
 		return img
	end,
	tileset = function(name)
		local file = string.gsub(name, "../", "", 1)
		return love.graphics.newImage(file)
	end,
	animsheet = function(name)
		if not resources.anim then
			resources.anim = {}
		end
		local animS = require(ResourceManager.textureFolder.."."..name)
		for i,a in ipairs(animS) do
			print("Adding "..a.name.."(anim)")
			resources.anim[a.name] = a
		end
		return animS
	end,
	anim = function(name)
		error("Animation '"..name.."' not found!")
	end,
	scene = function(name)
		return dofile(ResourceManager.scenesFolder.."/"..name..".lua")
	end
}

ResourceManager.get = function(type, name)
	ResourceManager.add(type, name)
	return resources[type][name]
end

ResourceManager.add = function(type, name)
	if not resources[type] then
		resources[type] = {}
	end
	if not resources[type][name] then
		print("Adding "..name.."("..type..")")
		resources[type][name] = creatorFunctions[type](name)
	end
end

return ResourceManager