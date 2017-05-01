require('table')

board = {}
function board.load()
  soundMove = love.audio.newSource("sounds/move.wav", "static")
  soundEat = love.audio.newSource("sounds/come.wav", "static")
  t1 = love.graphics.newImage("images/tijolo1.png")
  t2 = love.graphics.newImage("images/tijolo2.png")
  bricks = {t1,t2,t1,t2,t1,t2,t1,t2,t1,t2,t1,t2,t1,t2,t1,t2,t1,t2,t1,t2,t1,t2,t1,t2,t1,t2,t1,t2,t1,t2}
  pieces = {}
  initPositionX = 0
  initPositionY = 0

  boardarray = {{0,0,0,0,0},
                {0,0,0,0,0},
                {0,0,0,0,0},
                {0,0,0,0,0},
                {0,0,0,0,0},
                {0,0,0,0,0}}
end

function board.draw()
  love.graphics.setColor(255,255,255,255);
  local x = 1
  for i = 1, 6 do
    for j = 1, 5 do
      love.graphics.draw(bricks[i+j-1], j*90-90, i*90-90)
    end
  end
end

function board.update(dt)
    for k, v in pairs(pieces) do
      if v.dragging.active then
        v.x = love.mouse.getX() - v.dragging.diffX
        v.y = love.mouse.getY() - v.dragging.diffY
      end
    end
end

function board.mousepressed(x, y, button)
  if button == 1 then
    for k, v in pairs(pieces) do
      if mouseTouch(v.radius, v.x,v.y, x, y) then
        if x > 450 then
          initPositionX = v.x
          initPositionY = v.y
        end
        v.dragging.active = true
        v.dragging.diffX = x - v.x
        v.dragging.diffY = y - v.y
      end
    end
  end
end

function board.mousereleased(x, y, button)
  if button == 1 then
    for k, v in pairs(pieces) do
      if mouseTouch(v.radius, v.x,v.y, x, y) then
        v.dragging.active = false
        if x < 450 then
          local positiontry = correctPosition(v, love.mouse.getX(), love.mouse.getY())
          local validmovement = validmovement(boardarray,v.position.l, v.position.c, positiontry.l, positiontry.c, pieces)

          if validmovement then
            boardarray[positiontry.l][positiontry.c] = v.name
            v.position = correctPosition(v, love.mouse.getX(), love.mouse.getY())
            initPositionX = v.x
            initPositionY = v.y
            if validmovement == true then
                soundMove:play()
            else
                soundEat:play()
            end
            return {boardarray, validmovement}
          else
            v.x = initPositionX
            v.y = initPositionY
            return false
          end
        else
          v.x = initPositionX
          v.y = initPositionY
          return false
        end
      end
    end
  end
  return false
end

function mouseTouch(radiusObj, xObj, yObj, xMouse, yMouse)
  if xMouse > xObj - radiusObj and xMouse < xObj + radiusObj and yMouse > yObj - radiusObj and yMouse < yObj + radiusObj then
    return true
  else
    return false
  end
end

