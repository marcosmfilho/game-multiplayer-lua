require('tabuleiro')
require('table')
require('tables')
local utf8 = require("utf8")
local suit = require 'suit'
local chat = require('chat')
local socket = require('socket')
local json = require "json"
local endereco, porta = 'localhost', 2020
local idUsuario
local mundo = {}
local updaterate = 0.1
local controleTempo
local  input = {text = ""}
local pecasIniciais

function love.load()
    tela = 1
    entrar = "Digite o seu nome e aperte a tecla ENTER para entrar"
    love.keyboard.setKeyRepeat(true)
    background = love.graphics.newImage("imagens/bg.jpg")
    love.window.setMode(1000, 600, {resizable=false, vsync=false, minwidth=1000, minheight=540})

    udp = socket.udp()
    udp:settimeout(0)
    udp:setpeername(endereco, porta)

    math.randomseed(os.time())
    idUsuario = tostring(math.random(9999))
    nomeUsuario = ''
    controleTempo = 0
    controleTurno = 'Aguardando o segundo jogador...'
    vezAtual = ''
    usuarioAtual = ''
    corUsuario = ''

    tabuleiro.load()
    chat.load()
end

function love.update(dt)
    if tela ~= 1 then
        controleTempo = controleTempo + dt
        if controleTempo > updaterate then
            tabuleiro.update(dt)
                local datagrama = string.format("%s %s %s %s %s", nomeUsuario, idUsuario, "movePeca", table.tostring(pecas), "")
                udp:send(datagrama)
            controleTempo = controleTempo - updaterate
        end

        repeat
            data, msg = udp:receive()
            if data then
                if tablelength(pecas) == 0 then
                  pecas = json.decode(data)
                  pecasIniciais = json.decode(data)
                  for key, value in pairs(pecas) do
                      corUsuario = value.cor
                      break
                  end
                else
                  mundo = json.decode(data)
                  for key, value in pairs(mundo) do
                      if value.vezAtual ~= nil then
                        vezAtual = value.vezAtual[1]
                        usuarioAtual = value.vezAtual[2]
                      end
                      -- print(table.tostring(tabuleiroarray))
                      if (value.tabuleiro ~= tabuleiroarray) and value.tabuleiro ~= "" then
                          tabuleiroarray = value.tabuleiro
                          if value.matapeca ~= "" then
                              for k, v in pairs(pecas) do
                                  if v.nome == value.matapeca then
                                      pecas[k] = nil
                                  end
                              end
                          end
                      end
                  end
                end
            elseif msg ~= "timeout" then local x = 0 end
        until not data

        -- atualização do chat
        chat.update(dt)

        suit.layout:reset(10,555)
        if suit.Button("Reiniciar Partida", suit.layout:row(215,30)).hit then
            love.event.quit()
        end
            suit.layout:reset(235,555)
        if suit.Button("Desistir", suit.layout:row(215,30)).hit then
            love.event.quit()
      end
    else
        suit.layout:reset(250,350)
        suit.Input(input, suit.layout:row(500,30))
    end
end

function love.mousepressed(x, y, button)
    if vezAtual == idUsuario and tablelength(mundo) == 2 then
        tabuleiro.mousepressed(x, y, button)
    end
end

function love.mousereleased(x, y, button)
    if tela ~= 1 then
        if vezAtual == idUsuario and tablelength(mundo) == 2 then
            valorPeca = tabuleiro.mousereleased(x, y, button)
            -- print(table.tostring(valorPeca))
            if valorPeca then
                local datagrama = string.format("%s %s %s %s %s", nomeUsuario, idUsuario, "trocaTurno", "p2",table.tostring(valorPeca))
                udp:send(datagrama)
                -- print(table.tostring(tabuleiroarray))
            end
        end
    end
end

function love.textinput(t)
  if tela == 1 then
    if string.len(input.text) < 20 then
      suit.textinput(t)
    end
  else
    chat.textinput(t)
  end
end

function love.keypressed(key)
  if tela == 1 then
    suit.keypressed(key)
    if key == "return" and input.text ~= "" then
        nomeUsuario = input.text
        tela = tela + 1
        local datagrama = string.format("%s %s %s %s %s", nomeUsuario, idUsuario, "movePeca", table.tostring(pecas),"")
        udp:send(datagrama)
        local datagrama2 = string.format("%s %s %s %s", 'novaMensagem',idUsuario,nomeUsuario,'')
        udpChat:send(datagrama2)
    end
  else
    chat.keypressed(key, idUsuario, nomeUsuario)
  end
end

function love.wheelmoved(x,y)
  if tela ~= 1 then
    chat.wheelmoved(x,y)
  end
end

function love.quit()
  local datagrama = string.format("%s %s %s %s %s", nomeUsuario, idUsuario, "sair", table.tostring(pecas), "")
  udp:send(datagrama)
end

function love.draw()
    if tela == 1 then
        love.graphics.setColor(255,255,255,255);
        love.graphics.draw(background, 0,0)
        love.graphics.setFont(love.graphics.newFont('fonts/accid.ttf',22))
        love.graphics.setColor(44, 62, 80)
        love.graphics.setFont(love.graphics.newFont('fonts/accid.ttf',22))
        love.graphics.printf(entrar, 100, 300, 800, 'center')
        suit.draw()
    else
        love.graphics.setColor(255,255,255,255);
        love.graphics.draw(background, 0,0)
        tabuleiro.draw()
        chat.draw()

        if tablelength(mundo) < 2 then
            love.graphics.setColor(77, 38, 0);
            love.graphics.print('Aguardando o segundo jogador...', 510, 10)
        else
            if vezAtual == idUsuario then
                love.graphics.setColor(corUsuario)
                love.graphics.print('É a sua jogada, mova uma peça!', 510, 10)
            else
                love.graphics.setColor(77, 38, 0)
                love.graphics.print('Vez do jogador ' .. usuarioAtual, 510, 10)
            end
        end

        love.graphics.setFont(love.graphics.newFont('fonts/accid.ttf',20))

        -- pintando as minhas peças nos valores iniciais caso só tenha um adversário
        if tablelength(pecas) > 0 and tablelength(mundo) == 1 then
            for key, value in pairs(pecasIniciais) do
                love.graphics.setColor(value.cor)
                love.graphics.circle("fill", value.x, value.y, value.radius)
            end
        end

        -- pintando as peças do adversário
        if tablelength(mundo) == 2 then
            for key, value in pairs(mundo) do
                for key2, value2 in pairs(value.pecas) do
                    love.graphics.setColor(value2.cor)
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
