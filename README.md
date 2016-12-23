# love-ecs
Implementação no LÖVE de um sistema entidade/componente, junto com outras funcionalidades que facilitam o desenvolvimento de jogos.

### Exemplo
```lua
ECS = require("ecsCore")

function love.load()
	--Cria uma nova scene chamada 'testScene'
	testScene = Scene("testScene")
	
	--Cria novo GameObject chamado 'tileGO'
	tile = GameObject("tileGO")

	--Pega a textura 'tile.png' com o ResourceManager
	tileTex = ResourceMgr.get("texture", "tile")

	--Adiciona um componente 'Renderer' ao tile, passando a textura
	tile:addComponent(Renderer(tileTex))

	--Adiciona uma instância do tile na posição [200, 140]	
	testScene:addGO(tile:newInstance({pos = vector(200, 140)}))

	--Carrega a scene que criamos
	ECS:loadScene("testScene")
end

function love.update(dt)
	--Repassa o update para o sistema
	ECS:update(dt)
end

function love.draw()
	--Repassa o draw para o sistema
	ECS:draw()
end
```
Neste exemplo, simplesmente desenhamos uma textura(tile.png) na posição [200, 140]. Parece que estamos apenas complicando as coisas simples, mas à medida em que o código ficar mais complexo essa estrutura vai acabar na verdade simplificando as coisas.


