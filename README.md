# Game multiplayer: Yoté with lov2d and LuaSockets

I present to you Yoté, a very interesting board game, the rules of the game are described in the README. Remembering that the game is not fully implemented and the important thing is to contribute to the community with a multiplayer game, with real-time upgrading, turn control, sockets use and chat implementation. Thank you and have fun.

# Images of the game

# Dependencies
### What do I need to run the game?
First of all, you need to download some **dependencies**:
* Lenguage Lua
* LuaSockets
* Framework Love2d

**Love2d**: [install Love2d](https://love2d.org/#download "install Love2d")
On linux: liblove/love/dgb

Install the **lenguage Lua** on your PC
On linux: sudo apt-get install lua5.2

Install the **LuaSockets** on your PC
On linux: sudo apt-get install lua-socket

Success, **configured!** :)

# Run

I'll teach in **linux**, but it can run on others, okay?

Open the **terminal**
Go to the path of the game, in my case:
* *cd /var/www/lua/game-multiplayer-lua*

In the game we have the server running on two different ports, one for the logic of the game and another for the chat, run the two scripts in Lua for the operation of the servers:
* lua server.lua
* lua serverChat.lua

Success, the server is running! Let's run the game by running the command (In the previous folder):
* love game-multiplater-lua


The game will open, place your name, the game will wait for the second player, you can open another terminal and run the game again simulating the second player :)

**Success!**

# Libraries used
ListBox DarkMetalic: https://github.com/darkmetalic/ListBox
SUIT: https://love2d.org/wiki/SUIT

# Game Rules
Yoté follows the following rules (not all of them are yet implemented):
* House player has 12 pieces that start off the board
* House player puts one piece at a time
* The pieces can only move forward and side, never diagonally
* The player can eat his opponent's piece by passing a house over it
* If possible you can eat multiple pieces in the same move
* The player who ate an opponent's piece can eliminate any other piece of the opponent on the board
* Win the player who eats all the pieces or totally block the opponent

# Current State

**Is implemented**:
* Multiplayer, including watching the opponent's real-time move
* Validation of plays
* Eating pieces
* Turn control
* Chat
* Giving up on departure

**Missing to be implemented**:
* Eat multiple pieces
* Eliminate an opponent's piece while eating a piece
* Define the winner
* Delete some bugs


