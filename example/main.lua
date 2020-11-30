-- Text Library
Text = require("library.slog.text")

-- SLog Screen Scaling Library
Screen = require("library.slog.pixel"); Screen.load(4)

-- Audio Examples
Audio = {
	music = {
	clock = love.audio.newSource( 'assets/audio/text/default.ogg', "static" ),
	},
	sound = {},
}
Audio.music.clock:setLooping(true)
-- Image examples 
texture = {
folder1 = {

},
folder2 = {

},
backgrounds = {

},
system = {
icon = love.graphics.newImage("assets/texture/system/icon.png")
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

Gx = {
	icon = {
		number = {
		"this would be icon 1",
		"this would be icon 2",
		"this would be icon 3",
		"(Really just use quads)",
		}
	}
}

-- Example Icon Drawing Function
function Gx.icon.draw(num, ...)
local icon_size = 16
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
 -- love.graphics.draw(game_icon_image, m.number[num], unpack(_modify))
 if num == 1 then 
	love.graphics.draw(texture.system.icon, unpack(_modify)) 
end
end

-- Load Fonts
local fontnames = love.filesystem.getDirectoryItems("assets/font/")
-- TTF File Format fontname_size (format ##, hack for bigger numbers if needed)
for i = 1, #fontnames do -- Step though each item on the list
	if string.match(fontnames[i], ".ttf") then
		local font_name = fontnames[i]:sub(1, #fontnames[i]-4) -- Get a clean name
		local font_size = tonumber(font_name:sub(#font_name-1, #font_name)) -- Get a clean number
		local font_format = "assets/font/" .. font_name .. ".ttf"
		System.font.name[font_name:sub(1, #font_name-3)] = love.graphics.newFont( font_format, font_size, "mono")
		System.font.name[font_name:sub(1, #font_name-3)]:setLineHeight(1.0)
		System.font.name[font_name:sub(1, #font_name-3)]:setFilter("nearest", "nearest", 1)
	end
end
-- Load Image Font
	  System.font.name["earth_illusion"] = love.graphics.newFont( "assets/font/" .. "earth_illusion.fnt", "assets/font/" .. "earth_illusion.png" )
	  System.font.name["earth_illusion"]:setLineHeight(1.0)
	  System.font.name["earth_illusion"]:setFilter("nearest", "nearest", 1)
	  System.font.name["golden_apple"] = love.graphics.newFont( "assets/font/" .. "golden_apple.fnt", "assets/font/" .. "golden_apple.png" )
	  System.font.name["golden_apple"]:setLineHeight(1.0)
	  System.font.name["golden_apple"]:setFilter("nearest", "nearest", 1)

-- Set Default Font 
love.graphics.setFont(System.font.name["golden_apple"])
-- Adjust Line Heights

local scene = {}
-- %% spellcheck-off
local next = 0
local mode = 1 
local mode_text = {
"Character Print Mode",
"Test Font Changes",
"Position Commands",
"Formatting Commands 1",
"Formatting Commands 2",
"Autowrap, left, center, right, full",
"Print Autowrap, left, center, right, full",
"Font Autowrap, left, center, right, full",
"Autowrap Issues",
"Backspace Command ",
"Unicode Text",
"Unicode Text Continued",
"More Commands Continued",
"More Commands Example",
"Voice Commands",
"Images",
"nil",
"nil",
"nil",
"nil",
"nil",
"nil",
"nil",
}

local test_string = [[
ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz
0123456789\^_`{|}~!"#$%&'()*+,-./:;<=>?@[|sp1][|sp2]
[|¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿]
[|ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö]
[|÷øùúûüýþÿıŒœˆ˚˜–—‘’‚“”„†‡•…‹›‼‽⁄⁴€™←↑→↓↖↗↘↙]
[|−∕⊕☀☁☂☃☄☉☕☹☺☼☽☾☿♀♁♂♃♄♅♆♇]
[|♈♉♊♋♌♍♎♏♐♑♒♓]
[|♔♕♖♗♘♙♚♛♜♝♞♟♠♡♢♣♤♥♦♧♩♪♫♬♭♮♯⚀⚁⚂⚃⚄⚅⚞⚟⚠]
[|⚡⚢⚣⚤⚥⚦⚧⚨⚩⚪⚫⛢⠁⠂⠃⠄⠅⠆⠇⠈⠉⠊⠋⠌⠍⠎⠏⠐⠑⠒⠓⠔⠕⠖⠗⠘⠙⠚⠛⠜⠝⠞⠟⠠⠡⠢⠣⠤⠥⠦⠧]
[|⠨⠩⠪⠫⠬⠭⠮⠯⠰⠱⠲⠳⠴⠵⠶⠷⠸⠹⠺⠻⠼⠽⠾⠿⭐「」『』【】〝〞〟｢｣ ] ]
 ]]


 local left_text = Text.new("left", "[auto-commands-can-be-put-here]")
 local right_text = Text.new("right") -- or left out 
 local center_text = Text.new("center") -- You could just put "text" too
 local full_text = Text.new("full")

function love.load()
  left_text:send(test_string, nil, true)

end


-- Run Every Frame
function love.draw()
  Screen.start()
  love.graphics.setColor(1,1,1,1)
  love.graphics.rectangle("fill", 0, 0, Screen.base_width(), Screen.base_height())
  love.graphics.setColor(0.05,0.05,0.05,1)
  love.graphics.rectangle("fill", 0, 0+160, Screen.base_width(), Screen.base_height())
  love.graphics.setColor(1,1,1,1)
  love.graphics.print("Test Mode - " .. mode_text[mode], 10, 158)
  love.graphics.print("[Space] →", 270, 158)
if mode > 0 and mode < 6 then 
  left_text:draw(1, 1)
elseif mode > 5 and mode < 11 then 
  love.graphics.setColor(0.9,0.9,0.9,1)
  love.graphics.rectangle("fill", 1, 1, 70, 158)
  love.graphics.rectangle("fill", 1 + 78*1, 1, 70, 158)
  love.graphics.rectangle("fill", 1 + 78*2, 1, 70, 158)
  love.graphics.rectangle("fill", 1 + 78*3, 1, 70, 158)
  love.graphics.setColor(1,1,1,1)
  left_text:draw(1, 1)
  right_text:draw(1 + 78*2, 1)
  center_text:draw(1 + 78, 1)
  full_text:draw(1 + 78 * 3, 1)
else 
  left_text:draw(1, 1)
end

  Screen.stop()
  --System.debug.info(5, 5)
end

-- Run Every Frame
function love.update(dt)
  next = next + 2 * dt
  left_text:update(dt)
  center_text:update(dt)
  right_text:update(dt)
  full_text:update(dt)
end

function love.keypressed(key, scancode, isrepeat)
  local max_mode = 16
if key == "space" then 
  mode = mode + 1 
  if mode > max_mode then mode = 1 end
end

-- Base Test String
if mode == 1 then 
  left_text:send(test_string, nil, true)
end

-- Font Test 1
if mode == 2 then 
local test_string = [[[font=comic_neue_bold]
[b]Testing Changing Fonts[/b][font=golden_apple]
[|Cloud-][shadowcolor=#BEEEEF][|topped and ][dropshadow=5][color=#C0FFEE]splendid[/color][/dropshadow][|, dominating all]
[|The little lesser hills which compass thee,][font=comic_neue]
[|Thou standest, bright with April’s buoyancy,][font=comic_neue]
[|Yet holding Winter in some shaded wall][font=golden_apple]
[|Of stern, steep rock; and startled by the call][font=earth_illusion]
[|Of Spring, thy trees flush with expectancy][/font]
[|And cast a cloud of crimson, silently][font=earth_illusion]
[/font]
]]
left_text:send(test_string, 318, true)
end

-- Font Test 2 
if mode == 3 then 
local test_string = [[
Position Commands[newline]newline - forces a linebreak
[b]cursorsave[/b][cursorsave][cursorx=180][cursory=0][b]cursorx=180 cursory=0[/b][cursorload] [b]cursorload[/b] - 
Saves the position in the text and can return there after using 
cursor(x/y) commands.
[tab][b]tab[/b] is a tab![pad=69][b]pad=69[/b] pads that number of pixels
[lineheight=-8]Adjusting [b]lineheight=-8[/b] lets us
               smash things together[lineheight=0] 
Please note that all position commands with the exception of newline 
are not friendly with auto-textbox wrapping
]]
left_text:send(test_string, nil, true)
end

-- Font Test 3 
if mode == 4 then 
local test_string = [[Formatting Commands
[b]b[/b] - [b]Fake Bold[/b]     [b]u[/b] - [u]Underline[/u]
[b]i[/b] - [i]Fake Italics[/i]     [b]s[/b] - [s]Strikethrough[/s]
[b]dropshadow=[/b]# - Style [dropshadow=0]00 [dropshadow=1]01 [dropshadow=2]02 [dropshadow=3]03 [dropshadow=4]04 [dropshadow=5]05 [dropshadow=6]06 [dropshadow=7]07 [dropshadow=8]08 [dropshadow=9]09 [dropshadow=10]10[/dropshadow]
[b]mirror[/b] - [mirror]Print text backwards[/mirror]    (Print Text Backwards)
[b]rotate[/b]=# - [rotate=180]Rotate Text[/rotate]    (Rotate Text)
[b]color[/b]=# - [color=2]Sets color, based on a palette table.[/color] [color=#AA2032]Or Hex #AA2032[/color]
[b]font=lowercase_font_name[/b] - [font=earth_illusion]Change font ([b]B[/b] [i]I[/i] [u]U[/u] [s]S[/s])
[/font][b]scale[/b]=# -   [scale=2]Scale the text[/scale]
]]
    left_text:send(test_string, nil, true)
end

-- Font Test 3 
if mode == 5 then 
local test_string = [[Formatting Commands
[b]shake[/b] - [shake]Shake Text[/shake]
[b]spin[/b] - [spin]Spin Text[/spin]
[b]swing[/b] - [swing]Swing Text[/swing]
[b]raindrop[/b] - [raindrop]Rain Fall Text[/raindrop]
[b]bounce[/b] - [bounce]Bounce Text[/bounce]
[b]blink[/b] - [blink]Blink Text[/blink]
[b]rainbow[/b] - [rainbow]Raibow Text[/rainbow]
[b]shader[/b] - [shader=x_gradient]Apply a shader for advanced text control - have fun![/shader]
[rainbow][bounce][shake]Combine them for more effects![/shake][/bounce][/rainbow] - (rainbow bounce shake)
]]
    left_text:send(test_string, nil, true)
end

if mode == 6 then 
  local test_string = [[This is text that will wrap around automaticly, based on the pixel count sent to the textbox. [rainbow]Handy![/rainbow] ]]
    left_text:send(test_string .. "(left)", 70, true)
    right_text:send(test_string .. "(right)", 70, true)
    center_text:send(test_string .. "(center)", 70, true)
    full_text:send(test_string .. "(full)", 70, true)
  end

if mode == 7 then 
  local test_string = [[This will even work when printing the text out one by one! [rainbow][|♔][|♕][|♖][|♗][|♘][|♙] [|♠] [|♣] [|♥] [|♦] [|♩][|♪][|♫][|♬][|♭][|♮][|♯] [|⚀] [|⚁] [|⚂] [|⚃] [|⚄] [|⚅][/rainbow]
]]
    left_text:send(test_string, 70, false)
    right_text:send(test_string, 70, false)
    center_text:send(test_string, 70, false)
    full_text:send(test_string, 70, false)
  end
if mode == 8 then 
  local test_string = [[[font=earth_illusion]This will even work when you change the font (Within Limits) [rainbow]Yeah![/rainbow] ]]
    left_text:send(test_string, 70, false)
    right_text:send(test_string, 70, false)
    center_text:send(test_string, 70, false)
    full_text:send(test_string, 70, false)
end
if mode == 10 then 
  mode = mode + 1
end
if mode == 9 then 
  local test_string = [[[u]Note that[/u] text effects [bounce]that change the width[/bouce] [s]of[/s] [shake]characters may break[/shake][b]![/b] [icon=1] autowrap]]
  local test_string2 = [[[u]Note that[/u] [shake]text effects that[/shake] change the width [s]of[/s] [font=earth_illusion]characters may break autowrap[/font] [icon=1][b]![/b] ]]
  local test_string3 = [[[u]Note that[/u] [font=earth_illusion]text effects [s]that[/s] change[/font] the width of [spin]characters may break[/spin] autowrap[icon=1][b]![/b] ]]
  local test_string4 = [[[u]You may[/u] want to manually format [s]these[/s] strings[b]![/b] [icon=1][icon=1] ]]
    left_text:send(test_string, 70, false)
    right_text:send(test_string2, 70, false)
    center_text:send(test_string3, 70, false)
    full_text:send(test_string4, 70, false)
  end
  if mode == 11 then 
    local test_string = [[
[textspeed=0][|A note on Unicode characters:][/textspeed]
So, I don't have a great way to deal with characters with more than one byte of data in this library. So you must wrap extended characters like this: [|sp1]|[|è][|sp2]
Th[|è]n you can print it to your h[|è]arts d[|è]sir[|è].
You can even wrap more than one character this way.
[|sp1]|[|ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçö][|sp2]
    ]]
        left_text:send(test_string, 318, true)
        right_text:send("", 70, false)
        center_text:send("", 70, false)
        full_text:send("", 70, false)
    end
  if mode == 12 then 
    local test_string = [[
[textspeed=0][|A note on Unicode characters continued:][/textspeed]
This will even work when printing characters one by one.
This will [|è]ven work wh[|è]n printing charact[|è]rs on[|è] by on[|è].
[|You] [|can] [|even] [|wrap] [|words] [|this] [|way] [|to] [|print] [|them] [|at] [|once].
Isn't that [|n][|eeeee][|eeeee][|eeeee]t!
[rainbow][swing][|Tèxt] [|èffects][/swing] [shake][|work] [|too!] Cool [|è]h? [/shake][/rainbow]
This will even work for other languages!
[font=shinonome][|こ][|ん][|に][|ち][|は][|！][/font]
    ]]
        left_text:send(test_string, 318, false)
    end
  if mode == 13 then 
    local test_string = [[
[b]More Commands Continued[/b]
Textspeed=# - Time in seconds between each character
Pause=# - Wait Time in seconds between each character
Skip - Skip printing the rest of the text and draw it all.
Backspace=# - Erase that many characters and reprint, very fragile
Audio=name - Play audio
Voice=# - Change what voice is used when printing, 0 is off

    ]]
        left_text:send(test_string, 318, true)
    end

if mode == 14 then 
    local test_string = [[
[b]More Commands Example[/b][voice=2]
[textspeed=0.1]Slowly Printing[/textspeed]
Let's [pause=0.2]Pause [pause=0.2]Between [pause=0.2]Words
Backspace Sucks[backspace=5]Rocks.
[audio=music=clock]Let's play some audio.
Aaaaaannnnnd Stop![/audio=music=clock] [voice=1] 
    ]]
        left_text:send(test_string, 318, false)
    end

if mode == 15 then 
    local test_string = [[
[b]Speaking Voice Commands[/b] [voice=1] [newline]Voice 1
I can speak with all the world, [warble=2]all the sights [warble=2]and all the sounds. [warble=-4]Though some may pry I [warble=-3]can speak eye to eye, [warble=4]no matter how deep or how sad [warble=-4]this is the song of the land. [voice=2]
Voice 2 [soundevery=4]
I can speak with all the world, [warble=2]all the sights [warble=2]and all the sounds. [warble=-4]Though some may pry I [warble=-3]can speak eye to eye, [warble=4]no matter how deep or how sad [warble=-4]this is the song of the land. [voice=1]
]]
        left_text:send(test_string, 318, false)
    end

if mode == 16 then 
    local test_string = [[
[b]Drawing Images[/b] [image=system=icon]

[b]Broken Images when image does not exist [/b][image=curssor=cursor1][image=cursor=curssor1]
]]
        left_text:send(test_string, 318, true)
    end


end


return scene
