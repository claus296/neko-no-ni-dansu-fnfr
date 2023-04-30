local creditText, selectSound, confirmSound
-- i literally said we should use a big string and you said no - CH

local shader_invert = [[ 
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords) { 
	
	vec4 col = texture2D( texture, texture_coords ); 
	return vec4(1-col.r, 1-col.g, 1-col.b, col.a); 
} 
]]

creditText = [[

Original Mod Credits

Thank You for playing our mod for the Turtle Pals Funk Jam!

We worked really hard and we hope everyone likes it!
The mod is partially inspired by the Geometry Dash level "peaceful"
Contrast is used in the form of themes (peaceful and scary)
Once again thank you for playing our mod!


The following will be Credits and Lore:






Nom - Coder and Director

Maxos Hell - Artist and Co Director

Yoshi Dam - Composer and Co Director

Toben - Charter

RaiGuyyy - VoiceActor




Lore:














Port Credits

Vanilla Engine:

GuglioIsStupid - Programming
Getsaa - Menu Designer

Mod Port:

Claus296


Funkin' Rewritten:

HTV04


Friday Night Funkin':

ninjamuffin99
PhantomArcade
Evilsk8r
Kawaisprite
And all the contributors


Miscellaneous:

PhantomClo - Pixel note splashes
Keoki - Note splashes
P-sam - Developing LOVE-NX
The developers of the LÖVE framework
RiverOaken - Psych Engine credits button
]]

return {
    enter = function(self)
		camera.zoom = 1

        if not music:isPlaying() then
            music:play()
        end

		invert = love.graphics.newShader(shader_invert)

        lore = graphics.newImage(graphics.imagePath("menu/lore"))
        lore.x, lore.y = 355, 1700

        credY = {
            250
        }
        graphics:fadeInWipe(0.6)

        --function invertLoop()
        --    Timer.after(
        --        2, 
        --        function()
        --            love.graphics.setShader(invert)
        --            changeCol = true
        --            Timer.after(
        --                2, 
        --                function()
        --                    love.graphics.setShader()
        --                    changeCol = false
        --                    Timer.after(
        --                        0, 
        --                        function()
        --                            invertLoop()
        --                        end
        --                    )
        --                end
        --            )
        --        end
        --    )
        --end

        --invertLoop()
    end,
    update = function(self, dt)
        if credTween then 
            Timer.cancel(credTween)
        end
        if input:pressed("gameBack") then
            graphics:fadeOutWipe(0.5,
            function()
                Gamestate.switch(menu)
            end)
        end
        if input:down("down") then
            if credY[1] > -3000 then  
                credTween = Timer.tween(0.1, credY, {[1] = credY[1] - 25}, "out-quad")
                
            end
        elseif input:down("up") then
            if credY[1] < 250 then
                credTween = Timer.tween(0.1, credY, {[1] = credY[1] + 25}, "out-quad")
            end
        end
    end,
    draw = function(self)
        love.graphics.push()
        love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)
        love.graphics.translate(-350,math.abs(graphics.getHeight() / 2)+credY[1]-700)
        love.graphics.printf(creditText, -640, 0, 2000, "center")

        love.graphics.rectangle("fill", -1000, -500, 10000, 10000)

        lore:draw()

        graphics.setColor(0,0,0)

        love.graphics.printf(creditText, -640, 0, 2000, "center")

        love.graphics.pop()
    end,
    leave = function(self)

    end
}
