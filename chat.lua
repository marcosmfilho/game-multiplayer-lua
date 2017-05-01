local chat = {}
local utf8 = require("utf8")
local suit = require 'suit'
local socket = require('socket')
local json = require "json"
local updaterate = 0.1
local  input = {text = ""}

local address, port = 'localhost', 2021

function chat.load()
  udpChat = socket.udp()
  udpChat:settimeout(0)
  udpChat:setpeername(address, port)
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
          newMessage = json.decode(data)
          local msg = newMessage[1] .. ':  ' .. newMessage[2]
          player = newMessage[3]
          list:additem(msg  ,"",true, player)
        elseif msg ~= "timeout" then print("Unknown network error: " .. tostring(msg)) end
    until not data
end

function chat.keypressed(key, idUser, nameUser)
    suit.keypressed(key)
    list:key(key,true)
    if key == "return" and input.text ~= "" then
        local datagrama = string.format("%s %s %s %s", 'newMessage',idUser,nameUser,input.text)
        udpChat:send(datagrama)
        input.text = ""
    end
end

function chat.wheelmoved(x,y)
  list:mousew(x,y)
end

return chat
