# SYSL-Text
**Please see the "main.lua" for samples, please review the library for all the possible tags.**

![Quick Demo of Examples](/screenshots/ex.gif?raw=true "Quick Demo of Examples")

# Update Notes
* New: You can now pass a table to modify character widths, in case your font does something like move the j or q in one pixel. (See example 10)
* New: You can now pass tables to the Audio/Font/Image/Etc commands if you don't keep resources global
* New ```[scroll]``` command, will scroll the text up by line-height or a set value. Works well with ```love.graphics.setScissor```.
* You have access to the basic calculated width, height and linecount for each textbox. Access is under the ```get``` table.
    - ```my_cool_textbox.get.width, my_cool_textbox.get.height, my_cool_textbox.get.lines ```
    - If you are using autowrap, the width calculation is more accurate.
* Text animation commands now allow you to change the speed, or even reverse it.
* It is no longer required to wrap UTF8 characters. You can send them without the wrapping and the library will scan and wrap extended characters without any manual input. 

# Setup
## Adding the library to your project
```lua
-- Require the library in your project
Text = require(text.lua)
```
## Create your first textbox
```lua
-- Require the library in your project
my_cool_textbox = Text.new()
```
## Apply text to your textbox
```lua
-- Require the library in your project
my_cool_textbox:send("Oh, gee, I hope this print out one by one!")
```
## Let love2d know to draw your textbox
```lua
-- in love.draw()
-- my_cool_textbox:draw(x,y)
my_cool_textbox:draw(0,0)
```
## Let love2d know to update your textbox
```lua
-- in love.update(dt)
my_cool_textbox:update(dt)
```

# Tags
SYSL-Text supports tags in ```[these brackets]``` and will use them to apply effects to your rendered text. SYSL-Text also supports defining default styles per textbox. Please take a look at the examples below. **Please note that effects and style are only examples, the library does not provide backgrounds or textboxes.**

