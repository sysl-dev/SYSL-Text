local m = {
  debug        = true,
  _NAME        = 'GUI Frame',
  _VERSION     = '0.2',
  _DESCRIPTION = 'A frame slicer and drawer, works well with slog.gui. Very beta, please clean up if you use it.',
  _URL         = 'https://github.com/SystemLogoff/SLog-Library',
  _LICENSE     = [[
    MIT LICENSE

    Copyright (c) 2019 Chris / Systemlogoff

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

--[[ Make Global Functions Local ]]---------------------------------------------
-- Read more: http://lua-users.org/wiki/OptimisingUsingLocalVariables
local print = print
local love = love 
local math = math

--[[ Useful Local Functions ]]--------------------------------------------------
local function dprint(...)
  if m.debug then
    print(m._NAME .. ": ", unpack({...}))
  end
end

dprint("Loaded")

--[[ Notes ]]-------------------------------------------------------------------
-- Splits a string into parts by a single character.
-- Inputs, String <String>, Single Character <String> to split
local function stringSplitSingle(str,sep)
  local return_string={}
  local n=1
  for w in str:gmatch("([^"..sep.."]*)") do
     return_string[n] = return_string[n] or w -- only set once (so the blank after a string is ignored)
     if w=="" then
        n = n + 1
     end -- step forwards on a blank but not a string
  end
  return return_string
end


--[[ Configuration ]]-----------------------------------------------------------
--[[ Notes ]]-------------------------------------------------------------------
-- What table holds the image frames? _G[texture_container][folder_frames]
local texture_container = "images"
local folder_frames = "frame"

-- What frame to default to if the wrong one is loaded.
local default_frame = "default"

-- Table that holds the generated frames.
m.select = {}

--[[ Frames ]]------------------------------------------------------------------

--[[ Notes ]]-------------------------------------------------------------------
-- Import all frames from _G[texture_container][folder_frames]
function m.load()
  for i,v in pairs(_G[texture_container][folder_frames]) do
    local temptable = {}
    temptable = stringSplitSingle(i,"_")
    if #temptable == 2 then
        m.create(temptable[1], i ,tonumber(temptable[2]),tonumber(temptable[2]),tonumber(temptable[2]),tonumber(temptable[2]),tonumber(temptable[2]),tonumber(temptable[2]))
      elseif #temptable == 7 then
        m.create(temptable[1], i, tonumber(temptable[2]),tonumber(temptable[3]),tonumber(temptable[4]),tonumber(temptable[5]),tonumber(temptable[6]),tonumber(temptable[7]))
      else
        print("Error: Frame name does not match format. Name_Size, or Name_Size1_Size2_...Size_6")
    end
  end
end

--[[ Notes ]]-------------------------------------------------------------------
-- Slice a frame
function m.create(name, imagename, size, size2, size3, size4, size5, size6)
local image_width = size + size2 + size3
local image_height = size4 + size5 + size6
m.select[name] = {
  ["image"] = imagename,
  ["sizes"] = {size,size2,size3,size4,size5,size6}, -- X Width 1, 2, 3 Row, Y same Col
  ["TL"] = love.graphics.newQuad(0,                 0,                   size, size4, image_width, image_height),
  ["TM"] = love.graphics.newQuad(0 + size,          0,                   size2, size4, image_width, image_height),
  ["TR"] = love.graphics.newQuad(0 + size + size2,  0,                   size3, size4, image_width, image_height),
  ["ML"] = love.graphics.newQuad(0,                 0 + size4,           size, size5, image_width, image_height),
  ["MM"] = love.graphics.newQuad(0 + size,          0 + size4,           size2, size5, image_width, image_height),
  ["MR"] = love.graphics.newQuad(0 + size + size2,  0 + size4,           size3, size5, image_width, image_height),
  ["BL"] = love.graphics.newQuad(0,                 0 + size4 + size5,   size, size6, image_width, image_height),
  ["BM"] = love.graphics.newQuad(0 + size,          0 + size4 + size5,   size2, size6, image_width, image_height),
  ["BR"] = love.graphics.newQuad(0 + size + size2,  0 + size4 + size5,   size3, size6, image_width, image_height),
}
end

--[[ Notes ]]-------------------------------------------------------------------
-- Draw a frame with the parts stretched out.
function m.draw(name,x,y,w,h)
  local frame_image = _G[texture_container][folder_frames]
  local cur_frame = m.select[name]
  if cur_frame == nil then
    cur_frame = m.select[default_frame]
    name = default_frame
  end
  frame_image = frame_image[m.select[name].image]
  local width_center = (w - cur_frame.sizes[1] - cur_frame.sizes[3]) / cur_frame.sizes[2]
  local height_center = (h - cur_frame.sizes[4] - cur_frame.sizes[6]) / cur_frame.sizes[5]
  local padding = {top = cur_frame.sizes[4], right = cur_frame.sizes[3], bottom = cur_frame.sizes[6], left = cur_frame.sizes[1]}

-- Center
  love.graphics.draw(frame_image, cur_frame["MM"], x + padding.left, y + padding.top, 0, width_center, height_center)
-- Sides
  -- Top
  love.graphics.draw(frame_image, cur_frame["TM"], x + padding.left, y, 0, width_center, 1)
  -- Right
  love.graphics.draw(frame_image, cur_frame["MR"], x + w - padding.right, y + padding.top, 0, 1, height_center)
  -- Bottom
  love.graphics.draw(frame_image, cur_frame["BM"], x + padding.left, y + h - padding.bottom, 0, width_center, 1)
  -- Left
  love.graphics.draw(frame_image, cur_frame["ML"], x, y + padding.top, 0, 1, height_center)
-- Corners
  love.graphics.draw(frame_image, cur_frame["TL"], x, y)
  love.graphics.draw(frame_image, cur_frame["TR"], x + w - padding.right, y)
  love.graphics.draw(frame_image, cur_frame["BL"], x, y + h - cur_frame.sizes[6])
  love.graphics.draw(frame_image, cur_frame["BR"], x + w - padding.right, y + h - padding.bottom)
end

--[[ Notes ]]-------------------------------------------------------------------
-- Draw a frame with the parts tiled.
function m.draw_tiled(name,x,y,w,h,not_perfect)
  local trycount = 0
  local adjust_tiles = 0
  not_perfect = not_perfect or false
  local frame_image = _G[texture_container][folder_frames]
  local cur_frame = m.select[name]
  if cur_frame == nil then
    cur_frame = m.select[default_frame]
    name = default_frame
  end
  frame_image = frame_image[m.select[name].image]

  if not not_perfect then 
    trycount = 0
    while w % cur_frame.sizes[2] ~= 0 do
      w = w + 1
      w = math.floor(w)
      trycount = trycount + 1
      if trycount > 100 then break end
    end
    trycount = 0
    while h % cur_frame.sizes[5] ~= 0 do
      h = h + 1
      h = math.floor(h)
      trycount = trycount + 1
      if trycount > 100 then break end
    end
  else 
    adjust_tiles = 1
  end

  local width_center = (w - cur_frame.sizes[1] - cur_frame.sizes[3]) / cur_frame.sizes[2]
  local height_center = (h - cur_frame.sizes[4] - cur_frame.sizes[6]) / cur_frame.sizes[5]
  local padding = {top = cur_frame.sizes[4], right = cur_frame.sizes[3], bottom = cur_frame.sizes[6], left = cur_frame.sizes[1]}

-- Center
  for tx=0, width_center - 1 + adjust_tiles do
    for ty=0, height_center - 1 + adjust_tiles do
      love.graphics.draw(frame_image, cur_frame["MM"], x + padding.left + (tx * cur_frame.sizes[2]) , y + padding.top + (ty * cur_frame.sizes[5]))
    end
  end
-- Sides
  -- Top
  for i=0, width_center - 1 + adjust_tiles do
    love.graphics.draw(frame_image, cur_frame["TM"], x + padding.left + (i * cur_frame.sizes[2]), y)
  end
  -- Right
  for i=0, height_center - 1 + adjust_tiles do
    love.graphics.draw(frame_image, cur_frame["MR"], x + w - padding.right, y + padding.top + (i * cur_frame.sizes[5]))
  end
  -- Bottom
  for i=0, width_center - 1 + adjust_tiles do
    love.graphics.draw(frame_image, cur_frame["BM"],  x + padding.left + (i * cur_frame.sizes[2]), y + h - padding.bottom)
  end
  -- Left
  for i=0, height_center - 1 + adjust_tiles do
    love.graphics.draw(frame_image, cur_frame["ML"], x, y + padding.top + (i * cur_frame.sizes[5]))
  end
-- Corner
  love.graphics.draw(frame_image, cur_frame["TL"], x, y)
  love.graphics.draw(frame_image, cur_frame["TR"], x + w - padding.right, y)
  love.graphics.draw(frame_image, cur_frame["BL"], x, y + h - cur_frame.sizes[6])
  love.graphics.draw(frame_image, cur_frame["BR"], x + w - padding.right, y + h - padding.bottom)
end
--[[ End Frames ]]--------------------------------------------------------------

return m
