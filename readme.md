# SLog-Text
**Please see the main.lua for samples, please review the library for all the possible tags.**

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


# Screenshots
![Example 1](/screenshots/1.gif?raw=true "Example of Library")
![Example 2](/screenshots/2.gif?raw=true "Example of Library")
![Example 3](/screenshots/3.png?raw=true "Example of Library")
![Example 4](/screenshots/4.png?raw=true "Example of Library")
![Example 5](/screenshots/5.gif?raw=true "Example of Library")
![Example 6](/screenshots/6.gif?raw=true "Example of Library")
![Example 7](/screenshots/7.gif?raw=true "Example of Library")