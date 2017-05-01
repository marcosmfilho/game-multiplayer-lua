local json = require "json"
local socket = require "socket"
require('tables')
local udp = socket.udp()
udp:settimeout(0)
udp:setsockname("*", 2021)

local chat = {}
local players = {}
local data, msg, port
local idUser, cmd, pieces

function tablelength(T)
  counter = 0
  if T ~= nil then
    for index in pairs(T) do
        counter = counter + 1
    end
  end
  return counter
end

while true do
  repeat
    data, ip_cliente, port = udp:receivefrom()
    local numberUsers =  tablelength(chat)
    if data and numberUsers < 3 then
      cmd, idUser, nameUser, text = data:match("^(%S*) (%S*) (%S*) (.*)")
      if cmd == "newMessage" then
        chat[idUser] = {ip = ip_cliente, port = port}
        players[numberUsers] = idUser
        if players[1] == idUser then
          player = 'player1'
        else
          player = 'player2'
        end
        local msg = {nameUser, text, player}
        if text ~= '' then
          for key, value in pairs(chat) do
              udp:sendto(json.encode(msg), value.ip, value.port)
          end
        end
      end
    end
  until not data
  socket.sleep(0.1)
end
