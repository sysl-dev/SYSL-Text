return [[
Hello there, welcome to the library!

This library will work with any font object that love can produce, and at any scale. So even if you don't use pixel art, this library will work for you!

Note, in order to apply all the effects and animate everything each character is a draw call. So if you have a lot of text, like a visual novel, it might be overkill.

[b]b[/b] - [b]Fake Bold[/b]     [b]u[/b] - [u]Underline[/u]     [b]dropshadow=[/b]# - Style [dropshadow=0]00 [dropshadow=1]01 [dropshadow=2]02 [dropshadow=3]03 [dropshadow=4]04 [dropshadow=5]05 [dropshadow=6]06 [dropshadow=7]07 [dropshadow=8]08 [dropshadow=9]09 [dropshadow=10]10[/dropshadow]
[b]i[/b] - [i]Fake Italics[/i]     [b]s[/b] - [s]Strikethrough[/s]     [b]mirror[/b] - [mirror]Print text backwards[/mirror]    (Print Text Backwards)     [b]rotate[/b]=# - [rotate=180]Rotate Text[/rotate]    (Rotate Text)
[b]color[/b]=# - [color=20]Sets color, based on a palette table.[/color] [color=#AA2032]Or Hex #AA2032[/color]        [b]font=font_name[/b] - [font=comic_neue]Change font ([b]B[/b] [i]I[/i] [u]U[/u] [s]S[/s])

[/font][b]scale[/b]=# -   [scale=2]Scale the text[/scale]   

[b]shake[/b] - [shake]Shake Text[/shake]     [b]bounce[/b] - [bounce]Bounce Text[/bounce]
[b]spin[/b] - [spin]Spin Text[/spin]     [b]blink[/b] - [blink]Blink Text[/blink]
[b]swing[/b] - [swing]Swing Text[/swing]     [b]rainbow[/b] - [rainbow]Raibow Text[/rainbow]
[b]raindrop[/b] - [raindrop]Rain Fall Text[/raindrop]     [b]shader[/b] - [shader=x_gradient]Apply a shader for advanced text control - have fun![/shader]
[rainbow][bounce][shake]Combine them for more effects![/shake][/bounce][/rainbow] - (rainbow bounce shake)

A note on Unicode characters:]
You must wrap extended characters like this: [|sp1]|[|è][|sp2]
Th[|è]n you can print it to your h[|è]arts d[|è]sir[|è].
You can even wrap more than one character this way.
[|sp1]|[|ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçö][|sp2]
[rainbow][swing][|Tèxt] [|èffects][/swing] [shake][|work] [|too!] Cool [|è]h? [/shake][/rainbow]
This will even work for other languages!
[font=shinonome_12][|こ][|ん][|に][|ち][|は][|！][/font][font=shinonome_14][|こ][|ん][|に][|ち][|は][|！][/font][font=shinonome_16][|こ][|ん][|に][|ち][|は][|！][/font]

You can even draw an image directly in the text!
[image=frame=default_8][image=frame=eb_8][image=frame=m3_8]

]]