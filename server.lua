local json = require "json"
local socket = require "socket"
require('table')
require('tables')
local udp = socket.udp()
udp:settimeout(0)
udp:setsockname("*", 2020)

local mundo = {}
local players = {}
local data, msg, porta
local nomeUsuario, idUsuario, cmd, pecas

-- pecas iniciais para o player 1
p1 = {nome = 'p1',x = 530, y = 260,radius = 35,cor={102, 0, 204},posicao = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p2 = {nome = 'p2',x = 610, y = 260,radius = 35,cor={102, 0, 204},posicao = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p3 = {nome = 'p3',x = 690, y = 260,radius = 35,cor={102, 0, 204},posicao = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p4 = {nome = 'p4',x = 770, y = 260,radius = 35,cor={102, 0, 204},posicao = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p5 = {nome = 'p5',x = 850, y = 260,radius = 35,cor={102, 0, 204},posicao = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p6 = {nome = 'p6',x = 930, y = 260,radius = 35,cor={102, 0, 204},posicao = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p7 = {nome = 'p7',x = 530, y = 340,radius = 35,cor={102, 0, 204},posicao = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p8 = {nome = 'p8',x = 610, y = 340,radius = 35,cor={102, 0, 204},posicao = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p9 = {nome = 'p9',x = 690, y = 340,radius = 35,cor={102, 0, 204},posicao = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p10 = {nome = 'p10',x = 770, y = 340,radius = 35,cor={102, 0, 204},posicao = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p11 = {nome = 'p11',x = 850, y = 340,radius = 35,cor={102, 0, 204},posicao = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p12 = {nome = 'p12',x = 930, y = 340,radius = 35,cor={102, 0, 204},posicao = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
pecasPlayer1 = {p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12}

-- pecas iniciais para o player 2
p13 = {nome = 'p13',x = 530, y = 90,radius = 35,cor={179, 0, 59},posicao = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p14 = {nome = 'p14',x = 610, y = 90,radius = 35,cor={179, 0, 59},posicao = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p15 = {nome = 'p15',x = 690, y = 90,radius = 35,cor={179, 0, 59},posicao = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p16 = {nome = 'p16',x = 770, y = 90,radius = 35,cor={179, 0, 59},posicao = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p17 = {nome = 'p17',x = 850, y = 90,radius = 35,cor={179, 0, 59},posicao = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p18 = {nome = 'p18',x = 930, y = 90,radius = 35,cor={179, 0, 59},posicao = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p19 = {nome = 'p19',x = 530, y = 170,radius = 35,cor={179, 0, 59},posicao = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p20 = {nome = 'p20',x = 610, y = 170,radius = 35,cor={179, 0, 59},posicao = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p21 = {nome = 'p21',x = 690, y = 170,radius = 35,cor={179, 0, 59},posicao = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p22 = {nome = 'p22',x = 770, y = 170,radius = 35,cor={179, 0, 59},posicao = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p23 = {nome = 'p23',x = 850, y = 170,radius = 35,cor={179, 0, 59},posicao = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p24 = {nome = 'p24',x = 930, y = 170,radius = 35,cor={179, 0, 59},posicao = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
pecasPlayer2 = {p13,p14,p15,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24}

pecastotais = {pecasPlayer1, pecasPlayer2}

matapeca = ""

local tabuleiro = {{0,0,0,0,0},
                   {0,0,0,0,0},
                   {0,0,0,0,0},
                   {0,0,0,0,0},
                   {0,0,0,0,0},
                   {0,0,0,0,0}}

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
    local numeroUsuarios =  tablelength(mundo)
    if data and numeroUsuarios < 3 then
      nomeUsuario, idUsuario, cmd, pecas, tabuleiroarray = data:match("^(%S*) (%S*) (%S*) (%S*) (%S*)")
      if cmd == "movePeca" then
        local pecasUsuario = loadstring("return "..pecas)()
        if(tablelength(pecasUsuario)) == 0 then
          if tablelength(mundo) == 0 then
              udp:sendto(json.encode(pecasPlayer1), ip_cliente, porta)
          else
              udp:sendto(json.encode(pecasPlayer2), ip_cliente, porta)
          end
        end
        players[numeroUsuarios] = {idUsuario, nomeUsuario}
        mundo[idUsuario] = {matapeca = matapeca  , pecas = pecasUsuario, tabuleiro = tabuleiro, vezAtual = players[0], ip = ip_cliente, porta = porta}
        for key, value in pairs(mundo) do
            udp:sendto(json.encode(mundo), value.ip, value.porta)
        end
      end
      if cmd == "trocaTurno" then
        if tabuleiroarray ~= "" then
            local tabuleiroarray = loadstring("return "..tabuleiroarray)()
            local operacao = tabuleiroarray[2]
            tabuleiro = tabuleiroarray[1]
            if operacao ~= true then
                matapeca = operacao
            end
        end
        players[0], players[1] = players[1], players[0]
      end
      if cmd == "sair" then
          mundo[idUsuario] = nil
          for key, value in pairs(players) do
              if value[1] == idUsuario then
                  players[key] = nil
                  break
              end
          end
      end
    end
  until not data
  socket.sleep(0.1)
end
