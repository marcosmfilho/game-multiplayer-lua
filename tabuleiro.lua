require('table')

tabuleiro = {}
function tabuleiro.load()
  soundMove = love.audio.newSource("sounds/move.wav", "static")
  soundCome = love.audio.newSource("sounds/come.wav", "static")
  t1 = love.graphics.newImage("imagens/tijolo1.png")
  t2 = love.graphics.newImage("imagens/tijolo2.png")
  tijolos = {t1,t2,t1,t2,t1,t2,t1,t2,t1,t2,t1,t2,t1,t2,t1,t2,t1,t2,t1,t2,t1,t2,t1,t2,t1,t2,t1,t2,t1,t2}
  pecas = {}
  posicaoInicialPecaX = 0
  posicaoInicialPecaY = 0

  tabuleiroarray = {{0,0,0,0,0},
                    {0,0,0,0,0},
                    {0,0,0,0,0},
                    {0,0,0,0,0},
                    {0,0,0,0,0},
                    {0,0,0,0,0}}
end

function tabuleiro.draw()
  love.graphics.setColor(255,255,255,255);
  local x = 1
  for i = 1, 6 do
    for j = 1, 5 do
      love.graphics.draw(tijolos[i+j-1], j*90-90, i*90-90)
    end
  end
end

function tabuleiro.update(dt)
    for k, v in pairs(pecas) do
      if v.dragging.active then
        v.x = love.mouse.getX() - v.dragging.diffX
        v.y = love.mouse.getY() - v.dragging.diffY
      end
    end
end

function tabuleiro.mousepressed(x, y, button)
  if button == 1 then
    for k, v in pairs(pecas) do
      if mouseTocaObjeto(v.radius, v.x,v.y, x, y) then
        if x > 450 then
          posicaoInicialPecaX = v.x
          posicaoInicialPecaY = v.y
        end
        v.dragging.active = true
        v.dragging.diffX = x - v.x
        v.dragging.diffY = y - v.y
      end
    end
  end
end

function tabuleiro.mousereleased(x, y, button)
  if button == 1 then
    for k, v in pairs(pecas) do
      if mouseTocaObjeto(v.radius, v.x,v.y, x, y) then
        v.dragging.active = false
        if x < 450 then
          local posicaotentativa = posicaoCorretaTabuleiro(v, love.mouse.getX(), love.mouse.getY())
          local movimentoValido = movimentoValido(tabuleiroarray,v.posicao.l, v.posicao.c, posicaotentativa.l, posicaotentativa.c, pecas)

          if movimentoValido then
            tabuleiroarray[posicaotentativa.l][posicaotentativa.c] = v.nome
            v.posicao = posicaoCorretaTabuleiro(v, love.mouse.getX(), love.mouse.getY())
            posicaoInicialPecaX = v.x
            posicaoInicialPecaY = v.y
            if movimentoValido == true then
                soundMove:play()
            else
                soundCome:play()
            end
            return {tabuleiroarray, movimentoValido}
          else
            v.x = posicaoInicialPecaX
            v.y = posicaoInicialPecaY
            return false
          end
        else
          v.x = posicaoInicialPecaX
          v.y = posicaoInicialPecaY
          return false
        end
      end
    end
  end
  return false
end

function mouseTocaObjeto(raioObj, xObj, yObj, xMouse, yMouse)
  if xMouse > xObj - raioObj and xMouse < xObj + raioObj and yMouse > yObj - raioObj and yMouse < yObj + raioObj then
    return true
  else
    return false
  end
end