## Tags with Screenshot Examples
![Example 1](/screenshots/01.gif?raw=true "Example of Library")
```lua
example2box = Text.new("left", 
{ 
    color = {1,1,1,1},
    shadow_color = {0.5,0.5,1,0.4},
    font = Fonts.golden_apple,
    character_sound = true,
    adjust_line_height = -3
})
example2box:send("• Do you like eggs?[newline]• I think they are [pad=6]eggzelent![audio=sfx=laugh]", 100, false)
```
![Example 2](/screenshots/02.gif?raw=true "Example of Library")
```lua
example3box = Text.new("left", 
{ 
    color = {1,1,1,1}, 
    shadow_color = {0.5,0.5,1,0.4}, 
    font = Fonts.golden_apple, 
    character_sound = false, 
    print_speed = 0.02,
    adjust_line_height = -3
    })
example3box:send("I am a very cute [color=#00ff00]green frog[/color]. Would you like to eat dinner with me? It's [rainbow][bounce]fresh[/bounce] [u]fly[/u] [shake]soup[/shake]![/rainbow]", 316, false)
```
![Example 3](/screenshots/3.png?raw=true "Example of Library")
```lua
example4box = Text.new("left", 
{ 
    color = {0,0,0,0.95}, 
    shadow_color = {0.5,0.5,1,0.4}, 
    font = Fonts.earth_illusion,
    adjust_line_height = -2
    })
example4box:send("[dropshadow=2][b]Old Man:[/b][newline]Hello young man. How are you?", 74, true)
```
![Example 4](/screenshots/4.png?raw=true "Example of Library")
```lua
example6box = Text.new("left", 
{ 
    color = {0.9,0.9,0.9,0.95}, 
    shadow_color = {0.5,0.5,1,0.4}, 
    font = Fonts.comic_neue, character_sound = true, 
    sound_every = 5, 
    sound_number = 2
    })
example6box:send("Oh wow, you found the [bounce][rainbow]high-res[/rainbow][/bounce] text! [icon=1][icon=2][icon=3][icon=4] [icon=5][icon=6][icon=7][icon=8] [icon=9][icon=10][icon=11][icon=12][/]", 320*4-16, true)
```
![Example 5](/screenshots/5.gif?raw=true "Example of Library")
```lua
example7box = Text.new("left", 
{ 
    color = {0.9,0.9,0.9,0.95}, 
    shadow_color = {0.5,0.5,1,0.4}, 
    font = Fonts.comic_neue_big, 
    character_sound = true, 
    sound_every = 3, 
    sound_number = 3
    })
example7box:send("[warble=-5][textspeed=0.02][image=witch][pad=32]There's something I have to say,[pause=0.7] [warble=5]this witch will save the day!", 320*4-16, false)
```
![Example 6](/screenshots/6.gif?raw=true "Example of Library")
```lua
example8box = Text.new("left", 
{ 
    color = {0.9,0.9,0.9,0.95}, 
    shadow_color = {0.5,0.5,1,0.4}, 
    font = Fonts.comic_neue_small, 
    character_sound = true, 
    print_speed = 0.04, 
    sound_every = 2, 
    sound_number = 4
    })
example8box:send("[function=example.bop=true]Did you hear about the [color=#FF0000]bad puns?[/color][pause=0.5] You did?![pause=0.5] That's [color=#FFFF00]great[/color]![pause=0.8]  [shake]Now I don't have to tell you about them![/shake][pause=1][function=example.bop=false][audio=sfx=laugh]", 320-80, false)
```
![Example 7](/screenshots/7.gif?raw=true "Example of Library")
```lua
example5box = Text.new("left", 
{ 
    color = {0.9,0.9,0.9,0.95}, 
    shadow_color = {0.5,0.5,1,0.4}, 
    font = Fonts.earth_illusion, 
    character_sound = true, 
    sound_every = 5, 
    sound_number = 2,
    adjust_line_height = -2,
    })
example5box:send("[dropshadow=3][function=example.ex5_textboxsize=64][textspeed=0.02]With the Power of Queens, they challenged the Snakes. Garry's mighty waves peeled apart their diamond scales. The Wizards woke[waitforinput][audio=sfx=ui] [function=example.ex5_textboxsize=example.ex5_textboxsize+16]mighty windstorms. Niza brought the deadly wine[waitforinput][audio=sfx=ui] [function=example.ex5_textboxsize=example.ex5_textboxsize+16]and cheese. [audio=sfx=ui]", 320-16, false)

```
![Example 8](/screenshots/8.gif?raw=true "Example of Library")
```lua
example9box = Text.new("left", 
{ 
    color = {0.9,0.9,0.9,0.95}, 
    shadow_color = {0.5,0.5,1,0.4}, 
    font = Fonts.comic_neue_small, 
    character_sound = true, 
    print_speed = 0.04, 
    sound_every = 2, 
    sound_number = 4
    })
example9box:send("Hello! Welcome to the world of Pocket Creatures![waitforinput][scroll][newline]My name is Professor Tree![newline][waitforinput][scroll][scroll]And you are?", 150, false)


```
# Default Textbox Settings 
```lua 
local default_settings = {
    autotags = "[tab]", -- This string is added at the start of every textbox, can include tags.
    font = font.default, -- Default font for the textbox, love font object.
    color = {1,1,1,1}, -- Default text color.
    shadow_color = {1,1,1,1}, -- Default Drop Shadow Color.
    print_speed = 0.2, -- How fast text prints.
    adjust_line_height = 0, -- Adjust the default line spacing.
    default_strikethrough_position = 0, -- Adjust the position of the strikethough line.
    default_underline_position = 0, -- Adjust the position of the underline line.
    character_sound = false, -- Use a voice when printing characters? True or false.
    sound_number = 0, -- What voice to use when printing characters.
    sound_every = 2, -- How many characters to wait before making another noise when printing text.
    default_warble = 0 -- How much to adjust the voice when printing each character. 
}
-- You can set some defaults for each textbox object to make things easier.
textbox = Text.new("left", default_settings)
```
# Textbox Information 
## Width, Height, Lines
You can get the width, height and the number of lines after sending text to a textbox.
```lua 
my_cool_textbox = Text.new()

my_cool_textbox:send("Oh, gee, I hope this print out one by one!")
local textbox_x = 0
local textbox_y = 0
local textbox_w = my_cool_textbox.get.width
local textbox_h = my_cool_textbox.get.height
local textbox_l = my_cool_textbox.get.lines
-- in love.draw()
love.graphics.rectangle("fill", textbox_x, textbox_y, textbox_w, textbox_h)
my_cool_textbox:draw(textbox_x, textbox_y)
```
# is_finished()
Returns ```true``` if the textbox is done printing, or ```false``` if the textbox is still printing. 

