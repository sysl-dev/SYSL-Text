--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
-- Extra Libraries used for examples
--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
-- SLog Screen Scaling Library
-- Used for pixel art examples, works fine without it.
Screen = require("library.slog-pixel"); 
Screen.load(4)

-- SLog Frame Library
-- Used for pixel art examples, works fine without it.
Frame = require("library.slog-frame"); 

-- SLog Icon Library
-- Used for icon drawing, works fine without it.
Icon = require("library.slog-icon");


--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
-- The real library
--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
-- SLog Text Library
Text = require("library.slog-text")

--[[------------------------------------------------------------------- ----------------------------------------------------------------------------------------------------------]]--
-- Config - Advanced Scripting
--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
-- Enable Advanced Scripting with the [function=lua code] command.
-- Off by default.
Text.configure.function_command_enable(true)

-- Create fonts for testing 
Fonts = {
default = love.graphics.newFont(16),
earth_illusion = love.graphics.newFont("font/earth_illusion.fnt", "font/earth_illusion.png"),
golden_apple = love.graphics.newFont("font/golden_apple.fnt", "font/golden_apple.png"),
comic_neue = love.graphics.newFont("font/comic_neue_bold_19.ttf",16),
comic_neue_small = love.graphics.newFont("font/comic_neue_13.ttf",11, "mono" ),
comic_neue_big = love.graphics.newFont("font/comic_neue_bold_19.ttf",32),
shinonome_12 = love.graphics.newFont("font/shinonome_12.ttf", 12),
shinonome_14 = love.graphics.newFont("font/shinonome_14.ttf", 14),
shinonome_16 = love.graphics.newFont("font/shinonome_16.ttf", 16),
monogram_extended_custom = love.graphics.newFont("font/monogram_extended_custom.ttf", 32),
} 
-- Set the default font
love.graphics.setFont(Fonts.default)

print("Kernign Test, custom, ij", Fonts.monogram_extended_custom:getKerning("i", "j"))
--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
-- Config - font_table
--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
-- Now that we set our fonts, let's pass it to the library.
-- Note, we pass it as a string, it will automaticly convert to a table in the library.
-- The library will work without setting a font_table, but this allows us to use the [font] command.
Text.configure.font_table("Fonts")

--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
-- Load Images for testing 
images = {} 
images.bg = love.graphics.newImage("images/bg.png")
images.tango = love.graphics.newImage("images/tangoicons.png")
images.witch = love.graphics.newImage("images/pixabaywitch.png")
images.neue = love.graphics.newImage("images/pixabayneue.png")

--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
-- Set up frames for examples
images.frame = {}
images.frame.default_8 = love.graphics.newImage("images/frame/default_8.png")
images.frame.eb_8 = love.graphics.newImage("images/frame/eb_8.png")
images.frame.m3_8 = love.graphics.newImage("images/frame/m3_8.png")
images.frame.cart_8 = love.graphics.newImage("images/frame/cart_8.png")
images.frame.bubble_8 = love.graphics.newImage("images/frame/bubble_8.png")
images.frame.ff_8 = love.graphics.newImage("images/frame/ff_8.png")
images.frame.blk_8 = love.graphics.newImage("images/frame/blk_8.png")
images.frame.bk_32 = love.graphics.newImage("images/frame/bk_24.png")
images.frame.utp_8 = love.graphics.newImage("images/frame/utp_8.png")

--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
-- Config - image_table
--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
-- Now that we set our images, let's pass it to the library.
-- Note, we pass it as a string, it will automaticly convert to a table in the library.
-- The library will work without it, but without the ability to draw images directly with the [image=name] command
Text.configure.image_table("images")


-- Set up icons
Icon.configure(16, images.tango)
--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
-- Config - icon_table
--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
-- Now that we set our icons, let's pass it to the library.
-- Note, we pass it as a string, it will automaticly convert to a table in the library.
-- The library will work without it, but without the ability to draw images directly with the [icon=name] command
-- Note, the library assumes the table has a count() to return the number of functions, and a draw() that works like love.graphics.draw()
-- with a number replacing the source image.
Text.configure.icon_table("Icon")


