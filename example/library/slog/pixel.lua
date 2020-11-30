local m = {
  debug        = false,
  _NAME        = 'SYSL-Pixel-Modified-for-Text-Example',
  _VERSION     = '3.0',
  _DESCRIPTION = 'A Pixel Perfect Screen Scaling Library for Love2D',
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
-- TODO: Expose Canvas Controls


-- * Local Functions and Variables * --
-- * Moving Global to Local for often used variables.
-- Read more: http://lua-users.org/wiki/OptimisingUsingLocalVariables
local print = print
local love = love


-- * Improved Debug Message Function
local function dprint(...)
  if m.debug then
    print(m._NAME .. ": ", unpack({...}))
  end
end

dprint("Loaded")

-- * Capture the conf.lua settings for Window Size
local base = {
  width = love.graphics.getWidth(),
  height = love.graphics.getHeight()
}

-- * A table to hold a series of shaders to apply to the canvas
local shader_pool = {}


--[[ Configuration ]]-----------------------------------------------------------
-- * Allow user to resize window from the system window manager.
-- Note: Recommended false. Has issues with some Linux window managers.
local allow_window_resize = false 

-- * Apply changes to love's scaling and drawing settings.
-- Turn off if you do not want pixel scaling on all objects by default.
local apply_global_scaling_changes = true

-- * When in full screen, only scale by integer.
-- May lead to black borders around the whole screen.
local pixel_perfect_fullscreen = false


-- * Table defining all graphical cursors used.
-- Format {Path to image, -X offset, -Y offset}
-- If unused, change to an empty table.
  local cursor_table = {
   -- {"assets/texture/cursor/cursor1.png",0,0}, -- Commented out due to not being needed
   -- {"assets/texture/cursor/cursor2.png",5,0},
   -- {"assets/texture/cursor/cursor3.png",0,0},
  }


-- * The current graphical cursor to use
-- 0 is a blank cursor.
  m.current_cursor = 1

-- * Show the OS cursor
-- True = Show, False = Hide
-- Applies on game start-up only.
-- m.toggle_cursor() allows you to toggle after the game has loaded.
  m.show_system_cursor_startup = true

--[[ End Configuration ]]-------------------------------------------------------

-- * Functions * --
-- * Will use the max possible window scale if none is defined.
function m.load(defaultScale)
    m.global_changes()
    m.create_pixel_mouse()
    m.canvas = love.graphics.newCanvas(base.width,base.height) -- Canvas used to display the game
    m.canvas2 = love.graphics.newCanvas(base.width,base.height) -- Secondary buffer used to apply shaders
    m.get_monitor_size()
    m.get_max_scale()
    m.get_full_screen_offset()
    defaultScale = defaultScale or m.maxWindowScale
    m.force_cursor(m.show_system_cursor_startup)
    m.set_game_scale(defaultScale)
end

-- * Apply Global Changes To Love2D
function m.global_changes() 
  if apply_global_scaling_changes then 
    love.graphics.setDefaultFilter("nearest", "nearest", 1)
    love.graphics.setLineStyle("rough")
  end  
end

-- * Creates the Pixel Mouse for calculations.
function m.create_pixel_mouse() 
  -- Creates the virtual mouse.
  m.mouse = {
    x = 0,
    y = 0
  }

-- * Table, loads all cursors from cursor_table and assigned them as a new image.
  m.cursors = {}
  for k,v in pairs(cursor_table) do
    m.cursors[k] = love.graphics.newImage(v[1])
  end
end

-- * Required Update Loop
-- Updates offset and the pixel mouse position.
function m.update(dt)
  m.update_pixel_mouse()
  m.get_full_screen_offset()
end

-- Returns the Base Height
function m.base_height()
  return base.height
end 

-- Returns the Base With
function m.base_width()
  return base.width
end


-- * Calculates the monitor size and stores it for later use.
-- Only calculates on the main screen, because that's 99% of what people use. 
function m.get_monitor_size()
    local width, height = love.window.getDesktopDimensions(1)
    m.monitor = {
      w = width,
      h = height
    }
end


-- * Calculates the max scale of the windowed game and full-screen game
function m.get_max_scale() -- This is a much better way to do this.
  local floatWidth = m.monitor.w / base.width
  local floatHeight = m.monitor.h / base.height

  if floatHeight < floatWidth then
      m.maxScale = m.monitor.h / base.height
      -- Subtract 125 to adjust for taskbar
      m.maxWindowScale = math.floor((m.monitor.h - 125) / base.height)
  else
       m.maxScale = m.monitor.w / base.width
       -- Subtract 125 to adjust for taskbar
       m.maxWindowScale = math.floor((m.monitor.w - 125) / base.width)
  end
end


-- * Calculates the offset to draw the canvas in if full-screen.
-- If it's not full-screen, don't bother with offset.
function m.get_full_screen_offset(width, height)
  width = width or m.monitor.w
  height = height or m.monitor.h

  local full_scale = m.maxScale
  if pixel_perfect_fullscreen then 
    full_scale = math.floor(m.maxScale)
  end

  local gameWidth = base.width * full_scale
  local blankWidth = width - gameWidth

  local gameHeight = base.height * full_scale
  local blankHeight = height - gameHeight

  m.offset = {
    x = math.floor(blankWidth/2),
    y = math.floor(blankHeight/2)
  }

  if love.window.getFullscreen() == false then
      m.offset = {x=0, y=0}
  end
end

-- * This function will put everything drawn after into Pixels scaling canvas.
function m.start()
    love.graphics.setCanvas({m.canvas, stencil = true}) -- 11+ Requires Stencil = True
    love.graphics.clear(0,0,0,1)
    love.graphics.setColor(1,1,1,1)
end


-- * Put this after you are done drawing to return to the default canvas and
-- draw the image scaled to the window.
-- This will also apply any stacked shaders as well as the graphical cursor.
function m.stop(hx, hy, hr, hsx, hsy)
  hx = hx or 0
  hy = hy or 0
  hr = hr or 0
  hsx = hsx or 0
  hsy = hsy or 0
  for i=1, #shader_pool do
    love.graphics.setCanvas({m.canvas2, stencil = true})
    love.graphics.setShader(shader_pool[i])
    love.graphics.draw(m.canvas)
    love.graphics.setShader()
    love.graphics.setCanvas({m.canvas, stencil = true})
    love.graphics.draw(m.canvas2)
  end
  m.draw_after_shader()
  if m.current_cursor > 0 and m.current_cursor <= #m.cursors then -- If cursor is not 0 or not out of bounds, draw it.
    love.graphics.draw(m.cursors[m.current_cursor],m.mouse.x - cursor_table[m.current_cursor][2],m.mouse.y- cursor_table[m.current_cursor][3])
  end
    love.graphics.setCanvas()
    love.graphics.draw(m.canvas, hx + m.offset.x , hy + m.offset.y, hr, hsx + m.scale, hsy + m.scale)
end


-- This function is called to resize the screen.
function m.set_game_scale(newScale)
    m.scale = newScale
    love.window.setMode(base.width * m.scale, base.height * m.scale, {fullscreen = false, resizable = allow_window_resize, highdpi = false})
end


-- This function is sets the game to full-screen or returns to windowed mode.
function m.toggle_fullscreen()
    if love.window.getFullscreen() == false then
        local full_scale = m.maxScale
        if pixel_perfect_fullscreen then 
          full_scale = math.floor(m.maxScale)
        end
        m.set_game_scale(full_scale)
        love.window.setFullscreen(true, "desktop")
    else
        m.set_game_scale(math.floor(m.maxWindowScale))
        love.window.setFullscreen(false)
    end
end


-- This function will control resizing with the window.
if allow_window_resize then
 function love.resize(w,h)
      print(w,h)
      if m.scale ~= m.maxScale then
      if base.width * m.scale < w then
        if m.scale + 1 < m.maxScale then
          m.scale = m.scale + 1
          m.set_game_scale(m.scale)
        else
          m.set_game_scale(m.scale)
        end
      elseif base.width * m.scale > w then
        if m.scale - 1 >= 1 then
          m.scale = m.scale - 1
          m.set_game_scale(m.scale)
        else
          m.set_game_scale(m.scale)
        end
      else
        m.set_game_scale(m.scale)
      end
    end
  end
end



-- Functions related to the Pixel Cursor.


-- This updates the pixel mouse, replaces the love.mouse for checking for mouse
-- position.
function m.update_pixel_mouse()
    m.mouse = {
      x = math.floor((love.mouse.getX() - m.offset.x)/m.scale),
      y = math.floor((love.mouse.getY() - m.offset.y)/m.scale)
    }
end


-- This function toggles the system cursor.
function m.toggle_cursor()
  love.mouse.setVisible(not love.mouse.isVisible())
end


-- This function sets the system cursor. Uses true/false.
function m.force_cursor(onoff)
  love.mouse.setVisible(onoff)
end


-- This function sets the graphical cursor, will not set an invalid cursor.
function m.set_cursor(cursorNumber)
  if cursorNumber <= #m.cursors and cursorNumber >=0 then
    m.current_cursor = cursorNumber
  else
    print("Not a valid cursor number.")
  end
end

function m.get_cursor_count()
  return #cursor_table
end


-- Check to see if the pixel mouse in in a defined area.
-- Uses a 3x3 hit rectangle if nothing is defined for the mouse.
function m.mouse_over(local_x,local_y,local_width,local_height,mouse_x,mouse_y,mouse_width,mouse_height)
  mouse_width = mouse_width or 3
  mouse_height = mouse_height or 3
  mouse_x = mouse_x or m.mouse.x
  mouse_y = mouse_y or m.mouse.y
  return local_x < mouse_x + mouse_width and
         mouse_x < local_x + local_width and
         local_y < mouse_y + mouse_height and
         mouse_y < local_y + local_height
end

-- Apply a shader stack to the whole canvas.
function m.push_shader(love_shader)
  shader_pool[#shader_pool+1] = love_shader
end

function m.pop_shader()
  shader_pool[#shader_pool] = nil
end

-- Clear all shaders.
function m.clear_all_shader()
  shader_pool = {}
end

-- Shader Count 
function m.count_shader()
  return #shader_pool
end

-- Draw function to do after shaders have been processed.
function m.change_draw_after_shader(a_function)
  if type(a_function) == "function" then
    m.after_shader_function = a_function
  else
    dprint("Not a function.")
  end
end

-- Clear the function.
function m.clear_draw_after_shader()
  function m.after_shader_function()
  -- Blank by default
  end
end

-- The default function
function m.after_shader_function()
-- Blank by default
end

-- The function that's placed in the pixels:stop function
function m.draw_after_shader()
  if type(m.after_shader_function) == "function" then
    m.after_shader_function()
  end
end

-- Quick Canvas Snapshot Functions


-- Name of table to hold canvas screenshots
local name_screenshots = "screenshot_table"
m[name_screenshots] = {}


-- Capture a screenshot, with a name.
-- Note, does not last past the game closing.
function m.capture_canvas(name)
  name = name or "default"
  local capture = m.canvas:newImageData( 1, 1, 0, 0, base.width, base.height )
  m[name_screenshots][name] = love.graphics.newImage(capture)
end


-- Erases all screenshots
function m.flush_capture()
  m[name_screenshots] = {}
end


-- Erases a screenshot.
function m.remove_capture(name)
  name = name or "default"
  m[name_screenshots][name] = nil
end


-- Check to see if the screenshot/bank exists, recommended before trying to draw
function m.check_capture(name)
  name = name or "default"
  if m[name_screenshots][name] ~= nil then return true else return false end
end


-- Check to see if the screenshot/bank exists, recommended before trying to draw
function m.draw_capture(name, ...)
  name = name or "default"
  if m.check_capture(name) then
    love.graphics.draw(m[name_screenshots][name], unpack({...}))
  end
end


return m