function correctPosition(piece, mx, my)
  if mx < 90  and mx > 0    and my < 90   and my > 0  then piece.x = 45  piece.y = 45  return {l=1,c=1} end
  if mx < 180 and mx > 90   and my < 90   and my > 0  then piece.x = 135 piece.y = 45  return {l=1,c=2} end
  if mx < 270 and mx > 180  and my < 90   and my > 0  then piece.x = 225 piece.y = 45  return {l=1,c=3} end
  if mx < 360 and mx > 270  and my < 90   and my > 0  then piece.x = 315 piece.y = 45  return {l=1,c=4} end
  if mx < 450 and mx > 360  and my < 90   and my > 0  then piece.x = 405 piece.y = 45  return {l=1,c=5} end

  if mx < 90  and mx > 0    and my < 180  and my > 90 then piece.x = 45  piece.y = 135 return {l=2,c=1} end
  if mx < 180 and mx > 90   and my < 180  and my > 90 then piece.x = 135 piece.y = 135 return {l=2,c=2} end
  if mx < 270 and mx > 180  and my < 180  and my > 90 then piece.x = 225 piece.y = 135 return {l=2,c=3} end
  if mx < 360 and mx > 270  and my < 180  and my > 90 then piece.x = 315 piece.y = 135 return {l=2,c=4} end
  if mx < 450 and mx > 360  and my < 180  and my > 90 then piece.x = 405 piece.y = 135 return {l=2,c=5} end

  if mx < 90  and mx > 0    and my < 270  and my > 180 then piece.x = 45  piece.y = 225 return {l=3,c=1} end
  if mx < 180 and mx > 90   and my < 270  and my > 180 then piece.x = 135 piece.y = 225 return {l=3,c=2} end
  if mx < 270 and mx > 180  and my < 270  and my > 180 then piece.x = 225 piece.y = 225 return {l=3,c=3} end
  if mx < 360 and mx > 270  and my < 270  and my > 180 then piece.x = 315 piece.y = 225 return {l=3,c=4} end
  if mx < 450 and mx > 360  and my < 270  and my > 180 then piece.x = 405 piece.y = 225 return {l=3,c=5} end

  if mx < 90  and mx > 0    and my < 360  and my > 270 then piece.x = 45 piece.y = 315  return {l=4,c=1} end
  if mx < 180 and mx > 90   and my < 360  and my > 270 then piece.x = 135 piece.y = 315 return {l=4,c=2} end
  if mx < 270 and mx > 180  and my < 360  and my > 270 then piece.x = 225 piece.y = 315 return {l=4,c=3} end
  if mx < 360 and mx > 270  and my < 360  and my > 270 then piece.x = 315 piece.y = 315 return {l=4,c=4} end
  if mx < 450 and mx > 360  and my < 360  and my > 270 then piece.x = 405 piece.y = 315 return {l=4,c=5} end

  if mx < 90  and mx > 0    and my < 450  and my > 360 then piece.x = 45 piece.y = 405  return {l=5,c=1} end
  if mx < 180 and mx > 90   and my < 450  and my > 360 then piece.x = 135 piece.y = 405 return {l=5,c=2} end
  if mx < 270 and mx > 180  and my < 450  and my > 360 then piece.x = 225 piece.y = 405 return {l=5,c=3} end
  if mx < 360 and mx > 270  and my < 450  and my > 360 then piece.x = 315 piece.y = 405 return {l=5,c=4} end
  if mx < 450 and mx > 360  and my < 450  and my > 360 then piece.x = 405 piece.y = 405 return {l=5,c=5} end

  if mx < 90  and mx > 0    and my < 540  and my > 450 then piece.x = 45 piece.y = 495  return {l=6,c=1} end
  if mx < 180 and mx > 90   and my < 540  and my > 450 then piece.x = 135 piece.y = 495 return {l=6,c=2} end
  if mx < 270 and mx > 180  and my < 540  and my > 450 then piece.x = 225 piece.y = 495 return {l=6,c=3} end
  if mx < 360 and mx > 270  and my < 540  and my > 450 then piece.x = 315 piece.y = 495 return {l=6,c=4} end
  if mx < 450 and mx > 360  and my < 540  and my > 450 then piece.x = 405 piece.y = 495 return {l=6,c=5} end
end

function validmovement(t,l, c, lt, ct, pieces)
    local operation = ((moveup(t,l, c, lt, ct) or movedown(t,l, c, lt, ct) or
         moveright(t,l, c, lt, ct) or moveleft(t,l, c, lt, ct)) and t[lt][ct] == 0)
         or (l == 0 and c == 0 and t[lt][ct] == 0) or eatpiece(t, l, c, lt, ct, pieces)

    if operation then
       return operation
    else
      return false
    end
end

function moveup(board, lin, col, lintry, coltry)
  if lin == lintry +1 and col == coltry then
    board[lin][col] = 0
    return true
  else
    return false
  end
end

function movedown(board, lin, col, lintry, coltry)
  if lin == lintry - 1 and col == coltry then
    board[lin][col] = 0
    return true
  else
    return false
  end
end

function moveright(board, lin, col, lintry, coltry)
  if lin == lintry and col == coltry + 1 then
    board[lin][col] = 0
    return true
  else
    return false
  end
end

function moveleft(board, lin, col, lintry, coltry)
  if lin == lintry and col == coltry - 1 then
    board[lin][col] = 0
    return true
  else
    return false
  end
end

function eatpiece(t, l, c, lt, ct, pieces)
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
