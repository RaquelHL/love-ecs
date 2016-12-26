vector = {}
vector.__index = vector

local function new(x, y)
	local v = {}
	setmetatable(v, vector)
	v.isVector = true
	v.x = x or 0
	v.y = y or 0
	return v
end

function vector.__tostring(a)
	return "["..a.x..","..a.y.."]"
end

function vector.__unm(a)
	return new(-a.x, -a.y)
end

function vector.__add(a,b)
	assert(b.isVector, "nao é vetor")
	return new(a.x+b.x, a.y+b.y)
end

function vector.__sub(a,b)
	assert(b.isVector, "Vector expected; Got "..type(b))
	return new(a.x-b.x, a.y-b.y)
end

function vector.__mul(a,b)
	if (type(b) == "number") then
		return new(a.x*b, a.y*b)
	else
		if (b.isVector) then
			return new(a.x*b.x, a.y*b.y)
		else
			error("Number or vector expected; Got "..type(b))
		end
	end
end

function vector.__div(a,b)
	assert(type(b) == "number", "Number expected; Got "..type(b))
	return new(a.x/b, a.y/b)
end

function vector.__eq(a,b)
	assert(b.isVector, "Vector expected; Got "..type(b))
	return a.x == b.x and a.y == b.y
end

function vector:rotate(o)
	self.x = math.cos(o) * self.x - math.sin(o) * self.y
	self.y = math.sin(o) * self.x + math.cos(o) * self.y
	return self
end

function vector.magnitude(a)
	return vector.dist(vector.zero, a)
end

function vector.dist(a,b)
	assert(a.isVector and b.isVector, "Vector expected; Got "..type(a).." and "..type(b))
	return math.sqrt(math.pow(a.x-b.x,2)+math.pow(a.y-b.y,2))
end

function vector.fromAngle(r)
	assert(type(r) == "number", "Number expected; Got "..type(r))
	return new(math.cos(r),math.sin(r))
end

function vector.angleTo(a, b)
	return math.atan2(b.y-a.y, b.x-a.x)
end

function vector.clone(a)
	return vector(a.x,a.y)
end

setmetatable(vector, {__call = function(_, ...) return new(...) end})


--Constantes
vector.zero = vector(0,0)
vector.forward = vector(1,0)
vector.back = vector(-1,0)

vector.up = vector(0,-1)
vector.right = vector(1,0)
vector.down = vector(0,1)
vector.left = vector(-1,0)