--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
-- SLog Frame Library has to load after setting up all the frames, library used to draw the background boxes for text.
Frame.load()

--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
-- Load Audio for testing 
Audio = {}
Audio.text = {}
Audio.text.default = love.audio.newSource("audio/text/default.ogg", "static")
Audio.text.typing = love.audio.newSource("audio/text/typing.ogg", "static")
Audio.text.cackle = love.audio.newSource("audio/text/cackle.ogg", "static")
Audio.text.neue = love.audio.newSource("audio/text/neue.ogg", "static")
Audio.sfx = {}
Audio.sfx.laugh = love.audio.newSource("audio/sfx/voice_fun_man_character_deep_laugh_11.ogg", "static")
Audio.sfx.laugh:setVolume(0.3)
Audio.sfx.ui = love.audio.newSource("audio/sfx/Selection_Ukelele chord 04_mod.ogg", "static")
Audio.sfx.ui:setVolume(0.3)

--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
-- Config - audio_table
--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
-- Now that we set our audio, let's pass it to the library.
-- Note, we pass it as a string, it will automaticly convert to a table in the library.
-- The library will work without it, but without the ability to draw images directly with the [audio=table=source] command
Text.configure.audio_table("Audio")

--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
-- Config - Text-Tones
--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
-- We can have text-boxes use tones as we talk by letting the library know short samples exist.
-- If you don't have any samples added voice commands will not work.
-- Audio Source, Volume
Text.configure.add_text_sound(Audio.text.default, 0.2) 
Text.configure.add_text_sound(Audio.text.typing, 0.2) 
Text.configure.add_text_sound(Audio.text.cackle, 0.2) 
Text.configure.add_text_sound(Audio.text.neue, 0.2) 

--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
-- Global example code that is used for scripting reasons, could be local as well, but it's a lazy way to allow [function=lua code] to access it.
-- There are nicer ways to do this, but it works as an example.
--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
example = {
display_mode = 11,
maxmodes = 11,
long_text_block = require('longtext'),
ex5_textboxsize = 64,
bop = true,
boptimer = 1,
}

