local teste = Scene("teste")

--Nesse arquivo ficaria mais o codigo da GUI da cena

local function init()
	teste:loadMap("level1")	--Carrega um mapa da pasta maps
	player = GameObject("Player", {Renderer(), SpriteAnimator("idle"), BoxCollider(), CharacterMotor(), PlayerInput()}):newInstance({pos = vector(400,50)})

	teste:addGO(player)

	return teste
end

return init()