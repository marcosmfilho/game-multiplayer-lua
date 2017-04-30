# Game multiplayer: Yoté com lov2d e LuaSockets
Apresento para vocês o Yoté, que um jogo parecido com Damas, mas com algumas regras diferentes, porém, o mais importante é a implementação multiplayer, com LuaSocktes, controle de turno de jogadores, atualização de peças e chat para comunicação entre os jogadores. Aproveitem! :)

Manda uma **estrelinha(star)** aí, please :D

# Imagens do jogo

# Dependências
### O que preciso para rodar o Yoté multiplayer?
Antes de tudo, é preciso baixar algumas **dependências**:
* Linguagem Lua
* LuaSockets
* Framework Love2d para desenvolviemnto de jogos em Lua

**Love2d**: [Instalar Love2d](https://love2d.org/#download "Instalar Love2d")
No caso do linux é preciso baixar: liblove/love/dgb

Instale a **linguagem Lua** na sua máquina
No o processo é bem simples: sudo apt-get install lua5.2

Instale o **LuaSockets** na sua máquina
Linux: sudo apt-get install lua-socket

Pronto, seu ambiente está **configurado!** :)

# Rodando o jogo

Ensinarei no **Linux** mas pode ser adequado para Windows também, certo? 

Abra o **terminal**
Siga para a pasta di projeto, no meu caso:
* *cd /var/www/lua/game-multiplayer-lua*

No jogo, nós temos o servidor rodando em duas portas diferentes, uma para o jogo em si e outra para o chat, vamos rodá-las pelo terminal, executando os comandos:
* lua server.lua
* lua serverChat.lua

Pronto, o servidor está rodando perfeitamente, agora vamos executar o jogo, execute o comando na pasta anterior do projeto:
* love game-multiplater-lua

O jogo irá abrir, você coloca seu nome e ele ficará aguardando o segundo jogador entrar, você pode abrir outro terminal, executar o mesmo comando e abrir outro player, você pode jogar consigo mesmo para testar :)

**Pronto, jogo rodando!**

# Bibliotecas utilizadas
Contei com a ajuda de algumas implementações disponibilizadas pela nossa sensacional comunidade Lua.
Para o chat, utilizei o ListBox DarkMetalic: https://github.com/darkmetalic/ListBox
Para os inputs, utilizei o SUIT: https://love2d.org/wiki/SUIT

# Regras do jogo
O Yoté segue as seguintes regras (nem todas estão implementadas ainda):
* Casa jogador possui 12 peças que começam fora do tabuleiro
* Casa jogador põe uma peça por vez
* As peças só podem andar para frente e par o lado, jamais na diagonal
* O jogador pode comer a peça de seu adversário passando uma casa por cima dela
* Se possível pode comer múltiplas peças na mesma jogada
* O jogador que comeu uma peça do adversário pode elimnar outra qualquer peça do adversário no tabuleiro
* Ganha o jogador que comer todas as peças ou bloquear totalmente o adversário

# O que está implementado e falta ser implementado?

**Está implementado**:
* Multiplayer, inclusive vendo a jogada em tempo real do adversário
* Validação de jogadas
* Comer peças
* Controle de turno
* Chat
* Desistir de partida

**Falta ser implementado**:
* Comer múltiplas peças
* Eliminar uma peça do adversário ao comer uma peça
* Definir o ganhador
* Eliminar alguns bugs


