local json = require "json"
local socket = require "socket"
require('table')
require('tables')
local udp = socket.udp()
udp:settimeout(0)
udp:setsockname("*", 2020)

local world = {}
local players = {}
local data, msg, port
local nameUser, idUser, cmd, pieces

-- init pieces player 1
p1 = {name = 'p1',x = 530, y = 260,radius = 35,color={102, 0, 204},position = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p2 = {name = 'p2',x = 610, y = 260,radius = 35,color={102, 0, 204},position = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p3 = {name = 'p3',x = 690, y = 260,radius = 35,color={102, 0, 204},position = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p4 = {name = 'p4',x = 770, y = 260,radius = 35,color={102, 0, 204},position = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p5 = {name = 'p5',x = 850, y = 260,radius = 35,color={102, 0, 204},position = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p6 = {name = 'p6',x = 930, y = 260,radius = 35,color={102, 0, 204},position = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p7 = {name = 'p7',x = 530, y = 340,radius = 35,color={102, 0, 204},position = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p8 = {name = 'p8',x = 610, y = 340,radius = 35,color={102, 0, 204},position = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p9 = {name = 'p9',x = 690, y = 340,radius = 35,color={102, 0, 204},position = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p10 = {name = 'p10',x = 770, y = 340,radius = 35,color={102, 0, 204},position = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p11 = {name = 'p11',x = 850, y = 340,radius = 35,color={102, 0, 204},position = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p12 = {name = 'p12',x = 930, y = 340,radius = 35,color={102, 0, 204},position = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
piecesPlayer1 = {p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12}

-- init pieces player 2
p13 = {name = 'p13',x = 530, y = 90,radius = 35,color={179, 0, 59},position = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p14 = {name = 'p14',x = 610, y = 90,radius = 35,color={179, 0, 59},position = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p15 = {name = 'p15',x = 690, y = 90,radius = 35,color={179, 0, 59},position = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p16 = {name = 'p16',x = 770, y = 90,radius = 35,color={179, 0, 59},position = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p17 = {name = 'p17',x = 850, y = 90,radius = 35,color={179, 0, 59},position = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p18 = {name = 'p18',x = 930, y = 90,radius = 35,color={179, 0, 59},position = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p19 = {name = 'p19',x = 530, y = 170,radius = 35,color={179, 0, 59},position = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p20 = {name = 'p20',x = 610, y = 170,radius = 35,color={179, 0, 59},position = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p21 = {name = 'p21',x = 690, y = 170,radius = 35,color={179, 0, 59},position = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p22 = {name = 'p22',x = 770, y = 170,radius = 35,color={179, 0, 59},position = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p23 = {name = 'p23',x = 850, y = 170,radius = 35,color={179, 0, 59},position = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
p24 = {name = 'p24',x = 930, y = 170,radius = 35,color={179, 0, 59},position = {l=0,c=0},dragging = { active = false, diffX = 0, diffY = 0 }}
piecesPlayer2 = {p13,p14,p15,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24}

killpiece = ""

local board = {{0,0,0,0,0},
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
    data, ip_client, port = udp:receivefrom()
    local numberUsers =  tablelength(world)
    if data and numberUsers < 3 then
      nameUser, idUser, cmd, pieces, boardarray = data:match("^(%S*) (%S*) (%S*) (%S*) (%S*)")
      if cmd == "movePiece" then
        local piecesUser = loadstring("return "..pieces)()
        if(tablelength(piecesUser)) == 0 then
          if tablelength(world) == 0 then
              udp:sendto(json.encode(piecesPlayer1), ip_client, port)
          else
              udp:sendto(json.encode(piecesPlayer2), ip_client, port)
          end
        end
        players[numberUsers] = {idUser, nameUser}
        world[idUser] = {killpiece = killpiece  , pieces = piecesUser, board = board, currentTurn = players[0], ip = ip_client, port = port}
        for key, value in pairs(world) do
            udp:sendto(json.encode(world), value.ip, value.port)
        end
      end
      if cmd == "changeTurn" then
        if boardarray ~= "" then
            local boardarray = loadstring("return "..boardarray)()
            local operation = boardarray[2]
            board = boardarray[1]
            if operation ~= true then
                killpiece = operation
            end
        end
        players[0], players[1] = players[1], players[0]
      end
      if cmd == "quit" then
          world[idUser] = nil
          for key, value in pairs(players) do
              if value[1] == idUser then
                  players[key] = nil
                  break
              end
          end
      end
    end
  until not data
  socket.sleep(0.1)
end
