local Object = require "classic"
Piece = Object:extend()

function Piece:new(pieceNum)
  self.j = 10
  self.i = 1
  self.shapeNum = 1
  if pieceNum == 1 then
    self.shapes = {
      {
        {2, 2},
        {2, 0},
        {2, 0}
      },
      {
        {2, 2, 2},
        {0, 0, 2}
      },
      {
        {0, 2},
        {0, 2},
        {2, 2}
      },
      {
        {2, 0, 0},
        {2, 2, 2}
      }
    }
  elseif pieceNum == 2 then
    self.shapes = {
      {
        {2},
        {2},
        {2},
        {2}
      },
      {
        {2, 2, 2, 2}
      }
    }
  elseif pieceNum == 3 then
    self.shapes = {
      {
        {0,2},
        {2,2},
        {2,0}
      },
      {
        {2,2,0},
        {0,2,2}
      }
    }
  elseif pieceNum == 4 then
    self.shapes = {
      {
        {2,0},
        {2,2},
        {0,2}
      },
      {
        {0,2,2},
        {2,2,0}
      }
    }
  elseif pieceNum == 5 then
    self.shapes = {
      {
        {2,2},
        {0,2},
        {0,2}
      },
      {
        {0,0,2},
        {2,2,2}
      },
      {
        {2,0},
        {2,0},
        {2,2}
      },
      {
        {2,2,2},
        {2,0,0}
      }
    }
  elseif pieceNum == 6 then
    self.shapes = {
      {
        {0,2,0},
        {2,2,2}
      },
      {
        {2,0},
        {2,2},
        {2,0}
      },
      {
        {2,2,2},
        {0,2,0}
      },
      {
        {0,2},
        {2,2},
        {0,2}
      }
    }
  elseif pieceNum == 7 then
    self.shapes = {
      {
        {2,2},
        {2,2}
      }
    }
  end
end