--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
-- Setting up textboxes
--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
function love.load() 
-- Set up examples
-- Example 1 // Default Font // Examples 
example1box = Text.new("left", { color = {1,1,1,1}, shadow_color = {0.5,0.5,1,0.4}, keep_space_on_line_break=true, default_underline_position = -2, default_strikethrough_position = 1})
example1box:send(example.long_text_block, 320*4, true)
-- Example 2 // Golden Apple Font // Earthbound Style Box
example2box = Text.new("left", { color = {1,1,1,1}, shadow_color = {0.5,0.5,1,0.4}, font = Fonts.golden_apple, keep_space_on_line_break=true, character_sound = true, adjust_line_height = -3})
example2box:send("• Do you like eggs?[newline]• I think they are [pad=6]eggzelent![audio=sfx=laugh]", 100, false)
-- Example 3 // Golden Apple Font // Mother 3 Style Bottom 
example3box = Text.new("left", { color = {1,1,1,1}, shadow_color = {0.5,0.5,1,0.4}, font = Fonts.golden_apple, keep_space_on_line_break=true, character_sound = false, print_speed = 0.02, adjust_line_height = -3})
example3box:send("I am a very cute [color=#00ff00]green frog[/color]. Would you like to eat dinner with me? It's [rainbow][bounce]fresh[/bounce] [u]fly[/u] [shake]soup[/shake]![/rainbow]", 316, false)
--Example 4 // Earth Illusion // Bubble Style Box
example4box = Text.new("left", { color = {0,0,0,0.95}, shadow_color = {0.5,0.5,1,0.4}, font = Fonts.earth_illusion, keep_space_on_line_break=true, adjust_line_height = -2})
example4box:send("[dropshadow=2][b]Old Man:[/b][newline]Hello young man. How are you?", 74, true)
--Example 5 // Earth Illusion // Final Fantasy Style
example5box = Text.new("left", { color = {0.9,0.9,0.9,0.95}, shadow_color = {0.5,0.5,1,0.4}, font = Fonts.earth_illusion, keep_space_on_line_break=true, character_sound = true, sound_every = 5, sound_number = 2, adjust_line_height = -2})
example5box:send("[dropshadow=3][function=example.ex5_textboxsize=64][textspeed=0.02]With the Power of Queens, they challenged the Snakes. Garry's mighty waves peeled apart their diamond scales. The Wízärds woke[waitforinput][audio=sfx=ui] [function=example.ex5_textboxsize=example.ex5_textboxsize+16]mighty windstorms. Niza brought the deadly wine[waitforinput][audio=sfx=ui] [function=example.ex5_textboxsize=example.ex5_textboxsize+16]and cheese. [audio=sfx=ui]", 320-16, false)
--Example 6 // Comic Neue / Center Box
example6box = Text.new("left", { color = {0.9,0.9,0.9,0.95}, shadow_color = {0.5,0.5,1,0.4}, font = Fonts.comic_neue, keep_space_on_line_break=true, character_sound = true, sound_every = 5, sound_number = 2})
example6box:send("Oh wow, you found the [bounce][rainbow]high-res[/rainbow][/bounce] text! [icon=1][icon=2][icon=3][icon=4] [icon=5][icon=6][icon=7][icon=8] [icon=9][icon=10][icon=11][icon=12][/]", 320*4-16, true)
--Example 7 // Comic Neue Big / BoxBK Style
example7box = Text.new("left", { color = {0.9,0.9,0.9,0.95}, shadow_color = {0.5,0.5,1,0.4}, font = Fonts.comic_neue_big, keep_space_on_line_break=true, character_sound = true, sound_every = 3, sound_number = 3})
example7box:send("[warble=-5][textspeed=0.02][image=witch][pad=32]There's something I have to say,[pause=0.7] [warble=5]this witch will save the day!", 320*4-16, false)
--Example 8 // Comic Neue / Undertale Style
example8box = Text.new("left", { color = {0.9,0.9,0.9,0.95}, shadow_color = {0.5,0.5,1,0.4}, font = Fonts.comic_neue_small, character_sound = true, print_speed = 0.04, sound_every = 2, sound_number = 4})
example8box:send("[function=example.bop=true]Did you hear about the [color=#FF0000]bad puns?[/color][pause=0.5] You did?![pause=0.5] That's [color=#FFFF00]great[/color][pause=0.8]!  [shake]Now I don't have to tell you about them![/shake][pause=1][function=example.bop=false][audio=sfx=laugh]", 320-80, false)
--Example 9 // Comic Neue / Pocket Monsters Scroll Style
example9box = Text.new("left", { color = {0.9,0.9,0.9,0.95}, shadow_color = {0.5,0.5,1,0.4}, font = Fonts.comic_neue_small, character_sound = true, print_speed = 0.04, sound_every = 2, sound_number = 4})
example9box:send("Hello! Welcome to the world of Pocket Creatures![waitforinput][scroll][newline]My name is Professor Tree![newline][waitforinput][scroll][scroll]And you are?", 150, false)
example10box = Text.new("left", { color = {0.9,0.9,0.9,0.95}, shadow_color = {0.5,0.5,1,0.4}, font = Fonts.monogram_extended_custom, character_sound = false, keep_space_on_line_break=true, modify_character_width_table = {["j"] = -1, }})
local sp_test_string = "[shake][[]color=red]Wow it's characters[[]/color][/shake]"
example10box:send("Special Sheep Polution Test, Bahhh:\n\nij ij ij ij ij ij ij ij ij ij ij ij ij ij ij [color=#ff0000]ij ij ij ij ij[/color] ij ij ij ij ij ij ij ij ij ij ij ij ij ij ij ij ij ij ij ij ij ij ij ijfart [rainbow]\n\na a a a a a a[/rainbow] a a a a a a a a a a a a a a a a a a [function=print('tes1t')]\n[function=print('te2st')] \nI've dropped so many letters oh no!\nOjan Pjan Ajan Testj Characterj oj mh wj ikj applej orangej colaj Martijn..\n" .. sp_test_string, 540, true)
example11box = Text.new("left", { color = {0.9,0.9,0.9,0.95}, shadow_color = {0.5,0.5,1,0.4}, font = Fonts.monogram_extended_custom, character_sound = false, keep_space_on_line_break=true, modify_character_width_table = {["j"] = -1, }}) 
example11box:send("Special Sheep Polution Test, Bahhh:\n\nij ij ij ij ij ij ij ij[function=print('test1')] ij ij ij ij ij ij ij [color=#ff0000]ij ij ij ij ij[/color] ij ij ij [function=print('test2')]ij ij ij ij ij ij ij ij ij ij ij ij ij ij ij ij ij ij ij ij ijfart[backspace=4] [rainbow]\n\na a a a a a a[/rainbow] a a a a a a a a a a a a a a a a a a [function=print('tes1t')]\n [function=print('te2st')] \nThis is for  Function is executed twice when placed exactly after where the text is wrapped #10 " , 540, false)

