local m = {
    debug        = false,
    _NAME        = 'Text',
    _VERSION     = '1.0',
    _DESCRIPTION = 'Fancy Text System',
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

--[=[----------------------------------------------------------------------------------------------------
local sysltext = require(library.text)
local text_object = sysltext.new()

-- Sending Text 
text_object:send([[This is some text.]], 224, false) 

-- Send more text to override what is there and start rendering again 
-- See tags below for effects

-- In Love Draw 
text_object:draw(x, y)

-- In Love Update 
text_object:update(dt)


----------------------------------------------------------------------------------------------------]=]--


--[[----------------------------------------------------------------------------------------------------
        Convert Global Commands to Local
        Read more: http://lua-users.org/wiki/OptimisingUsingLocalVariables
----------------------------------------------------------------------------------------------------]]--                                                                 
local unpack = unpack 
local love = love 

--[[----------------------------------------------------------------------------------------------------
        Debug Print - Confirms Loaded when m.debug is true.
----------------------------------------------------------------------------------------------------]]--   
local function dprint(...) 
    if m.debug then
        print(m._NAME .. ": ", unpack({...}))
    end
end
dprint("Loaded")

--[[----------------------------------------------------------------------------------------------------
        Defaults
----------------------------------------------------------------------------------------------------]]--   
--[[ Default Picture ]]---------------------------------------------------------------------------------
-- Creates a picture to draw in case someone passes a non-existent picture.
local _undefined_image = love.image.newImageData(16,16)
for i = 0, 15 do
    _undefined_image:setPixel(i, 0, 1, .2, .2, 1) 
    _undefined_image:setPixel(0, i, .2, .2, 1, 1)
    _undefined_image:setPixel(9, i, .2, 1, .2, 1) 
    _undefined_image:setPixel(i, 9, 1, 1, .2, 1)
    _undefined_image:setPixel(i, i, 1, .2, 1, 1)
end
local undefined_image = love.graphics.newImage(_undefined_image)

--[[ Default Audio ]]-----------------------------------------------------------------------------------
-- Table of voices to use for speaking.
local text_sounds = {
love.audio.newSource( 'assets/audio/sound/default.ogg', "static" ),
}

--[[ Screen Size ]]-------------------------------------------------------------------------------------
-- Capture the base game height before it resizes
local base = {
    width = love.graphics.getWidth(),
    height = love.graphics.getHeight()
  }

--[[ Magic Characters ]]---------------------------------------------------------------------------------
-- 1. The start character for a command. 
-- 2. The end character for a command.
-- 3. What one time commands are tagged with so they do not run again.
-- 4. What is the separator when you have a command that passes a value.
local special_character = {"[","]","DONE#","=","|"}

--[[ Data Shortcuts ]]----------------------------------------------------------------------------------
-- Text assumes that you are storing your assets in a table for access.
-- You may have to hack some functions if this is incorrect for your project.
local font_table = "font_table" -- Table of fonts 
local shader_table = "shader_table" -- Table of different shaders 
local palette_table = "palette_table" -- Table of palettes, format {{1,1,1,1}, {0,1,1,1}, ... }
local image_table = "image_table" -- Table of love.graphics.newImage() userdata
local icon_table = "icon_table" -- Quad of icons, see #change_icons to change

--[[----------------------------------------------------------------------------------------------------
       Local Functions
----------------------------------------------------------------------------------------------------]]--   
--[[ Special Character Conversion ]]--------------------------------------------------------------------
-- Change escape characters I care about into commands
local function convert_special_character(char) 
    if char == "\n" then 
        return special_character[1] .. "newline" .. special_character[2] 
    elseif char == "\t" then 
        return special_character[1] .. "tab" .. special_character[2] 
    else 
        return char
    end
end

--[[ Get character Width ]]-----------------------------------------------------------------------------
-- Get the width of the current character width the current font.
local function getCharacterWidth(character)
    return love.graphics.getFont():getWidth(character)
end

--[[ Get character Height ]]----------------------------------------------------------------------------
-- Get the width of the current character height the current font.
local function getCharacterHeight(character)
    return love.graphics.getFont():getHeight(character)
end

--[[ Tag Command ]]--------------------------------------------------------------------------------------
-- Tag the end of the command once run with special_character[3] so it only runs once.
local function oneTimeCommand(self)
    self.table_string[self.current_character-1] = self.table_string[self.current_character-1]:sub(2, #self.table_string[self.current_character-1] - 1)
    self.table_string[self.current_character-1] = special_character[1] .. special_character[3] .. self.table_string[self.current_character-1] .. special_character[2]
end

--[[ Split Sting ]]--------------------------------------------------------------------------------------
-- Split a string into a table with a separator character.
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

 --[[ Table Copy ]]----------------------------------------------------------------------------------------
 -- Shallow copy a table
 local function shallowcopy(table_string)
    local table_copy
    if type(table_string) == 'table' then
        table_copy = {}
        for orig_key, orig_value in pairs(table_string) do
            table_copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc.
        table_copy = table_string
    end
    return table_copy
end

 --[[ String to Table ]]-------------------------------------------------------------------------------
-- Change.a.string to a table: change[a][string]
local function string2table(string)
    local table_find = _G -- Select the global table
    for w in string.gmatch(string, "[%w_]+") do -- matches both alphanumeric characters and underscores, more than once
        assert(table_find[w], "This table does not exist: " .. string)
        table_find = table_find[w]    -- for each one start gluing the table back together
    end
    return table_find -- Return the table reference 
end


--[[----------------------------------------------------------------------------------------------------
       Class Functions
----------------------------------------------------------------------------------------------------]]-- 
local M = {}
local cursor = {x = 0, y = 0}
local cursor_storage = {x = 0, y = 0}

--[[----------------------------------------------------------------------------------------------------
       SEND - Sends a string to be drawn by the current textbox.
----------------------------------------------------------------------------------------------------]]-- 
function M:send(text, wrap_num, show_all)
    text = text or "ERROR_NO_SENT_TEXT" -- Set a default message if nothing was sent.
    text = text .. special_character[1] .. "end" .. special_character[2] -- Append an 'end' tag to the end of the string
    wrap_num = wrap_num or nil -- Wrap text at this many pixels
    self.table_string = {}
    self.timer_pause = 0
    self.timer_print = 0
    self.command_modifer = ""
    self.current_character = 0
    self.sound_every_counter = 1
    ------------------------------------------------------------------------------
    -- String -> Table, with the commands being split by special characters
    ------------------------------------------------------------------------------
    local command_word = false  -- Special Character is always off at the start of any new string processing
    for i = 1, #text do -- For each character in the string, do the following
        local character = text:sub(i,i) -- Separate the character -- TODO UTF8Fix, for now use the insert commands
        character = convert_special_character(character) -- Convert any special characters
        if character == special_character[1] then -- If it's the first special character, confirm that 
            command_word = true                     -- all should be combined until the second special character
            self.table_string[#self.table_string+1] = ""  -- Create the next table entry as an empty string
        end
        if command_word then 
            self.table_string[#self.table_string] = self.table_string[#self.table_string] .. character:lower() -- Combine while command word is on / Commands are always LOWERCASE
        else 
            self.table_string[#self.table_string+1] = character -- push a single character otherwise
        end
        if character == special_character[2] then 
            command_word = false -- If the second special_character is found, stop combining.
        end
    end
    --print(unpack(self.table_string))
    ------------------------------------------------------------------------------
    -- Wraps text by a set number of pixels. Note: Assumes your self.default font!
    -- This whole thing is very greedy.
    ------------------------------------------------------------------------------
    if wrap_num then 
        if type(wrap_num) ~= "number" then wrap_num = 200 end
        local last_space = 0
        local pixel_count = 0
        local pixel_count_last_space = 0
        local line_length = {}
        local line_start = {1,}
        local space_locations = {}
        local spaces_per_line = {}
        local space_count = 0
        local fulljustspace = {}
        for i=1, #self.table_string do 
            if #self.table_string[i] == 1 then 
                -- Keep track of the last space.
                if self.table_string[i] == " " then 
                    last_space = i 
                    pixel_count_last_space = 0
                end
                -- Count the pixels for the characters 
                pixel_count = pixel_count + getCharacterWidth(self.table_string[i])
                pixel_count_last_space = pixel_count_last_space + getCharacterWidth(self.table_string[i])
                if pixel_count > wrap_num then 
                    if last_space ~= 0 then 
                        self.table_string[last_space] = special_character[1] .. "newline" .. special_character[2] 
                        line_start[#line_start+1] = last_space+1
                    else 
                        table.insert(self.table_string, i, special_character[1] .. "newline" .. special_character[2])
                        line_start[#line_start+1] = i+1
                        pixel_count_last_space = 0
                    end
                    last_space = 0 
                    pixel_count = pixel_count_last_space
                    pixel_count_last_space = 0
                end
            else 
                if self.table_string[i]:match("newline") then 
                    line_start[#line_start+1] = i+1
                    last_space = 0 
                    pixel_count = 0
                    pixel_count_last_space = 0
                end
                if self.table_string[i]:match("icon") then 
                    pixel_count = pixel_count + 16
                    pixel_count_last_space = pixel_count_last_space + 16
                end
            end
        end
        if self.rendering ~= "left" then
            pixel_count = 0
            for i=1, #self.table_string do 
                if #self.table_string[i] == 1 then 
                    pixel_count = pixel_count + getCharacterWidth(self.table_string[i])
                    if self.table_string[i] == " " then 
                        space_locations[#space_locations+1] = i 
                        space_count = space_count + 1
                    end
                else 
                    if self.table_string[i]:match("newline") or self.table_string[i]:match("end") then 
                        line_length[#line_length+1] = pixel_count
                        pixel_count = 0
                        spaces_per_line[#spaces_per_line+1] = space_count
                        space_count = 0
                    end
                    if self.table_string[i]:match("icon") then 
                        pixel_count = pixel_count + 16
                        pixel_count_last_space = pixel_count_last_space + 16
                    end
                end 
            end
            if self.rendering == "right" then 
                for i = #line_start, 1, -1 do 
                table.insert(self.table_string, line_start[i], special_character[1] .. "pad=" .. wrap_num - line_length[i] .. special_character[2])
                end 
            end
            if self.rendering == "center" then 
                for i = #line_start, 1, -1 do 
                table.insert(self.table_string, line_start[i], special_character[1] .. "pad=" .. math.floor((wrap_num - line_length[i])/2) ..special_character[2])
                end 
            end
            if self.rendering == "full" then -- Greedy
                for i=1, #spaces_per_line do 
                    for each_space=1, spaces_per_line[i] do 
                        fulljustspace[#fulljustspace+1] = special_character[1] .. "pad=" .. ((wrap_num - line_length[i])/spaces_per_line[i])  + getCharacterWidth(" ") .. special_character[2]
                        if false then print(line_length[i],spaces_per_line[i],(wrap_num - line_length[i])/spaces_per_line[i] + 0.5) end
                    end
                end
                if false then print(unpack(fulljustspace)) end
                for i=1, #space_locations do 
                    self.table_string[space_locations[i]] = fulljustspace[i]
                end
            end
        end
    end

  
    ------------------------------------------------------------------------------
    -- Forces the string to display without drawing one at a time.
    -- Also removes any banned commands from instant display.
    ------------------------------------------------------------------------------
    if show_all then 
        local banned_commands = {"backspace", "pause", "skip"} -- HACK: Some commands are now allowed when showing all the text at once.
        for i = 1, #self.table_string do 
            for x=1, #banned_commands do 
                if self.table_string[i]:match(banned_commands[x]) then 
                    self.table_string[i] = special_character[1] .. special_character[3] .. banned_commands[x] .. special_character[2]
                end
            end
        end
        self.current_character = #self.table_string
    end


    for i = 1, #self.table_string do 
        if self.table_string[i]:match("%" .. special_character[1] .. special_character[5] .. "sp1" .. "%"  .. special_character[2]) then 
           -- print(self.table_string[i])
                self.table_string[i] = special_character[1]
        end
        if self.table_string[i]:match("%" .. special_character[1] .. special_character[5] .. "sp2" .. "%"  .. special_character[2]) then 
            --print(self.table_string[i])
                self.table_string[i] = special_character[2]
        end
        if self.table_string[i]:match("%" .. special_character[1] .. special_character[5]) then 
            self.table_string[i] = self.table_string[i]:sub(3, #self.table_string[i] - 1)
           -- print(self.table_string[i])
        end
    end

end

--[[----------------------------------------------------------------------------------------------------
       SETDEFAULTS - Resets to default values at the start of string rendering.
----------------------------------------------------------------------------------------------------]]-- 
function M:setDefaults()
    -- Text
    self.current_color = self.default_color
    love.graphics.setFont(self.default_font)
    self.current_print_speed = self.default_print_speed
    -- Commands
    for k, v in pairs(self.draw_flags) do 
        self.draw_flags[k] = false
    end
end

--[[----------------------------------------------------------------------------------------------------
       DRAW - Draw the text, with or without a canvas.
----------------------------------------------------------------------------------------------------]]-- 
function M:draw(tx, ty)
    if #self.table_string == 0 then return end -- Don't bother trying to do anything if the string is empty.
    local old_canvas = love.graphics.getCanvas() -- Capture the current canvas
    ------------------------------------------------------------------------------
    -- Render on a canvas if self.canvas is true
    ------------------------------------------------------------------------------
    if self.use_canvas then
        love.graphics.setCanvas({self.canvas, stencil = false})
        love.graphics.clear(0,0,0,0) -- Clear the canvas so we don't get ghost images
    end
    ------------------------------------------------------------------------------
    -- Reset any cursor positions
    ------------------------------------------------------------------------------
    cursor = {x = 0, y = 0}
    cursor_storage = {x = 0, y = 0}
    ------------------------------------------------------------------------------
    -- Define the default drawing values, and set the defaults before 
    -- entering the draw loop.
    ------------------------------------------------------------------------------
    local str = {x = tx + getCharacterHeight("W")/2, y = ty + getCharacterHeight("W")/2, rot = 0, sx = 1, sy = 1, ox = getCharacterHeight("W")/2, oy = getCharacterHeight("W")/2, padding = 0}
    self:setDefaults()
    ------------------------------------------------------------------------------
    -- Step though each character in the table and do the following:
    ------------------------------------------------------------------------------    
    for i=1, self.current_character do 
        str = self:changeDraw(str, tx, ty, i)   -- Apply any changes to the drawing depending on the draw flags.
        if self.table_string[i] then    -- If a valid character then:
            if not self.table_string[i]:match("%" .. special_character[1] .. ".") then -- If it's equal to only 1 or 2 character[s] then:
                self:addDraw(str, tx, ty, i) -- Draw any extra draw commands depending on draw flags
                love.graphics.setColor(self.current_color)  -- Set the color to the current color 
                love.graphics.print(self.table_string[i], str.x + cursor.x, str.y + cursor.y, str.rot, str.sx, str.sy, str.ox, str.oy) -- Print Text
                cursor.x = cursor.x + getCharacterWidth(self.table_string[i]) -- Move cursor the length of the character.
                cursor.x = cursor.x + str.padding -- Move the cursor a bit more for padding reasons.
                love.graphics.setColor(1,1,1,1) -- Reset to pure white
                love.graphics.setShader()
            else 
                self:doCommand(self.table_string[i])(self, i) -- If the character is > 1 then it's a command, and we do a command.
            end
        end
    end
    love.graphics.setColor(1,1,1,1)  -- Reset to pure white
    love.graphics.setFont(self.default_font)
    -----------------------------------------------------------------------------
    -- Render to the main canvas if self.canvas is true
    ------------------------------------------------------------------------------
    if self.use_canvas then
        love.graphics.setCanvas({old_canvas, stencil = true})
        love.graphics.setBlendMode("alpha", "premultiplied") -- In case we have any alpha images.
        love.graphics.draw(self.canvas, base.width/2, base.height/2, 0, 1, 1, base.width/2, base.height/2)
        love.graphics.setBlendMode("alpha", "alphamultiply") -- Return to default blend mode.
    end
end

--[[----------------------------------------------------------------------------------------------------
       UPDATE - Timers tick onwards, play sounds, characters print
----------------------------------------------------------------------------------------------------]]-- 
function M:update(dt)
    -----------------------------------------------------------------------------
    -- Animation Timer
    -----------------------------------------------------------------------------
    self.timer_animation = self.timer_animation + dt 
    if self.timer_animation > 1048576 then self.timer_animation = 0 end

    -----------------------------------------------------------------------------
    -- Pause Timer
    -- Always counting down, pauses printing when > 0
    -----------------------------------------------------------------------------    
        self.timer_pause = self.timer_pause - dt 
        if self.timer_pause < 0 then self.timer_pause = 0 end
        if self.timer_pause == 0 then 
            -----------------------------------------------------------------------------
            -- Printing Characters Timer
            -----------------------------------------------------------------------------
            self.timer_print = self.timer_print + dt -- Timer counts up in seconds.
    
            if self.timer_print > self.current_print_speed then 
                self.timer_print = 0    -- If we hit the print speed, we reset the timer.
                -----------------------------------------------------------------------------
                -- Advance the current max character printed if not paused
                -----------------------------------------------------------------------------
                self.current_character = self.current_character + 1

                -----------------------------------------------------------------------------
                -- Character Noises
                -----------------------------------------------------------------------------
                
                if self.character_sound then 
                    if self.table_string[self.current_character] and self.current_character ~= #self.table_string and not self.table_string[self.current_character]:match("%" .. special_character[1]) then 
                        if self.sound_every_counter >= self.sound_every then 
                            if self.table_string[self.current_character] ~= " " then
                                text_sounds[self.sound_number]:stop()
                                text_sounds[self.sound_number]:play()
                                self.sound_every_counter = 1 
                            end
                        else
                            self.sound_every_counter = self.sound_every_counter + 1
                        end
                    end
                end
            end
        
            -----------------------------------------------------------------------------
            -- Skip waiting for rendering when it's a command.
            -----------------------------------------------------------------------------
            if self.table_string[self.current_character] and self.table_string[self.current_character]:match("%" .. special_character[1]) then 
            self.current_character = self.current_character + 1
            end
        end


    -- Limit the current character to the length of the string.
    if self.current_character > #self.table_string then 
        self.current_character = #self.table_string
    end

end 

--[[----------------------------------------------------------------------------------------------------
       COMMAND TABLE - Special commands used when rending text.
----------------------------------------------------------------------------------------------------]]-- 
M.command_table = {
    -----------------------------------------------------------------------------
    --  Script Commands
    -----------------------------------------------------------------------------
    --[[ Runs at end of string ]]------------------------------------------------
    ["end"] = 
    function(self) self:setDefaults()  end,

    -----------------------------------------------------------------------------
    --  Position Commands
    -----------------------------------------------------------------------------
    --[[ Move to next line ]]----------------------------------------------------
    ["newline"] = 
    function(self) cursor.x = 0 cursor.y = cursor.y + getCharacterHeight("W") + 4  end,

    --[[ Save Cursor Position ]]-------------------------------------------------
    ["cursorsave"] = 
    function(self) 
        cursor_storage.x = cursor.x
        cursor_storage.y = cursor.y 
    end,

    --[[ Load Cursor Position ]]-------------------------------------------------
    ["cursorload"] = 
    function(self) 
        cursor.x = cursor_storage.x
        cursor.y = cursor_storage.y
    end,

    --[[ Set X Cursor Position ]]------------------------------------------------
    ["cursorx"] = 
    function(self) 
        local _mod1 = tonumber(self.command_modifer[2])
        if type(_mod1) ~= "number" then return end
        cursor.x = _mod1
    end,
    
    --[[ Set Y Cursor Position ]]------------------------------------------------
    ["cursory"] =
    function(self) 
        local _mod1 = tonumber(self.command_modifer[2])
        if type(_mod1) ~= "number" then return end
        cursor.y = _mod1
    end,

    --[[ Tab Indent Text ]]------------------------------------------------------
    ["tab"] = -- Moves over 4 spaces.
    function(self) cursor.x = cursor.x + love.graphics.getFont():getWidth(" ")*4 end,

   --[[ Pad out the text this many pixels ]]-------------------------------------
   ["pad"] =
   function(self) 
       local _mod1 = tonumber(self.command_modifer[2])
       if type(_mod1) ~= "number" then return end
       cursor.x = cursor.x + _mod1
   end,
    -----------------------------------------------------------------------------
    --  Character Timing
    -----------------------------------------------------------------------------
    --[[ Skip to the end of the string ]]----------------------------------------
    ["skip"] = 
    function(self) self.current_character = #self.table_string end,

    --[[ Pause for a set period ]]-----------------------------------------------
    ["pause"] =
    function(self) 
        oneTimeCommand(self) 
        local _mod1 = tonumber(self.command_modifer[2])
        --print("Pause", _mod1)
        if type(_mod1) ~= "number" then return end
        if _mod1 <= 0 then return end
        self.timer_pause = _mod1     
    end,

    --[[ Delete a set number of characters, destructive ]]-----------------------
    ["backspace"] =
    function(self, i) oneTimeCommand(self)  
        local _mod1 = tonumber(self.command_modifer[2])
        if type(_mod1) ~= "number" then return end
        if _mod1 <= 0 then return end
        for _=1, _mod1 + 1 do 
            table.remove(self.table_string, self.current_character - 1)
            if self.current_character > 2 then 
                self.current_character = self.current_character - 1 
            end
        end 
    end,

    --[[ Change the speed for printing the characters ]]-------------------------
    ["textspeed"] = 
    function(self) 
        local _mod1 = tonumber(self.command_modifer[2])
        if type(_mod1) ~= "number" then return end
        self.current_print_speed = _mod1
    end,

    --[[ Reset the speed for printing the characters ]]--------------------------
    ["/textspeed"]  = 
    function(self) self.current_print_speed = self.default_print_speed end,

    -----------------------------------------------------------------------------
    --  Text Formatting
    -----------------------------------------------------------------------------
    --[[ Set the text color ]]---------------------------------------------------
    ["color"] = -- Sets the current color to a color on your palette table.
    function(self)
        local palette_table = string2table(palette_table)
        local _mod1 = tonumber(self.command_modifer[2])
        if type(_mod1) ~= "number" then return end
        if _mod1 > #palette_table then return end
        if _mod1 < 1 then return end
        self.current_color = palette_table[_mod1]
    end,

    --[[ Reset the text color ]]-------------------------------------------------
    ["/color"] = -- Resets color to the default color.
    function(self, i) self.current_color = self.default_color end,

    --[[ Set the text shadow color ]]---------------------------------------------------
    ["shadowcolor"] = 
    function(self)
        local palette_table = string2table(palette_table)
        local _mod1 = tonumber(self.command_modifer[2])
        if type(_mod1) ~= "number" then return end
        if _mod1 > #palette_table then return end
        if _mod1 < 1 then return end
        self.current_shadow_color = palette_table[_mod1]
    end,

    --[[ Reset the text shadow color ]]-------------------------------------------------
    ["/shadowcolor"] = 
    function(self, i) self.current_shadow_color = self.default_shadow_color end,

    --[[ Set the font ]]--------------------------------------------------------
    ["font"] =
    function(self)
        local font_table = string2table(font_table)
        local _mod1 = self.command_modifer[2]
        if font_table[_mod1] then 
            love.graphics.setFont(font_table[_mod1])
        else 
            love.graphics.setFont(self.default_font)
        end
    end,

    --[[ Reset the font ]]------------------------------------------------------
    ["/font"] = -- Resets the font to default.
    function(self) love.graphics.setFont(self.default_font) end,

    --[[ Set the shader ]]------------------------------------------------------
    ["shader"] =
    function(self)
        local shader_table = string2table(shader_table)
        local _mod1 = self.command_modifer[2]
        if shader_table[_mod1] then 
            self.draw_flags.shader = shader_table[_mod1]
        else 
            self.draw_flags.shader = nil
        end
    end,

    --[[ Reset the shader ]]----------------------------------------------------
    ["/shader"] = -- Resets the font to default.
    function(self) self.draw_flags.shader = nil end,

    --[[ Set drop shadow, Keypad Number is the Position of the shadow  ]]---------
    ["dropshadow"] =
    function(self) 
        local _mod1 = tonumber(self.command_modifer[2])
        if type(_mod1) ~= "number" then return end
        self.draw_flags.dropshadow = _mod1
    end,

    --[[ Turn off Drop shadow ]]--------------------------------------------------
    ["/dropshadow"]  = -- Turn off dropshadow
    function(self) self.draw_flags.dropshadow = false end,

    --[[ Scale Text times this value  ]]-----------------------------------------
    ["scale"] =
    function(self) 
        local _mod1 = tonumber(self.command_modifer[2])
        if type(_mod1) ~= "number" then return end
        self.draw_flags.scale = _mod1
    end,

    --[[ Turn off scale ]]-------------------------------------------------------
    ["/scale"]  = -- Turn off scale
    function(self) self.draw_flags.scale = false end,

    --[[ Rotate Text by this value  ]]-------------------------------------------
    ["rotate"] =
    function(self) 
        local _mod1 = tonumber(self.command_modifer[2])
        if type(_mod1) ~= "number" then return end
        self.draw_flags.rotate = _mod1
    end,

    --[[ Turn off rotate ]]------------------------------------------------------
    ["/rotate"]  = 
    function(self) self.draw_flags.rotate = false end,

    --[[ Fake Italics - Large Fonts Only ]]--------------------------------------
    ["i"] = 
    function(self) self.draw_flags.italics = true end,

    --[[ Turn off Fake Italics ]]------------------------------------------------
    ["/i"] = -- Turns off italics.
    function(self) self.draw_flags.italics = false end,

    --[[ Fake Bold ]]------------------------------------------------------------
    ["b"] = 
    function(self) self.draw_flags.fakebold = true end,

    --[[ Turn off Fake Bold ]]---------------------------------------------------
    ["/b"] = -- Turns off italics.
    function(self) self.draw_flags.fakebold = false end,

    --[[ Print Text Backwards ]]-------------------------------------------------
    ["mirror"] = 
    function(self) self.draw_flags.mirror = true end,

    --[[ Turn Off Print Text Backwards ]]----------------------------------------
    ["/mirror"] = 
    function(self) self.draw_flags.mirror = false end,

    -----------------------------------------------------------------------------
    --  Movement Commands
    -----------------------------------------------------------------------------
    --[[ Shaking Text, delayed circle pattern ]]---------------------------------
    ["shake"] = 
    function(self) self.draw_flags.shake = true end,

    --[[ Shaking Text, Off ]]----------------------------------------------------
    ["/shake"] = 
    function(self) self.draw_flags.shake = false end,

    --[[ Text spins from it's center ]]------------------------------------------
    ["spin"] = 
    function(self) self.draw_flags.spin = true end,

    --[[ Spinning Text, Off ]]----------------------------------------------------
    ["/spin"] = 
    function(self) self.draw_flags.spin = false end,

    --[[ Text swings from it's center ]]-----------------------------------------
    ["swing"] = 
    function(self) self.draw_flags.swing = true end,

    --[[ swinging Text, Off ]]---------------------------------------------------
    ["/swing"] = 
    function(self) self.draw_flags.swing = false end,

    --[[ Text falls like rain ]]-------------------------------------------------
    ["raindrop"] = 
    function(self) self.draw_flags.raindrop = true end,

    --[[ Raining Text, Off ]]----------------------------------------------------
    ["/raindrop"] = 
    function(self) self.draw_flags.raindrop = false end,

    --[[ Text bounce up and down ]]----------------------------------------------
    ["bounce"] = 
    function(self) self.draw_flags.bounce = true end,

    --[[ Bouncing Text, Off ]]---------------------------------------------------
    ["/bounce"] = 
    function(self) self.draw_flags.bounce = false end,

    --[[ Text blink ]]-----------------------------------------------------------
    ["blink"] = 
    function(self) self.draw_flags.blink = true end,

    --[[ Blinking Text, Off ]]---------------------------------------------------
    ["/blink"] = 
    function(self) self.draw_flags.blink = false end,

    --[[ RAINBOW COLORS ]]--------------------------------------------------------
    ["rainbow"] = 
    function(self) self.draw_flags.rainbow = true end,

    --[[ Rainbow Text, Off ]]-----------------------------------------------------
    ["/rainbow"] = 
    function(self) self.draw_flags.rainbow = false self.current_color = self.default_color end,

    -----------------------------------------------------------------------------
    --  Image Commands TODO
    -----------------------------------------------------------------------------
    --[[ Draw an icon #change_icons ]]-------------------------------------------
    ["icon"] = 
    function(self)
        local icon_table = string2table(icon_table)
        local _mod1 = tonumber(self.command_modifer[2])
        if type(_mod1) ~= "number" then return end
        if _mod1 > #icon_table.number then return end
        if _mod1 < 1 then return end
        icon_table.draw(_mod1, cursor.x, cursor.y) -- Change to your icon drawing library of choice
        cursor.x = cursor.x + 16
    end,

    --[[ Draw a picture ]]-------------------------------------------------------
    ["image"] = 
    function(self)    
        local image_table = string2table(image_table)
        local _mod1 = self.command_modifer[2]
        if image_table[_mod1] then
            love.graphics.draw(image_table[_mod1], cursor.x, cursor.y)
            cursor.x = cursor.x + image_table[_mod1]:getWidth()
        else 
            love.graphics.draw(undefined_image, cursor.x, cursor.y)
            cursor.x = cursor.x + undefined_image:getWidth()            
        end
    end,
    -----------------------------------------------------------------------------
    --  Sound Commands TODO
    -----------------------------------------------------------------------------
}

--[[----------------------------------------------------------------------------------------------------
       DOCOMMAND - Do the command if it's found in the command table.
----------------------------------------------------------------------------------------------------]]-- 
function M:doCommand(command)
    local splitcommands = {} -- Table to hold commands if they are split.
    command = command:sub(2, #command - 1) -- Trim special_characters from the entry
    if command:match(special_character[4]) then -- If the split character is in the command
        command = command:gsub("%s" .. special_character[4] .. "%s", special_character[4]) -- Trim spaces around it
        splitcommands = stringSplitSingle(command, "=") -- Split commands into tables
        command = splitcommands[1] -- Make sure that the command is still sent as normal
        self.command_modifer = splitcommands -- Send the command modifiers to a place we can access them
    end
    if self.command_table[command] then -- If found 
        return self.command_table[command] -- Return the command function
    end 
    return function() end -- Return a blank function if nothing is found.
end

--[[----------------------------------------------------------------------------------------------------
       CHANGE DRAW - Change the draw parameters depending on flags
----------------------------------------------------------------------------------------------------]]-- 
function M:changeDraw(str, tx, ty, i) 
    local strchg = {
        x = math.floor(((tx + getCharacterHeight("I")/2)) + 0.5 ),
        y = math.floor(((ty + getCharacterHeight("I")/2)) + 0.5 ),
        rot = 0,
        sx = 1,
        sy = 1,
        ox = math.floor(((getCharacterHeight("I")/2)) + 0.5 ),
        oy = math.floor(((getCharacterHeight("I")/2)) + 0.5 ),
        padding = 0,
    }
    if self.draw_flags.italics then 
        strchg.rot = strchg.rot + math.rad(10)
    end

    if self.draw_flags.swing then 
        strchg.rot = strchg.rot + math.rad(math.sin(self.timer_animation*10) * 10)
    end

    if self.draw_flags.shake then 
        strchg.x = math.floor((tx + getCharacterWidth("W")/2 + math.sin(self.timer_animation*15 + i/2)) + 0.5 ) + getCharacterWidth(" ")
        strchg.y = math.floor((ty + getCharacterHeight("W")/2 + math.cos(self.timer_animation*15 + i/2)) + 0.5 )
    end

    if self.draw_flags.spin then 
        strchg.x = math.floor((tx + getCharacterWidth(self.table_string[i])/2) + 0.5 )
        strchg.y = math.floor((ty + getCharacterHeight(self.table_string[i])/2) + 0.5 )
        strchg.ox = math.floor((getCharacterWidth(self.table_string[i])/2) + 0.5 )
        strchg.oy = math.floor((getCharacterHeight(self.table_string[i])/2) + 0.5 )
        strchg.rot = strchg.rot + self.timer_animation * 5
    end
    
    if self.draw_flags.raindrop then 
        strchg.y = ty + math.tan((self.timer_animation)*3 + i) + getCharacterHeight(self.table_string[i])/2
    end

    if self.draw_flags.mirror then 
        strchg.sx = strchg.sx * -1
        strchg.ox = getCharacterWidth(self.table_string[i])
    end

    if self.draw_flags.bounce then 
        strchg.y = math.floor((strchg.y + 2 * math.sin(self.timer_animation * 10 + i)) + 0.5)
    end

    if self.draw_flags.blink then 
        if math.floor(self.timer_animation * 2) %2 == 0 then 
            strchg.sy = strchg.sy * 0
        end
    end


    if self.draw_flags.scale and self.draw_flags.scale ~= 0 and type(self.draw_flags.scale) == "number" then 
        strchg.sx = self.draw_flags.scale
        strchg.sy = self.draw_flags.scale
        strchg.padding = (getCharacterWidth(self.table_string[i]) * self.draw_flags.scale) - getCharacterWidth(self.table_string[i])
    end

    if self.draw_flags.rotate and type(self.draw_flags.rotate) == "number" then 
        strchg.x = math.floor((tx + getCharacterWidth(self.table_string[i])/2) + 0.5 )
        strchg.y = math.floor((ty + getCharacterHeight(self.table_string[i])/2) + 0.5 )
        strchg.ox = math.floor((getCharacterWidth(self.table_string[i])/2) + 0.5 )
        strchg.oy = math.floor((getCharacterHeight(self.table_string[i])/2) + 0.5 )
        strchg.rot = strchg.rot + math.rad(self.draw_flags.rotate)
        strchg.padding = 2
    end

    if self.draw_flags.fakebold then 
        strchg.padding = 1
      end
  

    return shallowcopy(strchg)
end

function M:addDraw(str, tx, ty, i) 

    if self.draw_flags.shader then 
        love.graphics.setShader(self.draw_flags.shader)
    end
    
    if self.draw_flags.dropshadow and self.draw_flags.dropshadow ~= 0  and self.draw_flags.dropshadow < 11 then 
        love.graphics.setColor(self.current_shadow_color)
        local dropshadowtable = {
            function() love.graphics.print(self.table_string[i], str.x + cursor.x - 1, str.y + cursor.y + 1, str.rot, str.sx, str.sy, str.ox, str.oy) end,
            function() love.graphics.print(self.table_string[i], str.x + cursor.x - 0, str.y + cursor.y + 1, str.rot, str.sx, str.sy, str.ox, str.oy) end,
            function() love.graphics.print(self.table_string[i], str.x + cursor.x + 1, str.y + cursor.y + 1, str.rot, str.sx, str.sy, str.ox, str.oy) end,
            function() love.graphics.print(self.table_string[i], str.x + cursor.x - 1, str.y + cursor.y + 0, str.rot, str.sx, str.sy, str.ox, str.oy) end,
            function()
                 love.graphics.print(self.table_string[i], str.x + cursor.x - 1, str.y + cursor.y + 0, str.rot, str.sx, str.sy, str.ox, str.oy) 
                 love.graphics.print(self.table_string[i], str.x + cursor.x + 1, str.y + cursor.y + 0, str.rot, str.sx, str.sy, str.ox, str.oy) 
                 love.graphics.print(self.table_string[i], str.x + cursor.x - 0, str.y + cursor.y + 1, str.rot, str.sx, str.sy, str.ox, str.oy) 
                 love.graphics.print(self.table_string[i], str.x + cursor.x - 0, str.y + cursor.y - 1, str.rot, str.sx, str.sy, str.ox, str.oy) 
                end,
            function() love.graphics.print(self.table_string[i], str.x + cursor.x + 1, str.y + cursor.y + 0, str.rot, str.sx, str.sy, str.ox, str.oy) end,
            function() love.graphics.print(self.table_string[i], str.x + cursor.x - 1, str.y + cursor.y - 1, str.rot, str.sx, str.sy, str.ox, str.oy) end,
            function() love.graphics.print(self.table_string[i], str.x + cursor.x - 1, str.y + cursor.y + 0, str.rot, str.sx, str.sy, str.ox, str.oy) end,
            function() love.graphics.print(self.table_string[i], str.x + cursor.x + 1, str.y + cursor.y - 1, str.rot, str.sx, str.sy, str.ox, str.oy) end,
            function()
                love.graphics.print(self.table_string[i], str.x + cursor.x - 1, str.y + cursor.y + 0, str.rot, str.sx, str.sy, str.ox, str.oy) 
                love.graphics.print(self.table_string[i], str.x + cursor.x + 1, str.y + cursor.y + 0, str.rot, str.sx, str.sy, str.ox, str.oy) 
                love.graphics.print(self.table_string[i], str.x + cursor.x - 0, str.y + cursor.y + 1, str.rot, str.sx, str.sy, str.ox, str.oy) 
                love.graphics.print(self.table_string[i], str.x + cursor.x - 0, str.y + cursor.y - 1, str.rot, str.sx, str.sy, str.ox, str.oy) 
                love.graphics.print(self.table_string[i], str.x + cursor.x + 1, str.y + cursor.y + 1, str.rot, str.sx, str.sy, str.ox, str.oy) 
                love.graphics.print(self.table_string[i], str.x + cursor.x + 1, str.y + cursor.y - 1, str.rot, str.sx, str.sy, str.ox, str.oy) 
                love.graphics.print(self.table_string[i], str.x + cursor.x - 1, str.y + cursor.y + 1, str.rot, str.sx, str.sy, str.ox, str.oy) 
                love.graphics.print(self.table_string[i], str.x + cursor.x - 1, str.y + cursor.y - 1, str.rot, str.sx, str.sy, str.ox, str.oy) 
               end,
        }
        dropshadowtable[self.draw_flags.dropshadow]()
    end

    if self.draw_flags.rainbow then 
        local phase = self.timer_animation * 10
        local center = 128
        local width = 80 -- max 127
        local frequency = math.pi*80/#self.table_string
        local red = math.sin(frequency*i+4+phase) * width + center;
        local green = math.sin(frequency*i+0+phase) * width + center;
        local blue = math.sin(frequency*i+2+phase) * width + center;
        self.current_color = {red/255, green/255, blue/255, 1}
    end

    if self.draw_flags.fakebold then 
      love.graphics.setColor(self.current_color)
      love.graphics.print(self.table_string[i], str.x + cursor.x + 1, str.y + cursor.y + 0, str.rot, str.sx, str.sy, str.ox, str.oy)
    end

    love.graphics.setColor(1,1,1,1)
end

--[[ Generate Class ]]-----------------------------------------------------------
function m.new(set_canvas, rendering) -- Todo, configuration at runtime.
    set_canvas = set_canvas or false    -- True or false, keep text small if using canvas
    rendering = rendering or "full" -- Left, Center, Right, Full
    local self = {}
    setmetatable(self, { __index = M })
    -- Storage
    self.table_string = {}
    self.command_modifer = ""
    self.current_character = 0
    -- Timers/Counters
    self.timer_print = 1
    self.timer_animation = 0
    self.timer_pause = 0
    self.sound_every_counter = 3
    -- Canvas
    self.canvas = love.graphics.newCanvas(base.width,base.height)
    self.use_canvas = set_canvas
    -- Text
    self.default_font = love.graphics.getFont()
    self.default_color = {0.05,0.05,0.05,1}
    self.current_color = self.default_color
    self.default_shadow_color = {0.5, 0.5, 0.5, 1}
    self.current_shadow_color = self.default_shadow_color
    self.default_print_speed = 0.04
    self.current_print_speed = self.default_print_speed
    self.rendering = rendering
    -- Text Sounds
    self.character_sound = true
    self.sound_every = 2
    self.sound_number = 1
    -- Commands 
    self.draw_flags = {
        italics = false,
        shake = false, 
        spin = false,
        raindrop = false,
        dropshadow = false,
        mirror = false,
        bounce = false,
        blink = false,
        rainbow = false,
        scale = false,
        shader = false,
        rotate = false,
        swing = false,
        fakebold = false,
    }
    dprint("Created with Canvas", self.use_canvas)
    return self
end

--[[ Return The Class ]]----------------------------------------------------------
return m