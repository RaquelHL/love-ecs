local teste = Scene("teste")

--Nesse arquivo ficaria mais o codigo da GUI da cena

local function init()

	player = GameObject("Player", {Renderer(), SpriteAnimator("idle"), BoxCollider(), CharacterMotor(), PlayerInput()}):newInstance({pos = vector(400,50)})

	teste:loadMap("level1")	--Carrega um mapa da pasta maps

	teste:addGO(player)
	return teste
end
local cont = 0

function teste:update(dt)	--Necessário?
	
end


return init()