end 

--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
-- Drawing depending on example
--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
function love.draw()
local example_text = "" -- I'm doing it this way to keep the name with the examples, you would not normally do this.
-- Generic Example covering the tags
if example.display_mode == 1 then 
example_text = "Commands using the standard font in Love2D"
example1box:draw(0,0)
end

if example.display_mode == 2 then 
Screen.start()
example_text = "Earthbound Style Textbox -  R to Reset View"
love.graphics.draw(images.bg)
Frame.draw("eb", 200 - 16, 20, 120, 58)
example2box:draw(210 - 16, 22)
Screen.stop()
end

if example.display_mode == 3 then 
Screen.start()
example_text = "Mother3 Style Textbox -  R to Reset View"
love.graphics.draw(images.bg)
Frame.draw("cart", 0, 140-13, 80, 14)
love.graphics.setFont(Fonts.golden_apple)
love.graphics.print("Some Dude", 4, 140-17)
love.graphics.setFont(Fonts.default)
Frame.draw("m3", 0, 140, 320, 40)
example3box:draw(2, 138)
Screen.stop()
end

if example.display_mode == 4 then 
Screen.start()
example_text = "Speechbox Style Textbox"
love.graphics.draw(images.bg)
Frame.draw("bubble", 110, 36, 80, 80)
example4box:draw(115, 36)
Screen.stop()
end

if example.display_mode == 5 then 
Screen.start()
example_text = "Final Enixy Style Textbox -  R to Reset View - C to continue when prompted"
love.graphics.draw(images.bg)
Frame.draw("ff", 0, 0, 320, example.ex5_textboxsize)
example5box:draw(8, 0)
if example5box:is_finished() then
love.graphics.setColor(1,0,0,1)
love.graphics.rectangle("fill", 320/2-4, example.ex5_textboxsize - 5, 9, 10)
love.graphics.setColor(1,1,1,1)
local previousfont = love.graphics.getFont()
love.graphics.setFont(Fonts.golden_apple)
love.graphics.print("C", 320/2-4 + 2, example.ex5_textboxsize - 11)
love.graphics.setFont(previousfont)
end
Screen.stop()
end

if example.display_mode == 6 then 
Screen.start()
example_text = "Center Style Textbox"
love.graphics.draw(images.bg)
Screen.stop()
Frame.draw("blk", 0, 180*4/2-20*4/2, 320*4, 20*4)
example6box:draw(10,180*4/2 - 5*4 /2)
end

