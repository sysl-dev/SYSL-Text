# SYSL-Text
**Please see the "main.lua" for samples, please review the library for all the possible tags.**

![Quick Demo of Examples](/screenshots/ex.gif?raw=true "Quick Demo of Examples")


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

# UTF8 Text Note 
UTF8 characters need to be wrapped in ```[|t][|a][|g][|s]``` to work. 
You could also write something to preprocess your text before sending it to SYSL-Text.

## Quick text wrapper in Notepad++ replace command
```
//Find: 
(.) 

//Replace 
[|$1] 
```



# Tags
SYSL-Text supports tags in ```[these brackets]``` and will use them to apply effects to your rendered text. SYSL-Text also supports defining default styles per textbox. Please take a look at the examples below.

## Tags with Screenshot Examples
![Example 1](/screenshots/1.gif?raw=true "Example of Library")
```lua
example2box = Text.new("left", { color = {1,1,1,1}, shadow_color = {0.5,0.5,1,0.4}, font = Fonts.golden_apple, character_sound = true})
example2box:send("[|•] Do you like eggs?[newline][|•] I think they are [pad=6]eggzelent![audio=sfx=laugh]", 100, false)
```
![Example 2](/screenshots/2.gif?raw=true "Example of Library")
```lua
example3box = Text.new("left", { color = {1,1,1,1}, shadow_color = {0.5,0.5,1,0.4}, font = Fonts.golden_apple, character_sound = false, print_speed = 0.02})
example3box:send("I am a very cute [color=#00ff00]green frog[/color]. Would you like to eat dinner with me? It's [rainbow][bounce]fresh[/bounce] [u]fly[/u] [shake]soup[/shake]![/rainbow]", 316, false)
```
![Example 3](/screenshots/3.png?raw=true "Example of Library")
```lua
example4box = Text.new("left", { color = {0,0,0,0.95}, shadow_color = {0.5,0.5,1,0.4}, font = Fonts.earth_illusion})
example4box:send("[dropshadow=2][b]Old Man:[/b][newline]Hello young man. How are you?", 74, true)
```
![Example 4](/screenshots/4.png?raw=true "Example of Library")
```lua
example6box = Text.new("left", { color = {0.9,0.9,0.9,0.95}, shadow_color = {0.5,0.5,1,0.4}, font = Fonts.comic_neue, character_sound = true, sound_every = 5, sound_number = 2})
example6box:send("Oh wow, you found the [bounce][rainbow]high-res[/rainbow][/bounce] text! [][icon=1][icon=2][icon=3][icon=4] [icon=5][icon=6][icon=7][icon=8] [icon=9][icon=10][icon=11][icon=12][/]", 320*4-16, true)
```
![Example 5](/screenshots/5.gif?raw=true "Example of Library")
```lua
example7box = Text.new("left", { color = {0.9,0.9,0.9,0.95}, shadow_color = {0.5,0.5,1,0.4}, font = Fonts.comic_neue_big, character_sound = true, sound_every = 3, sound_number = 3})
example7box:send("[warble=-5][textspeed=0.02][][image=witch][pad=32]There's something I have to say,[pause=0.7][] [warble=5]this witch will save the day!", 320*4-16, false)
```
![Example 6](/screenshots/6.gif?raw=true "Example of Library")
```lua
example8box = Text.new("left", { color = {0.9,0.9,0.9,0.95}, shadow_color = {0.5,0.5,1,0.4}, font = Fonts.comic_neue_small, character_sound = true, print_speed = 0.04, sound_every = 2, sound_number = 4})
example8box:send("[function=example.bop=true]Did you hear about the [color=#FF0000]bad puns?[/color][pause=0.5] You did?![pause=0.5] That's [color=#FFFF00]great[/color][pause=0.8]!  [shake]Now I don't have to tell you about them![/shake][pause=1][][function=example.bop=false][][audio=sfx=laugh]", 320-80, false)
```
![Example 7](/screenshots/7.gif?raw=true "Example of Library")
```lua
example5box = Text.new("left", { color = {0.9,0.9,0.9,0.95}, shadow_color = {0.5,0.5,1,0.4}, font = Fonts.earth_illusion, character_sound = true, sound_every = 5, sound_number = 2})
example5box:send("[dropshadow=3][function=example.ex5_textboxsize=64][textspeed=0.02]With the Power of Queens, they challenged the Snakes. Garry's mighty waves peeled apart their diamond scales. The Wizards woke[waitforinput][audio=sfx=ui] [function=example.ex5_textboxsize=example.ex5_textboxsize+16]mighty windstorms. Niza brought the deadly wine[waitforinput][audio=sfx=ui] [function=example.ex5_textboxsize=example.ex5_textboxsize+16]and cheese. [audio=sfx=ui]", 320-16, false)

```

# Tags Notes 
Some tags will not work until you let the library know something about your game. I will list them all below.

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
This nightmare will allow you to write direct lua code into a string to execute. It's off by default. Please be careful when using.