function posicaoCorretaTabuleiro(peca, mx, my)
  if mx < 90  and mx > 0    and my < 90   and my > 0  then peca.x = 45  peca.y = 45  return {l=1,c=1} end
  if mx < 180 and mx > 90   and my < 90   and my > 0  then peca.x = 135 peca.y = 45  return {l=1,c=2} end
  if mx < 270 and mx > 180  and my < 90   and my > 0  then peca.x = 225 peca.y = 45  return {l=1,c=3} end
  if mx < 360 and mx > 270  and my < 90   and my > 0  then peca.x = 315 peca.y = 45  return {l=1,c=4} end
  if mx < 450 and mx > 360  and my < 90   and my > 0  then peca.x = 405 peca.y = 45  return {l=1,c=5} end

  if mx < 90  and mx > 0    and my < 180  and my > 90 then peca.x = 45  peca.y = 135 return {l=2,c=1} end
  if mx < 180 and mx > 90   and my < 180  and my > 90 then peca.x = 135 peca.y = 135 return {l=2,c=2} end
  if mx < 270 and mx > 180  and my < 180  and my > 90 then peca.x = 225 peca.y = 135 return {l=2,c=3} end
  if mx < 360 and mx > 270  and my < 180  and my > 90 then peca.x = 315 peca.y = 135 return {l=2,c=4} end
  if mx < 450 and mx > 360  and my < 180  and my > 90 then peca.x = 405 peca.y = 135 return {l=2,c=5} end

  if mx < 90  and mx > 0    and my < 270  and my > 180 then peca.x = 45  peca.y = 225 return {l=3,c=1} end
  if mx < 180 and mx > 90   and my < 270  and my > 180 then peca.x = 135 peca.y = 225 return {l=3,c=2} end
  if mx < 270 and mx > 180  and my < 270  and my > 180 then peca.x = 225 peca.y = 225 return {l=3,c=3} end
  if mx < 360 and mx > 270  and my < 270  and my > 180 then peca.x = 315 peca.y = 225 return {l=3,c=4} end
  if mx < 450 and mx > 360  and my < 270  and my > 180 then peca.x = 405 peca.y = 225 return {l=3,c=5} end

  if mx < 90  and mx > 0    and my < 360  and my > 270 then peca.x = 45 peca.y = 315  return {l=4,c=1} end
  if mx < 180 and mx > 90   and my < 360  and my > 270 then peca.x = 135 peca.y = 315 return {l=4,c=2} end
  if mx < 270 and mx > 180  and my < 360  and my > 270 then peca.x = 225 peca.y = 315 return {l=4,c=3} end
  if mx < 360 and mx > 270  and my < 360  and my > 270 then peca.x = 315 peca.y = 315 return {l=4,c=4} end
  if mx < 450 and mx > 360  and my < 360  and my > 270 then peca.x = 405 peca.y = 315 return {l=4,c=5} end

  if mx < 90  and mx > 0    and my < 450  and my > 360 then peca.x = 45 peca.y = 405  return {l=5,c=1} end
  if mx < 180 and mx > 90   and my < 450  and my > 360 then peca.x = 135 peca.y = 405 return {l=5,c=2} end
  if mx < 270 and mx > 180  and my < 450  and my > 360 then peca.x = 225 peca.y = 405 return {l=5,c=3} end
  if mx < 360 and mx > 270  and my < 450  and my > 360 then peca.x = 315 peca.y = 405 return {l=5,c=4} end
  if mx < 450 and mx > 360  and my < 450  and my > 360 then peca.x = 405 peca.y = 405 return {l=5,c=5} end

  if mx < 90  and mx > 0    and my < 540  and my > 450 then peca.x = 45 peca.y = 495  return {l=6,c=1} end
  if mx < 180 and mx > 90   and my < 540  and my > 450 then peca.x = 135 peca.y = 495 return {l=6,c=2} end
  if mx < 270 and mx > 180  and my < 540  and my > 450 then peca.x = 225 peca.y = 495 return {l=6,c=3} end
  if mx < 360 and mx > 270  and my < 540  and my > 450 then peca.x = 315 peca.y = 495 return {l=6,c=4} end
  if mx < 450 and mx > 360  and my < 540  and my > 450 then peca.x = 405 peca.y = 495 return {l=6,c=5} end
end

function movimentoValido(t,l, c, lt, ct, pecas)
    local operacao = ((casanafrente(t,l, c, lt, ct) or casaatras(t,l, c, lt, ct) or
         casadireita(t,l, c, lt, ct) or casaesquerda(t,l, c, lt, ct)) and t[lt][ct] == 0)
         or (l == 0 and c == 0 and t[lt][ct] == 0) or comepeca(t, l, c, lt, ct, pecas)

    if operacao then
       return operacao
    else
      return false
    end
end

function casanafrente(tabuleiro, linha, coluna, linhatentada, colunatentada)
  if linha == linhatentada +1 and coluna == colunatentada then
    tabuleiro[linha][coluna] = 0
    return true
  else
    return false
  end
end

function casaatras(tabuleiro, linha, coluna, linhatentada, colunatentada)
  if linha == linhatentada - 1 and coluna == colunatentada then
    tabuleiro[linha][coluna] = 0
    return true
  else
    return false
  end
end

function casadireita(tabuleiro, linha, coluna, linhatentada, colunatentada)
  if linha == linhatentada and coluna == colunatentada + 1 then
    tabuleiro[linha][coluna] = 0
    return true
  else
    return false
  end
end

function casaesquerda(tabuleiro, linha, coluna, linhatentada, colunatentada)
  if linha == linhatentada and coluna == colunatentada - 1 then
    tabuleiro[linha][coluna] = 0
    return true
  else
    return false
  end
end

function removePeca(pecas, linha, coluna)
  for k, v in pairs(pecas) do
      if v.posicao.l == linha and v.posicao.c == coluna then
        table.remove(pecas, k)
        break
      end
  end
end

function comepeca(t, l, c, lt, ct, pecas)
    if l == lt + 2 and c == ct then
      if t[lt+1][ct] ~= 0 then
        t[l-2][ct] = t[l][c]
        t[l][c] = 0
        local aux = t[l-1][ct]
        t[l-1][ct] = 0
        return aux
      else
        return false
      end
    end

    if l == lt - 2 and c == ct then
      if t[lt-1][ct] ~= 0 then
        t[l+2][ct] = t[l][c]
        t[l][c] = 0
        local aux = t[l+1][ct]
        t[l+1][ct] = 0
        return aux
      else
        return false
      end
    end

    if l == lt and c == ct + 2 then
      if t[lt][ct+1] ~= 0 then
          t[l][c-2] = t[l][c]
          t[l][c] = 0
          local aux = t[l][ct+1]
          t[l][ct+1] = 0
          return aux
        else
          return false
      end
    end

    if l == lt and c == ct - 2 then
      if t[lt][ct-1] ~= 0 then
          t[l][c+2] = t[l][c]
          t[l][c] = 0
          local aux = t[l][ct-1]
          t[l][ct-1] = 0
          return aux
        else
          return false
      end
    end
end