if example.display_mode == 7 then 
Screen.start()
example_text = "Banjo Kazooee Style Textbox - R to reset"
love.graphics.draw(images.bg)
Screen.stop()
Frame.draw("bk", 0, 180*4/1.1-20*4/2, 320*4, 20*4)
example7box:draw(60,180*4/1.11 - 5*4 /2)
end

if example.display_mode == 8 then 
Screen.start()
example_text = "Undertale Style Textbox"
love.graphics.draw(images.bg)

Frame.draw("utp", 10, 10, 300, 48)
local bop = 1
if example.bop then 
bop = 0.8 + (0.2 * math.abs(math.sin(example.boptimer)))
end
love.graphics.draw(images.neue, 14, 15, 0, 1, bop)
example8box:draw(14 + 40, 15 )

Screen.stop()
end

if example.display_mode == 9 then 
Screen.start()
example_text = "Catching Monsters Style Textbox / C to continue text"
love.graphics.draw(images.bg)

Frame.draw("utp", 320/2 - 150/2 - 4, 180 - 40, example9box.get.width + 8, 2 * 17)

love.graphics.setScissor( 320/2 - 150/2, 180 - 40 + 4, example9box.get.width, 2 * 17 )
example9box:draw(320/2 - 150/2, 180 - 40 + 4)
love.graphics.setScissor()

if example9box:is_finished() and math.floor(love.timer.getTime()*10) % 2 == 0 then
	love.graphics.setColor(1,0,0,1)
	love.graphics.print("-", 320/2 - 150/2 + example9box.get.width - 8, 180 - 20  )
	love.graphics.print("-", 320/2 - 150/2 + example9box.get.width - 8, 180 - 19  )
	love.graphics.print("-", 320/2 - 150/2 + example9box.get.width - 8, 180 - 18  )
	love.graphics.setColor(1,1,1,1)
end

Screen.stop()
end

if example.display_mode == 10 then 
  Screen.start()
  example_text = "BugFix Textbox"
  
  love.graphics.draw(images.bg)
  Screen.stop()
  love.graphics.setColor(0,0,0,1)
  love.graphics.rectangle("fill",0,0,540, 540)
  love.graphics.setColor(1,1,1,1)
  example10box:draw(0,0)
  end



if example.display_mode == 11 then 
  Screen.start()
  example_text = "BugFix2 Textbox"
  
  love.graphics.draw(images.bg)
  Screen.stop()
  love.graphics.setColor(0,0,0,1)
  love.graphics.rectangle("fill",0,0,540, 540)
  love.graphics.setColor(1,1,1,1)
  example11box:draw(0,0)
  end

-- Draw Information Bar At the Bottom 
love.graphics.setColor(0.95,0.95,0.95,1)
love.graphics.rectangle("fill", 0, 180*4 - 25, 320*4, 40)
love.graphics.setColor(0.2,0.2,0.2,1)
love.graphics.setFont(Fonts.default)
love.graphics.print("[Space for Next Example] - " .. example_text, 2, 180*4 - 40 + 2 + 18)
--love.graphics.print("X: " .. Screen.mouse.x .. " Y: " .. Screen.mouse.y .. " FPS: " .. love.timer.getFPS(), 2, 180*4 - 40 )
love.graphics.setColor(1,1,1,1)
end

--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
-- Updating depending on example 
--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
function love.update(dt)
	Screen.update(dt)
	if example.display_mode == 1 then 
		example1box:update(dt)
	end	
	if example.display_mode == 2 then 
		example2box:update(dt)
	end
	if example.display_mode == 3 then 
		example3box:update(dt)
	end
	if example.display_mode == 4 then 
		example4box:update(dt)
	end
	if example.display_mode == 5 then 
		example5box:update(dt)
	end
	if example.display_mode == 6 then 
		example6box:update(dt)
	end
	if example.display_mode == 7 then 
		example7box:update(dt)
	end
	if example.display_mode == 8 then 
		example8box:update(dt)
		example.boptimer = example.boptimer + dt * 10
	end
	if example.display_mode == 9 then 
		example9box:update(dt)
	end
	if example.display_mode == 10 then 
		example10box:update(dt)
	end
	if example.display_mode == 11 then 
		example11box:update(dt)
	end
