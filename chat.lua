local chat = {}
local utf8 = require("utf8")
local suit = require 'suit'
local socket = require('socket')
local json = require "json"
local endereco, porta = 'localhost', 2021
local updaterate = 0.1
local controleTempo
local  input = {text = ""}

function chat.load()
  udpChat = socket.udp()
  udpChat:settimeout(0)
  udpChat:setpeername(endereco, porta)
  controleTempo = 0
  love.keyboard.setKeyRepeat(true)
  list = require 'listbox'
  tlist = {x=475, y=390,font=font,ismouse=true,
                 w=500,h=150,showindex=true, rounded=true,
                 hor=true,fcolor={102, 0, 204},bordercolor={0, 0, 153},
                 bgcolor={230, 250, 255},selectedcolor={102, 204, 255},
                 fselectedcolor={102, 0, 204},radius=8,adjust=true,expand=false,
                 font = love.graphics.newFont('fonts/accid.ttf',22)}
  list:newprop(tlist)
  player = ''
end

function chat.textinput(t)
    if string.len(input.text) < 45 then
      suit.textinput(t)
    end
end

function chat.draw()
  suit.draw()
  list:draw(player)
end

function chat.update(dt)
    list:update(dt)
    suit.layout:reset(475,555)
    suit.Input(input, suit.layout:row(500,30))
    suit.layout:row()
    repeat
        data, msg = udpChat:receive()
        if data then
          novaMensagem = json.decode(data)
          local msg = novaMensagem[1] .. ':  ' .. novaMensagem[2]
          player = novaMensagem[3]
          list:additem(msg  ,"",true, player)
        elseif msg ~= "timeout" then print("Unknown network error: " .. tostring(msg)) end
    until not data
end

function chat.keypressed(key, idUsuario, nomeUsuario)
    suit.keypressed(key)
    list:key(key,true)
    if key == "return" and input.text ~= "" then
        local datagrama = string.format("%s %s %s %s", 'novaMensagem',idUsuario,nomeUsuario,input.text)
        udpChat:send(datagrama)
        input.text = ""
    end
end

function chat.wheelmoved(x,y)
  list:mousew(x,y)
end

return chat