It will also return as ```true``` if ```[waitforinput]``` is in the text string.
```lua 
are_you_done = my_cool_textbox:is_finished()
```

# continue()
Continue will continue printing after ```[waitforinput]``` pauses it.

```lua 
-- You only need to send this once.
my_cool_textbox:continue()
```

# Tag Notes 
Some tags will not work until you let the library know something about your game.

# 1.9 Update - Tags
You can now pass a table instead of a string, this will allow you to use a table of assets without using global assets.

## Audio
```lua
--Text.configure.audio_table(table_string)
Text.configure.audio_table("Audio")
```
This configuration item will pass along the Lua table you are using to store audio sources. It currently can search down one level from that base table.
```lua
Enables "[audio]": Starts playing an audio source.
Used like: "[audio=guy-laughing]" or "[audio=music=level1]"

Enables "[/audio]": Stops playing an audio source.
Used like: "[/audio=guy-laughing]" or "[/audio=music=level1]"
```

## Audio-Sound per character
```lua
--Text.configure.add_text_sound(sound, volume) 
Text.configure.add_text_sound(Audio.text.default, 0.2) 
```
This will allow you to add voices so textboxes will jabber at you as they print characters. Note that the following commands will not work until you set up this configuration.
```lua
Enables: 
"[voice=#]": Set the speaking voice, 0 will turn it off.
"[warble=#]": Set the pitch varience, +/- on the voice.
"[/warble]": Stops the pitch varience.
"[soundevery=#]": How often does a sound play per character.
"[/soundevery]": Reset the sound per character.

Used like: "[voice=2][warble=3][soundevery=1]I'm talking really fast and making a lot of noise![voice=0][/warble][/soundevery]"
```

## Fonts
```lua
--Text.configure.font_table(table_string)
Text.configure.font_table("Font")
```
This configuration item will pass along the Lua table you are using to store your Font sources.
```lua
Enables "[font=Font.name]": Set the font.
Used like: "[font=Font.ComicSansMs]" or "[font=Font.default]"

Enables "[/font]": Set the font back to the textbox default.
Used like: "[/font]"
```
## Images
```lua
--Text.configure.image_table(table_string)
Text.configure.image_table("img")
```
This configuration item will pass along the Lua table you are using to store image sources. It currently can search down one level from that base table.
```lua
Enables "[image=name]": Draw an image inline with the text.
Used like: "[image=skull]" or "[image=ui=skull]
```
## Icons
```lua
--Text.configure.icon_table(table_string)
Text.configure.icon_table("Icon")
```
This configuration item will pass along the Lua table you are using to hold an icon drawing library. Note that this function assumes your library has a .draw() and .count() available. .draw() would work similar to how love.graphics.draw() works, with the source being replaced by a number. .count() would just return the number of available icons. If you would prefer to just use images, you can leave this configuration out and use the "[image]" tag.
```lua
Enables "[icon=#]": Draw an icon inline with the text.
Used like: "[icon=1]
```

## Palettes
```lua
--Text.configure.palette_table(table_string)
Text.configure.palette_table("Palettes")
```
This configuration item will pass along the Lua table you are using to hold an indexed list of palettes. You can then use this prebuilt index instead of "[color=#hexval]".
```lua
Enables "[color=#]": Changed the color of the text based on a palette list.
Used like: "[color=1]
```

## Shader Effects
```lua
--Text.configure.shader_table(table_string)
Text.configure.shader_table("Shaders")
```
This configuration item will pass along the Lua table you are using to hold shader functions you have created. These shader functions can be then applied directly to the text.
```lua
Enables "[shader=name]": Apply effects on text from a shader.
Used like: "[shader=blur]
```

## Scripting Commands
```lua
--Text.configure.function_command_enable(enable_bool)
Text.configure.function_command_enable(enable_bool)
```
This nightmare will allow you to write direct lua code into a string to execute. It's off by default. Please be careful when using. **Do not use unless you sandbox your text.**

