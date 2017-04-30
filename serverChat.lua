local json = require "json"
local socket = require "socket"
require('tables')
local udp = socket.udp()
udp:settimeout(0)
udp:setsockname("*", 2021)

local chat = {}
local players = {}
controlecor = 0
local data, msg, porta
local idUsuario, cmd, pecas

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
    data, ip_cliente, porta = udp:receivefrom()
    local numeroUsuarios =  tablelength(chat)
    if data and numeroUsuarios < 3 then
      cmd, idUsuario, nomeUsuario, textoMensagem = data:match("^(%S*) (%S*) (%S*) (.*)")
      if cmd == "novaMensagem" then
        chat[idUsuario] = {ip = ip_cliente, porta = porta}
        players[numeroUsuarios] = idUsuario
        if players[1] == idUsuario then
          player = 'player1'
        else
          player = 'player2'
        end
        local msg = {nomeUsuario, textoMensagem, player}
        if textoMensagem ~= '' then
          for key, value in pairs(chat) do
              udp:sendto(json.encode(msg), value.ip, value.porta)
          end
        end
      end
    end
  until not data
  socket.sleep(0.1)
end