end

--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
-- Hacky mess per example
--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
function love.keypressed( key, scancode, isrepeat )
  if key == "f3" then print(table.concat(example11box.table_string)) end
  if key == "f2" then print(table.concat(example11box.table_string, "|")) end
	if key == "space" then example.display_mode = example.display_mode + 1 end
	if example.display_mode > example.maxmodes then example.display_mode = 1 end
	if example.display_mode == 1 then 
	example1box:send(example.long_text_block, 320*4, true)
		if key == "r" then 
		end		
	end	
	if example.display_mode == 2 then 
		if key == "r" then 
		example2box:send("[|•] Do you like eggs?[newline][|•] I think they are [pad=6]eggzelent!", 100, false)
		end		

	end
	if example.display_mode == 9 then 
		if key == "r" then 
			example9box:send("Hello! Welcome to the world of Pocket Creatures![waitforinput][scroll][newline]My name is Professor Tree![newline][waitforinput][scroll][scroll]And you are?", 150, false)
		end		
		if key == "c" then 
			example9box:continue()
		end
	end
	if example.display_mode == 3 then 
		if key == "r" then 
		example3box:send("I am a very cute [color=#00ff00]green frog[/color]. Would you like to eat dinner with me? It's [rainbow][bounce]fresh[/bounce] [u]fly[/u] [shake]soup[/shake]![/rainbow]", 316, false)
		end		
	end	
	if example.display_mode == 7 then 
		if key == "r" then 
		example7box:send("[warble=-5][textspeed=0.02][image=witch][pad=32]There's something I have to say,[pause=0.7] [warble=5]this witch will save the day!", 320*4-16, false)

		end		
	end
	if example.display_mode == 8 then 
		if key == "r" then 
		example8box:send("[function=example.bop=true]Did you hear about the [color=#FF0000]bad puns?[/color][pause=0.5] You did?![pause=0.5] That's [color=#FFFF00]great[/color]![pause=0.8] [shake]Now I don't have to tell you about them![/shake][pause=1][function=example.bop=false][audio=sfx=laugh]", 320-80, false)

		end		
	end
	if example.display_mode == 5 then 
		if key == "r" then 
example5box:send("[dropshadow=3][function=example.ex5_textboxsize=64][textspeed=0.02]With the Power of Queens, they challenged the Snakes. Garry's mighty waves peeled apart their diamond scales. The Wizards woke[waitforinput][audio=sfx=ui] [function=example.ex5_textboxsize=example.ex5_textboxsize+16]mighty windstorms. Niza brought the deadly wine[waitforinput][audio=sfx=ui] [function=example.ex5_textboxsize=example.ex5_textboxsize+16]and cheese. [audio=sfx=ui]", 320-16, false)
		end		
		if key == "c" then 
		example5box:continue()
		if example.ex5_textboxsize  > 64+15+15 and example5box:is_finished() then 
example5box:send("[dropshadow=3][function=example.ex5_textboxsize=64][textspeed=0.02]With the Power of Queens, they challenged the Snakes. Garry's mighty waves peeled apart their diamond scales. The Wizards woke[waitforinput][audio=sfx=ui] [function=example.ex5_textboxsize=example.ex5_textboxsize+16]mighty windstorms. Niza brought the deadly wine[waitforinput][audio=sfx=ui] [function=example.ex5_textboxsize=example.ex5_textboxsize+16]and cheese. [audio=sfx=ui]", 320-16, false)
		end
		end
	end
end