# Standard Tags
## Not Animated
### end
```lua 
"[end]" -- System tag, added to the end of every string.
```
### waitforinput
```lua 
"[waitforinput]" -- Pauses printing characters until the
-- Text:continue() command is sent from somewhere in your code.
```
### newline
```lua 
"[newline]" -- Start printing on a new line, added automatically when autowrap is on.
```
### cursorsave
```lua 
"[cursorsave]" -- Save the current location of where we are typing to in the textbox.
```
### cursorload
```lua 
"[cursorload]" -- Restore the current location of where we are typing to in the textbox from when we last saved with [cursorsave].
```
### cursorx
```lua 
"[cursorx=number]" -- Set the cursor position as Textbox X position + x
```
### cursory
```lua 
"[cursory=number]" -- Set the cursor position as Textbox Y position + y
```
### tab
```lua 
"[tab]" -- Pad 4 spaces. Same as "    ".
```
### pad
```lua 
"[pad=number]" -- Pad this many pixels.
```
### lineheight
```lua 
"[lineheight=number]" -- Set the height for each line to this many pixels.
```
### skip
```lua 
"[skip]" -- Skip rendering the remaining characters character by character, draw the full text.
```
### pause
```lua 
"[pause]" -- Wait this many seconds (can use 0. for less than one second). Does not do anything if textbox is set to show everything. May interact badly with skip.
```
### backspace
```lua 
"[backspace=number]" -- Erase this many printed characters and start printing from that point. Very fragile, do not backspace over commands.
```
### textspeed
```lua 
"[textspeed=number]" -- Change how fast text is printed, wait this long in seconds before printing the next character. 0.2 is the default.
```
### /textspeed
```lua 
"[/textspeed]" -- Reset textspeed to the default
```
### color
```lua 
"[color=#BEEEEF]" -- Set color to the hex color.
```
### /color
```lua 
"[/color]" -- Reset to the default color.
```
### shadowcolor
```lua 
"[shadowcolor=#BEEEEF]" -- Set shadow color to the hex color.
```
### /shadowcolor
```lua 
"[/shadowcolor]" -- Reset to the default shadow color.
```
### dropshadow
![Example 8](/screenshots/dropshadow.png?raw=true "Example of Dropshadow")
```lua 
"[dropshadow=number]" -- Draw a dropshadow behind the text
-- 1 - Lower Left
-- 2 - Below
-- 3 - Lower Right
-- 4 - Left 
-- 5 - Thin Outline 
-- 6 - Right 
-- 7 - Upper Left 
-- 8 - Above 
-- 9 - Upper Right 
-- 10 - Thick Outline
```
### /dropshadow
```lua 
"[/dropshadow]" -- Turn off dropshadow.
```
### scale
```lua 
"[scale=number]" -- Scale the text.
```
### /scale
```lua 
"[/scale]" -- Reset the scale.
```
### rotate
![Example 9](/screenshots/rotate.png?raw=true "Example of Rotate")
```lua 
"[rotate=number]" -- Rotate the text characters.
```
### /rotate
```lua 
"[/rotate]" -- Reset the rotation.
```
### b, i, u, s
![Example 11](/screenshots/bius.png?raw=true "Example of bius")
```lua 
"[b]BOLD[/b]" -- Fake Bold.
"[i]ITALICS[/i]" -- Fake Italics.
"[u]UNDERLINE[/u]" -- Underline.
"[s]STRIKETHROUGH[/s]" -- Strikethrough.
-- Note, you can adjust the position of the line of underline and strikethough by doing [u=number]/[s=number] positive or negative. 
-- Some fonts do not report height as nice as it could. 
-- You can also set the default for the new textbox so you do not have to do this for each underline and strikethrough.
```
### mirror
![Example 10](/screenshots/mirror.png?raw=true "Example of Mirror")
```lua 
"[mirror=number]" -- Print text reversed.
```
### /mirror
```lua 
"[/mirror]" -- Stop the reverse.
```
## Animated Tags
Note, all numbers are optional. You can use the ```[tag]``` without them, it will use the default speed.

![Example 10](/screenshots/effects.gif?raw=true "Example of Rotate")
### shake 
```lua 
"[shake=number]Shake[/shake]"
```
### spin 
```lua 
"[spin=number]spin[/spin]"
```
### swing 
```lua 
"[swing=number]swing[/swing]"
```
### raindrop 
```lua 
"[raindrop=number]raindrop[/raindrop]"
```
### bounce 
```lua 
"[bounce=number]bounce[/bounce]"
```
### blink 
```lua 
"[blink=number]blink[/blink]"
```
### rainbow 
```lua 
"[rainbow=number(speed)=number(brightness of color)]rainbow[/rainbow]"
```
### scroll
```lua 
"[scroll] or [scroll=-int]" -- Scrolls the text in the textbox.
```