### Estrutura
----------
![Estrutura](http://i.imgur.com/dPgHurY.png)
Basicamente, o sistema deixa uma `Scene` ativa por vez, que funciona como um estado de jogo(menu, loading, jogo, etc). Uma `Scene` é composta por `GameObjects`, que são "entidades de jogo". Estes podem ter componentes e filhos(outras entidades). Tudo no jogo é uma entidade, o personagem, o inimigo, a parede, o chão, etc. Cada `GameObject` é responsável por realizar sua função. Por exemplo, a função do chão é desenhar a textura de chão onde ele está, e não deixar outras entidades passarem por ele. Essas funções são realizadas pelos componentes do chão. Então ele precisa ter um componente pra desenhar a textura(`Renderer`) e outro para não deixar nada passar(`BoxCollider`). A parede é a mesma coisa. 

>Todos os `GameObjects` são criados com um componente já padrão: `Transform`. Sua função é guardar informações básicas de posicionamento, orientação e escala.

Já um personagem precisa realizar mais funções, como por exemplo:
- Ele pode ter uma animação quando ele está andando. Essa é a função de outro componente(`SpriteAnimator`), que carrega uma animação e vai mudando a textura do `Renderer` de acordo com o frame atual da animação.
- Ele precisa ser controlavel(andar, pular, morrer...). Essa é a função de outro componente, que vai gerenciar a velocidade do personagem e atualizar a posição atual do `gameObject` a todo `:update()`
- O jogador precisa controlar o personagem. Outro componente vai verificar a entrada do jogador e repassar os comandos para o controlador do personagem.

>Tenha em mente que estes dois ultimos componentes variam de jogo para jogo, por isso não fazem parte dos componentes básicos.

Outras entidades no jogo vão precisar realizar outras funções. Por isso, o sistema deixa fácil a criação de novos componentes. Mais adiante isso será explicado com mais detalhes.

##### Percurso das callbacks

![a](http://i.imgur.com/SZvOop6.png)
Os componentes precisam ser chamados para que possam de fato realizar sua função. O diagrama acima explica o percurso das chamadas, desde a callback do LÖVE(`love.draw()`) até as callbacks de cada componente. O mesmo percurso é feito para o `love.update(dt)`.

--A fazer: detalhar cada função
##### `ecsCore`
Único, inicilizado no main.lua. É o núcleo do sistema. Ele tem registrado todas as `Scenes` criadas, e é responsável por chamar as funções da `Scene` atual, o que desencadeia todas as chamadas que acabam chegando em todos os componentes.
Uso:
```lua
ECS = require("ecsCore")
ECS:loadScene()
ECS:update(dt)
ECS:draw()
```

##### `Scene`
A ideia é existir uma para cada estado de jogo(menu, loading, jogo, etc). Guarda uma lista de GameObjects, e é responsável por repassar as chamadas do `ecsCore` para cada gameObject em sua lista.
Uso:
```lua
scene = Scene(nome)
scene:addGO(gameobject)
scene:removeGO(gameobject
scene:loadMap(nomeMapa)
```

##### `GameObject`
Uma entidade no jogo, ou seja, qualquer coisa individual no jogo (personagem, inimigo, chão, parede, etc). Serve como um recipiente para componentes e pode ter `GameObjects` filhos. É reponsável por repassar chamadas da `Scene` para seus componentes e filhos
Uso:
```lua
go = GameObject(nome, <componentes>)
go:addComponent(componente)
go:removeComponent(componente)
go:addChild(gameobject)
go:newInstance(<args>)
go:destroy()
```

##### `Component`
Não faz nada por si mesmo, mas oferece uma base para a criação de componentes especializados, que contém a lógica do jogo em si. Ele repassa as chamadas do `GameObject` ao qual ele pertence às callbacks do componente criado, caso existam.

##### Criação de componentes
###### `Component(nome)`
> É o construtor do componente; Ele inicializa todas as funções e propriedades básicas que são comuns a todos os componentes.

###### `component:require(outroComponente)`
> É usado para indicar que o componente sendo criado necessita de outro componente para seu funcionamento. Assim, haverá um erro caso esse componente seja colocado em um gameObject sem o componente indicado na hora em que o gameObject for instanciado. Essa verificação é feita antes de chamar a callback `:init()` do componente.

Exemplo:
```lua
-> playerInput.lua
PlayerInput = Component("input")
PlayerInput:require("characterMotor")

<callbacks>
```
Nesse caso, estamos criando um componente para controlar um personagem usando a entrada do jogador. Note que não faz sentido colocarmos esse componente em um gameObject que não é um personagem, então usamos o `PlayerInput:require("characterMotor")`("characterMotor" sendo o nome do componente que controla um personagem) para garantir que isso não aconteça.

##### Callbacks suportadas:
Todas as callbacks são opcionais, só são chamadas caso existam.
###### `:new(...)`
> É chamada logo depois da criação da base do componente.
Serve pra inicializar as propriedades iniciais do componente
Variáveis passadas no codigo principal são repassadas diretamente para esta função

###### `:init()`
>É chamada pelo `GameObject` ao qual o componente pertence quando ele está sendo instanciado
Serve para inicializar variáveis que dependem de algo externo, como outro componente

###### `:update(dt)`
> É chamada a todo `love.update(dt)`, como explicado anteriormente.
É aqui que vai a lógica principal do componente.

###### `:draw()`
> É chamada a todo `love.draw()`, como explicado anteriormente.
Se o componente desenha alguma coisa na tela, é aqui que fica o código pra desenhar.
Assim como no love.draw(), não é recomendado fazer nenhuma lógica de jogo aqui, apenas desenhar.

###### `:destroy()`
>É chamada quando o `GameObject` ao qual o componente pertence, quando ele está sendo destruído
Serve pra finalizar alguma coisa com alguma coisa externa, caso necessário

No exemplo do componente `PlayerInput`, precisamos de apenas uma callback:
```
function PlayerInput:update(dt)
    --Se o jogador aperta as setas direita/esquerda, chama a função :move(dir) da controladora do personagem para a direção desejada
	if (love.keyboard.isDown("right")) then
		self.go.characterMotor:move(1)
	end
    if (love.keyboard.isDown("left")) then
	    self.go.characterMotor:move(-1)
	end
	--Se o jogador aperta a seta pra cima, faz o personagem pular
	if (love.keyboard.isDown("up") and self.go.characterMotor.isGrounded) then
		self.go.characterMotor:jump()
	end
end
```

#### Componentes padrão
##### `Transform`
Guarda a posição(`pos`), orientação(`o`) e escala(`scale`) local e global(real).
O motivo dessas propriedades serem separadas em local e global é para quando o `GameObject` é filho de outro `GameObject`. Quando não existe um pai, os valores locais são iguais aos valores globais. 
Quando existe um pai, os valores locais são do espaço local do pai, e os valores globais os locais transformados para o espaço global, levando em consideração a posição, orientaão e escala do pai:
![espaço global e local](http://i.imgur.com/rPWwYQY.png)
A lógica do jogo modifica apenas as propriedades locais. Caso, por algum motivo, seja necessário modificar as propriedades globais, é preciso fazer a transformação manualmente para a posição local que é referente a posição global desejada.(Porém, no momento, não há funções para auxiliar essa transformação)
Além disso, não é recomendado a modificação direta das propriedades. Ao invés disso, use as funções do `Transform`.

###### Funções:
###### `:move(x, <y>)`
Muda a posição relativa a posição atual. Se a posição é [50,40] e for chamado `:move(10, 30)`, a nova posição é [60,70]. Como parâmetro, podem ser passados dois números ou um `vector`.
###### `:moveTo(x, <y>)`
Muda a posição diretamente para [x,y], descartando a posição atual. Como parâmetro, podem ser passados dois números ou um `vector`.
###### `:rotate(o)`
Rotaciona relativamente à orientação atual. Como parâmetro, se passa o ângulo em radianos.
###### `:rotateTo(o)`
Muda a orientação atual para `o`, descartando a orientação atual. Como parâmetro, se passa o ângulo em radianos.
###### `:lookAt(a)`
Muda a orientação para que o GameObject esteja "olhando" para `a`. `a` pode ser um componente `Transform`, um `GameObject` ou um `vector`.
###### `:setScale(x, y)`
Muda a escala para [x,y], descartando a escala atual.
###### `:forward()`
Retorna um `vector` de direção apontado para a frente do `Transform`
###### `:right()`
Retorna um `vector` de direção apontado para a direita do `Transform`

-- A fazer
##### `Renderer`

##### `BoxCollider`
>

##### `SpriteAnimator`
>

##### `Particle`
>