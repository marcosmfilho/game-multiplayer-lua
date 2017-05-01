require('board')
require('table')
require('tables')
local utf8 = require("utf8")
local suit = require 'suit'
local chat = require('chat')
local socket = require('socket')
local json = require "json"
local address, port = 'localhost', 2020
local idUser
local world = {}
local updaterate = 0.1
local controlTime
local input = {text = ""}
local initPieces

function love.load()
    screen = 1
    enter = "Enter your nickname and press enter"
    love.keyboard.setKeyRepeat(true)
    background = love.graphics.newImage("images/bg.jpg")
    love.window.setMode(1000, 600, {resizable=false, vsync=false, minwidth=1000, minheight=540})

    udp = socket.udp()
    udp:settimeout(0)
    udp:setpeername(address, port)

    math.randomseed(os.time())
    idUser = tostring(math.random(9999))
    nameUser = ''
    controlTime = 0

    currentTurn = ''
    currentUser = ''
    colorUser = ''

    board.load()
    chat.load()
end

function love.update(dt)
    if screen ~= 1 then
        controlTime = controlTime + dt
        if controlTime > updaterate then
            board.update(dt)
                local datagrama = string.format("%s %s %s %s %s", nameUser, idUser, "movePiece", table.tostring(pieces), "")
                udp:send(datagrama)
            controlTime = controlTime - updaterate
        end

        repeat
            data, msg = udp:receive()
            if data then
                if tablelength(pieces) == 0 then
                  pieces = json.decode(data)
                  initPieces = json.decode(data)
                  for key, value in pairs(pieces) do
                      colorUser = value.color
                      break
                  end
                else
                  world = json.decode(data)
                  for key, value in pairs(world) do
                      if value.currentTurn ~= nil then
                        currentTurn = value.currentTurn[1]
                        currentUser = value.currentTurn[2]
                      end
                      if (value.board ~= boardarray) and value.board ~= "" then
                          boardarray = value.board
                          if value.killpiece ~= "" then
                              for k, v in pairs(pieces) do
                                  if v.name == value.killpiece then
                                      pieces[k] = nil
                                  end
                              end
                          end
                      end
                  end
                end
            elseif msg ~= "timeout" then local x = 0 end
        until not data

        -- update chat
        chat.update(dt)

        suit.layout:reset(10,555)
        if suit.Button("Restart", suit.layout:row(215,30)).hit then
            love.event.quit()
        end
            suit.layout:reset(235,555)
        if suit.Button("Quit", suit.layout:row(215,30)).hit then
            love.event.quit()
      end
    else
        suit.layout:reset(250,350)
        suit.Input(input, suit.layout:row(500,30))
    end
end

function love.mousepressed(x, y, button)
    if currentTurn == idUser and tablelength(world) == 2 then
        board.mousepressed(x, y, button)
    end
end

function love.mousereleased(x, y, button)
    if screen ~= 1 then
        if currentTurn == idUser and tablelength(world) == 2 then
            valuePiece = board.mousereleased(x, y, button)
            if valuePiece then
                print(table.tostring(valuePiece))
                local datagrama = string.format("%s %s %s %s %s", nameUser, idUser, "changeTurn","",table.tostring(valuePiece))
                udp:send(datagrama)
            end
        end
    end
end

function love.textinput(t)
  if screen == 1 then
    if string.len(input.text) < 20 then
      suit.textinput(t)
    end
  else
    chat.textinput(t)
  end
end

function love.keypressed(key)
  if screen == 1 then
    suit.keypressed(key)
    if key == "return" and input.text ~= "" then
        nameUser = input.text
        screen = screen + 1
        local datagrama = string.format("%s %s %s %s %s", nameUser, idUser, "movePiece", table.tostring(pieces),"")
        udp:send(datagrama)
        local datagrama2 = string.format("%s %s %s %s", 'newMessage',idUser,nameUser,'')
        udpChat:send(datagrama2)
    end
  else
    chat.keypressed(key, idUser, nameUser)
  end
end

function love.wheelmoved(x,y)
  if screen ~= 1 then
    chat.wheelmoved(x,y)
  end
end

function love.quit()
  local datagrama = string.format("%s %s %s %s %s", nameUser, idUser, "quit", table.tostring(pieces), "")
  udp:send(datagrama)
end

function love.draw()
    if screen == 1 then
        love.graphics.setColor(255,255,255,255);
        love.graphics.draw(background, 0,0)
        love.graphics.setFont(love.graphics.newFont('fonts/accid.ttf',22))
        love.graphics.setColor(44, 62, 80)
        love.graphics.setFont(love.graphics.newFont('fonts/accid.ttf',22))
        love.graphics.printf(enter, 100, 300, 800, 'center')
        suit.draw()
    else
        love.graphics.setColor(255,255,255,255);
        love.graphics.draw(background, 0,0)
        board.draw()
        chat.draw()

        if tablelength(world) < 2 then
            love.graphics.setColor(77, 38, 0);
            love.graphics.print('Waiting for the second player...', 510, 10)
        else
            if currentTurn == idUser then
                love.graphics.setColor(colorUser)
                love.graphics.print("It's your turn, move one piece!", 510, 10)
            else
                love.graphics.setColor(77, 38, 0)
                love.graphics.print('Time of the player ' .. currentUser, 510, 10)
            end
        end

        love.graphics.setFont(love.graphics.newFont('fonts/accid.ttf',20))

        -- pintando as minhas peças nos valores iniciais caso só tenha um adversário
        if tablelength(pieces) > 0 and tablelength(world) == 1 then
            for key, value in pairs(initPieces) do
                love.graphics.setColor(value.color)
                love.graphics.circle("fill", value.x, value.y, value.radius)
            end
        end

        -- pintando as peças do adversário
        if tablelength(world) == 2 then
            for key, value in pairs(world) do
                for key2, value2 in pairs(value.pieces) do
                    love.graphics.setColor(value2.color)
                    love.graphics.circle("fill", value2.x, value2.y, value2.radius)
                end
            end
        end
    end
end

function tablelength(T)
  counter = 0
  if T ~= nil then
    for index in pairs(T) do
        counter = counter + 1
    end
  end
  return counter
end
