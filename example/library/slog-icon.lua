local m = {
    debug        = false,
    _NAME        = 'GUI Icon',
    _VERSION     = '1.0',
    _DESCRIPTION = [[
          Icon Loader
          Loads a texture containing a series of icons, splits and displays them.
      ]],
    _URL         = 'https://github.com/SystemLogoff',
    _LICENSE     = [[
      MIT LICENSE
  
      Copyright (c) 2020 Chris / Systemlogoff
  
      Permission is hereby granted, free of charge, to any person obtaining a
      copy of this software and associated documentation files (the
      "Software"), to deal in the Software without restriction, including
      without limitation the rights to use, copy, modify, merge, publish,
      distribute, sublicense, and/or sell copies of the Software, and to
      permit persons to whom the Software is furnished to do so, subject to
      the following conditions:
  
      The above copyright notice and this permission notice shall be included
      in all copies or substantial portions of the Software.
  
      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
      OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
      MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
      IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
      CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
      TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
      SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    ]]
  }
-- TODO: Make like frame and scan a folder for a list of icons and create icon sets to use.
-- * Local Functions and Variables * --
-- * Moving Global to Local for often used variables.
-- Read more: http://lua-users.org/wiki/OptimisingUsingLocalVariables
local print = print
local love = love 
local unpack = unpack
  
-- * Improved Debug Message Function
  local function dprint(...)
    if m.debug then
      print(m._NAME .. ": ", unpack({...}))
    end
  end

dprint("Loaded")

-- * Take an image, chop it into tiles, return a table of those tiles.
local function quadMaker(image, tilesizex, tilesizey) -- Only supports square tiles.
  local tileset_table = {}
  local counter = 1
  tilesizex = tilesizex or 16
  tilesizey = tilesizey or tilesizex
  for y = 0, image:getHeight()-1, tilesizey do
    for x = 0, image:getWidth()-1, tilesizex do
      tileset_table[counter] = love.graphics.newQuad( x, y, tilesizex, tilesizey, image:getWidth(), image:getHeight())
      counter = counter + 1
    end
  end
  return tileset_table
end

--[[ Configuration ]]-----------------------------------------------------------
-- Texture Image
local game_icon_image = nil

local icon_size = nil

-- Icon Quad Table

  
--[[ End Configuration ]]-------------------------------------------------------

-- Return number of icons.

function m.configure(setup_icon_size, setup_icon_set)
  game_icon_image = setup_icon_set
  icon_size = setup_icon_size
  m.number = quadMaker(game_icon_image, icon_size, icon_size); dprint("Total Icons:", #m.number)
end

function m.count() 
  return #m.number
end

function m.tilesize()
  return icon_size
end

-- Draw icon with the standard love.graphics.draw format
function m.draw_standard(num, ...)
  love.graphics.draw(game_icon_image, m.number[num], unpack({...}))
end

-- Draw icon centered for easy centered rotation
function m.draw(num, ...)
-- Modify values to deal with weird inputs for x,y,r,sx,sy,ox,oy
  local _modify = {unpack({...})}
  _modify[1] = _modify[1] or 0
  _modify[1] = _modify[1] + icon_size/2
  _modify[2] = _modify[2] or 0
  _modify[2] = _modify[2] + icon_size/2
  _modify[3] = _modify[3] or 0
  _modify[4] = _modify[4] or 1
  _modify[5] = _modify[5] or 1
  _modify[6] = icon_size/2
  _modify[7] = icon_size/2
  love.graphics.draw(game_icon_image, m.number[num], unpack(_modify))
end

-- Draw colored centered icon
function m.draw_tint(num, tone, ...)
-- Modify values to deal with weird inputs for x,y,r,sx,sy,ox,oy
  local _modify = {unpack({...})}
  _modify[1] = _modify[1] or 0
  _modify[1] = _modify[1] + icon_size/2
  _modify[2] = _modify[2] or 0
  _modify[2] = _modify[2] + icon_size/2
  _modify[3] = _modify[3] or 0
  _modify[4] = _modify[4] or 1
  _modify[5] = _modify[5] or 1
  _modify[6] = icon_size/2
  _modify[7] = icon_size/2
  tone = tone or {1,1,1,1}
  love.graphics.setColor(tone)
  love.graphics.draw(game_icon_image, m.number[num], unpack(_modify))
  love.graphics.setColor({1,1,1,1})
end

-- Draw icon that's long, rotation point based on first icon.
function m.draw_long(num, count, ...)
  -- Modify values to deal with weird inputs for x,y,r,sx,sy,ox,oy
    for i = 1, count do 
      local _modify = {unpack({...})}
      _modify[1] = _modify[1] or 0
      _modify[1] = _modify[1] + icon_size/2
      _modify[1] = _modify[1] 
      _modify[2] = _modify[2] or 0
      _modify[2] = _modify[2] + icon_size/2
      _modify[3] = _modify[3] or 0
      _modify[4] = _modify[4] or 1
      _modify[5] = _modify[5] or 1
      _modify[6] = icon_size/2 - icon_size * (i-1)
      _modify[7] = icon_size/2
      love.graphics.draw(game_icon_image, m.number[num + (i-1)], unpack(_modify))
    end
  end
--[[ End of library ]]----------------------------------------------------------
return m
  