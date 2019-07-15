require "Piece"
winW = love.graphics.getWidth()
winH = love.graphics.getHeight()

function DrawWorld()
  for i=1,30 do
    for j = 1,20 do
      if world[i][j] == 1 then --y,x
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", (j-1)*20, (i-1)*20, 20, 20)
      elseif world[i][j] == 2 then
        love.graphics.setColor(255, 0, 0)
        love.graphics.rectangle("fill", (j-1)*20, (i-1)*20, 20, 20)
      end
    end
  end
end

function UpdatePiecesInWorld(pieces)
  for pieceIndex,piece in pairs(pieces) do
    for rowIndex,row in ipairs(piece.shapes[piece.shapeNum]) do
      for columnIndex,block in ipairs(row) do
        if block == 2 or block == 1 then
          world[piece.i+(rowIndex-1)][piece.j+(columnIndex-1)] = piece.shapes[piece.shapeNum][rowIndex][columnIndex] --(y,x)
        end
      end
    end
  end
end

function MovePiece(key, piece)
  if key == "left" then
    local collisionNum = 0
    for rowIndex,row in ipairs(piece.shapes[piece.shapeNum]) do
      for columnIndex,block in ipairs(row) do
        if block == 2 then
          if world[piece.i+rowIndex-1][piece.j + columnIndex-1 - 1] == 1 then
            collisionNum = collisionNum + 1
          end
        end
      end
    end
    if collisionNum == 0 then
      piece.j = piece.j - 1
    end
  elseif key == "right" then
    local collisionNum = 0
    for rowIndex,row in ipairs(piece.shapes[piece.shapeNum]) do
      for columnIndex,block in ipairs(row) do
        if block == 2 then
          if world[piece.i+rowIndex-1][piece.j + columnIndex-1 + 1] == 1 then
            collisionNum = collisionNum + 1
          end
        end
      end
    end
    if collisionNum == 0 then
      piece.j = piece.j + 1
    end
  end
end

function RotatePiece(key, piece)
  if key == "z" then
    local collisionNum = 0
    if piece.shapeNum == #piece.shapes then
      for rowIndex,row in ipairs(piece.shapes[1]) do
        for columnIndex,block in ipairs(row) do
          if block == 2 then
            if world[piece.i+rowIndex-1][piece.j+columnIndex-1] == 1 then
              collisionNum = collisionNum + 1
            end
          end
        end
      end

      if collisionNum == 0 then
        piece.shapeNum = 1
      end
    else
      for rowIndex,row in ipairs(piece.shapes[piece.shapeNum+1]) do
        for columnIndex,block in ipairs(row) do
          if block == 2 then
            if world[piece.i+rowIndex-1][piece.j+columnIndex-1] == 1 then
              collisionNum = collisionNum + 1
            end
          end
        end
      end

      if collisionNum == 0 then
        piece.shapeNum = piece.shapeNum + 1
      end
    end
  end
end

function PieceFall(piece, dt)
  local collisionNum = 0
  for rowIndex,row in ipairs(piece.shapes[piece.shapeNum]) do
    for columnIndex,block in ipairs(row) do
      if block == 2 then
        if world[piece.i+rowIndex-1+1][piece.j+columnIndex-1] == 1 then
          collisionNum = collisionNum + 1
        end
      end
    end
  end
  if collisionNum == 0 then
    if love.keyboard.isDown("down") and downArrowFlag then
      currentTime = timeBtwFallUpdate
    end
    if not love.keyboard.isDown("down") then
      downArrowFlag = true
    end
    if currentTime >= timeBtwFallUpdate then
      currentTime = 0
      piece.i = piece.i + 1
    else
      currentTime = currentTime + dt
    end
  else
    for rowIndex,row in ipairs(piece.shapes[piece.shapeNum]) do
      for columnIndex,block in ipairs(row) do
        if block == 2 then
          piece.shapes[piece.shapeNum][rowIndex][columnIndex] = 1
          world[piece.i+(rowIndex-1)][piece.j+(columnIndex-1)] = piece.shapes[piece.shapeNum][rowIndex][columnIndex] --(y,x)
        end
      end
    end
    table.insert(pieces, Piece(love.math.random(1, 7)))
    table.remove(pieces, 1)
    CheckMatch()
    CheckIfGameOver()
    downArrowFlag = false
  end
end

function LandedGroundCol(incidentHeight)
  for i=incidentHeight,2,-1 do
    for j=2,19 do
      if world[i][j] == 1 and world[i+1][j] == 0 then
        world[i+1][j] = world[i][j]
        world[i][j] = 0
      end
    end
  end
end

function CheckMatch()
  for i=1,29 do
    local destroy = true
    for j=1,20 do
      if world[i][j] == 0 or world[i][j] == 2 then
        destroy = false
      end
    end
    if destroy then
      world[i] = {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}
      LandedGroundCol(i)
      score = score + 100
    end
  end
end

function CheckIfGameOver()
  for i=2,19 do
    if world[1][i] == 1 then
      gameState = "gameOver"
    end
  end
end

function Restart()
  world = {
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
  }
  pieces = {Piece(love.math.random(1, 7))}
  downArrowFlag = true

  score = 0

  currentTime = 0
  timeBtwFallUpdate = 0.5
  gameState = "game"
end

function love.load()
  love.graphics.setBackgroundColor(1, 1, 1)
  love.graphics.setDefaultFilter("nearest", "nearest")
  scoreFont = love.graphics.newFont("Font/Squares Bold Free.otf", 16)
  gameOverFont = love.graphics.newFont("Font/Squares Bold Free.otf", 32)
  Restart()
end

function love.update(dt)
  if gameState == "game" then
    for rowIndex,row in ipairs(world) do
      for columnIndex,block in ipairs(row) do
        if block == 2 then
          world[rowIndex][columnIndex] = 0
        end
      end
    end
    UpdatePiecesInWorld(pieces)
    PieceFall(pieces[#pieces], dt)
  end
end

function love.draw()
  DrawWorld()
  if gameState == "game" then
    love.graphics.setColor(0, 0, 1)
    love.graphics.setFont(scoreFont)
    love.graphics.print("Score : "..tostring(score), 0, 0, 0, 1, 1)
  elseif gameState == "gameOver" then
    love.graphics.setColor(0, 1, 0)
    love.graphics.setFont(gameOverFont)
    love.graphics.print("Game Over", winW/2, winH/2, 0, 1, 1, gameOverFont:getWidth("Game Over")/2, gameOverFont:getHeight("Game Over")/2)
    love.graphics.setColor(0, 0, 1)
    love.graphics.print("Score : "..tostring(score), winW/2, winH/1.75, 0, 1, 1, gameOverFont:getWidth("Score : "..tostring(score))/2, 16)
    love.graphics.setFont(scoreFont)
    love.graphics.setColor(1, 0, 0)
    love.graphics.print("'R' to restart", winW/2, winH/1.5, 0, 1, 1, scoreFont:getWidth("'R' to restart")/2, 8)
  end
end

function love.keypressed(key, scancode, isrepeat)
  if gameState == "game" then
    MovePiece(key, pieces[#pieces])
    RotatePiece(key, pieces[#pieces])
    if key == "r" then
      Restart()
    end
  elseif gameState == "gameOver" then
    if key == "r" then
      Restart()
      gameState = "game"
    end
  end
end
