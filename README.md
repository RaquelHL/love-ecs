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
![espaço global e local](http://i.imgur.com/V3ha0s5.png)

A lógica do jogo modifica apenas as propriedades locais. Caso, por algum motivo, seja necessário modificar as propriedades globais, é preciso fazer a transformação manualmente para a posição local que é referente a posição global desejada.(Porém, no momento, não há funções para auxiliar essa transformação)
Além disso, não é recomendado a modificação direta das propriedades. Ao invés disso, use as funções do `Transform`.

###### Construtor: `Transform(x, y, o, sx, sy)`
`x` e `y`: localPos inicial
`o`: localO inicial(em radianos)
`sx` e `sy`: localScale inicial

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

##### `Renderer`
Desenha uma textura na tela
###### Construtor: `Renderer(<texture>, <args>)
`texture`: Objeto do tipo `Image` ou nome da imagem que o `Renderer` vai desenhar.
`args`: Tabela com argumentos opcionais:
- `pivot`: Qual vai ser o pivô para rotacionar a textura. Pode ser `top_left`, `top`, `top_right`, `left`, `center`, `right`, `bottom_left`, `bottom` ou `bottom_right`. O padrão é `center`.
- `mirror`: Se a textura deve ser desenhada espelhada ou não. O padrão é `false`.
- `color`: A Cor. O padrão é `Color(255)`(branco)
###### Funções
###### `:setTexture(texture, <quad>)`
Para indicar a textura a ser desenhada. `texture` pode ser um objeto `Image` do löve ou um nome de uma imagem. `quad` é necessário caso a textura seja um spritesheet.

##### `BoxCollider`
Solução de colisão temporária, usando a biblioteca `bump.lua`
###### Construtor: `BoxCollider(<w>, <h>, <offset>)`
`w` e `h` são a largura e altura da caixa de colisão. Caso sejam omitidos, esses valores são obtidos com a textura do Renderer, caso ele exista.
`offset` é um `vector` da a posição esquerda superior desejada da caixa, em relação a posição x e y do `Transform`

##### `SpriteAnimator`
Carrega uma `anim` e vai mudando a textura do `Renderer` de acordo com o frame da animação.
###### Construtor: `SpriteAnimator(<anim>)`
`anim` é, opcionalmente, a animação carregada inicialmente.

###### Funções:
###### `:setAnim(anim)`
Carrega a `anim`
###### `:nextFrame()`
Avança um frame na animação atual; Volta para o primeiro frame se `anim.loop = true`
###### `:gotoFrame(f)`
Pula para o frame `f` da `anim` atual, caso o frame seja válido.

##### `Particle`
Vai ser reescrita em breve.

### GUI
---
##### `guiCore`
É o núcleo da lib  para interface. Não está relacionada diretamente com o sistema entidade/componente.
Uso:
```lua
GUI = require("guiCore")
GUI:draw(widget)
GUI:newPanelType(name, tex, borderS, centerS)
GUI:requestFocus(wdID, e)
GUI:mousepressed(wd, x, y, b)
GUI:textinput(t)
GUI:keypressed(k)
GUI:wheelmoved(x, y)
```

##### `Widget`
É a base para o componente principal da interface. Pode ter widgets filhos. Recebe as chamadas do `guiCore` e do pai.
Atualmente existem tais widgets:
###### `Frame`


###### `Label`


###### `Button`


###### `TextBox`




### Outros
#### ResourceManager
Foi criado para acabar com o problema de redundância na criação de recursos. Imagine, por exemplo, uma textura que é usada em duas partes diferentes de um jogo. Cada parte não sabe da existência da outra, então cada uma cria uma nova `Image` da textura, o que é dispendioso.
O que o ResourceManager faz é manter uma tabela com todos os recursos do jogo. Assim, quando uma parte do jogo quer uma textura, ele chama o `ResourceMgr.get`, que retorna a textura se ela já existe, ou cria a textura, coloca na tabela de recursos, e a retorna. Quando a outra parte do jogo precisar dessa mesma textura, o ResourceManager vai retornar a mesma que ele já tinha criado antes.
###### Funções:
**`ResourceManager.get(type, name)`**
Verifica a existencia do recurso do tipo `type` e nome `name`, tenta criar o recurso caso ele não exista, e retorna o recurso

**`ResourceManager.add(type, name)`**
Vai adicionar o recurso do tipe `type` e nome `name` caso ele não exista.

###### Tipos suportados:
**`texture`**: Textura normal. O ResourceManager tenta achar a textura dentro da pasta na variável `ResourceManager.textureFolder`, que é `textures` por padrão.

**`animSheet`**: Arquivo lua de informação sobre animações em sprites. 
Estrutura: 
```lua
->animSheet.lua
return {
    {
        name = "nome da animação",
    	texture = [Image da spritesheet],
    	size = [quantidade de frames],
    	timestep = [segundos entre frames],
    	loop = [se volta pro começo ao chegar ao fim],
    	tilewidht = [largura do quad],
    	tileheight = [altura do quad],
    	frames = {
    		{quad = love.graphics.newQuad(...)},
    		...
    	}
    },
    ...
}
```

**`anim`**: Animação criada anteriormente ao carregar um `animSheet`

**`scene`**: Arquivo lua que retorna uma `Scene`. O ResourceManager procura na pasta na variável `ResourceManager.sceneFolder`, que é `scenes` por padrão.

#### debugTool
Ferramenta para auxiliar na depuração do jogo. É composta de um inspector e um console. O inspector analisa um `GameObject` e mostra todos os seus componentes e suas respectivas propriedades em um menu lateral. O console mostra mensagens passadas para o comando `print()`, e tem um textBox onde é possível executar comandos lua dentro do jogo, sendo possível acessar todas as variáveis globais, chamar funções, entre outros. "f2" é a tecla padrão para mostrar/esconder a ferramenta.
###### Funções:
**`debugTool.toggle()`**
Mostra/esconde a ferramenta.
**`debugTool.initInspector(go)`**
Inicializa o inspector para mostrar as informações do gameObject `go` 
**`pprint(m, <n>)`**
Um print que mostra a mensagem `m` na tela. A mensagem é excluída após ser desenhada, portanto é uma boa função para monitar valores que mudam constantemente ao chamar `pprint(m)` a todo `update()`. Caso seja necessário que o valor fique na tela constantemente, é possível passar o parâmetro `n`, que dá um nome à mensagem. Mensagens com nome não são excluídas após serem desenhadas, mas podem ser alteradas chamando `pprint()` novamente usando o mesmo nome.