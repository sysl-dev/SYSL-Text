*Please see the example love and main.lua for how effects work.*

![Examples](/screenshots/ex.gif?raw=true "Examples")

# Notes
## Requiring the file
```lua
Text = require(text.lua)
```
## Configuring the library
The library requires some configuration to work with your system. You could also remove the tags that use this configuration.
```lua
local font_table = "System.font.name"
local shader_table = "System.shader"
local palette_table = "System.palette.number"
local image_table = "texture"
--local icon_table = "Gx.icon"
local audio_table = "Audio"
```

### font_table
The font_table looks for a table containing all the fonts you use in your game, or want to use for the textbox.  It assumes all font names are lowercase.
```lua
[font=earth_illusion] -- same as love.graphics.setFont(System.font.name.earth_illusion)
```

### shader_table
The shader_table looks for a table containing all the shaders you use in your game, or want to use for text effects. It assumes all shader names are lowercase.
```lua 
[shader=blur] -- same as love.graphics.setShader(System.shader.blur)
```

### palette_table
The palette_table looks for a table containing colors indexed by number. Example:
```lua
System = {}
System.palette = {}
System.palette.number = {
{1,0,0,1}, -- Red
{0,1,0,1}, -- Green
{0,0,1,1}, -- Blue
}
[color=1] -- set color red.
```

### image_table
The image_table looks for a table containing all the images you use in your game, or want to use for the textbox.  It assumes all image names are lowercase.
```lua
[image=system=cursor] -- same as love.graphics.draw(texture.system.cursor)
```
### audio_table
The image_table looks for a table containing all the images you use in your game, or want to use for the textbox.  It assumes all image names are lowercase.
```lua
[Audio=system=clock] -- same as Audio.system.clock:play()
```

## I don't want to think, I just want it to work
```lua 
-- Dump this at the top of your main.lua
-- Audio Examples
Audio = {
	music = {
	--clock = love.audio.newSource( 'assets/audio/text/default.ogg', "static" ), -- Change to your audio
	},
	sound = {},
}
-- Audio.music.clock:setLooping(true)-- Change to your audio
-- Image examples 
texture = {
folder1 = {

},
folder2 = {

},
backgrounds = {

},
system = {
--cursor = love.graphics.newImage("assets/texture/system/icon.png") -- Change to your images
}
}

-- System to hold misc required objects
System = {
	font = {
		name = {},
	},
	shader = {
	x_gradient = love.graphics.newShader[[
  extern number r1 = 0;
  extern number g1 = 0;
  extern number b1 = 1;
  extern number r2 = 1;
  extern number g2 = 0;
  extern number b2 = 0;
  vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
  {
    number factor = pixel_coords.x/320;
    vec4 col = Texel(texture, texture_coords);
    col.r = r1 - r1 * factor + r2 * factor;
    col.g = g1 - g1 * factor + g2 * factor;
    col.b = b1 - b1 *  factor + b2 * factor;
    return col;
  }
]]},
	palette = {
		number = {
		{0.95,0.95,0.95,1},
		{1,0,0,1},
		{0,1,0,1},
		{0,0,1,1},
		},
	},
}
```

## Creating a text object
```lua
my_cool_textbox = Text.new("left", "")
-- Text.new(text rendering mode, text added to the start of all strings)
-- Text Rendering Modes: left, right, center, full
-- Text added to the start can include tags
```

## add to love.draw()
```lua
my_cool_textbox:draw(0,0)
-- my_cool_textbox(x, y)
```

## add to love.update(dt)
```lua
my_cool_textbox:update(dt)
-- my_cool_textbox(x, y)
```

## Start printing text 
```lua
-- Send via command/button/whatever once
my_cool_textbox:send("This is a string [color=#ff0000]With color!", 60, true)
--my_cool_textbox:send("string", autowrap cutoff in pixels, nil means no autowrap, Show all at once: True/False)
```