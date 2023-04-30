local upFunc, downFunc, confirmFunc, drawFunc, musicStop

local menuState

local menuNum = 1

local songNum, songAppend
local songDifficulty = 2

local selectSound = love.audio.newSource("sounds/menu/select.ogg", "static")
local confirmSound = love.audio.newSource("sounds/menu/confirm.ogg", "static")
local transparency

local difficultyStrs = {
	"-easy",
	"",
	"-hard"
}

return {
	enter = function(self, previous)
		camera.zoom = 1

		beatHandler.setBPM(102)
		if music:isPlaying() then
			music:stop()
		end
		music:play()
		function tweenMenu()
			if logo.y == -500 then 
				Timer.tween(2, logo, {y = -10}, "out-back")
			end
			Timer.after(
				2, 
				function()
					if cat.y == 700 then
						Timer.tween(1.5, cat, {x = cat.x, y = 200}, "out-back")
					end
				end
			)
			Timer.after(
				9,
				function()
					if camScaleTimer then Timer.cancel(camScaleTimer) end
	
					camScaleTimer = Timer.tween(0.7, camera, {zoom = 1}, "out-expo")
				end
			)
		end

		transparency = {0}
		Timer.tween(
			1,
			transparency,
			{[1] = 1},
			"out-quad"
		)
		titleBG = graphics.newImage(graphics.imagePath("menu/titleBG"))
		changingMenu = false

		gradient = graphics.newImage(graphics.imagePath("menu/gradient"))
		gradient.sizeX, gradient.sizeY = 1.2

		cat = graphics.newImage(graphics.imagePath("menu/cat"))
		cat.sizeX, cat.sizeY = 1.3
		cat.x, cat.y = 500, 700

		logo = graphics.newImage(graphics.imagePath("menu/logo"))
		logo.sizeX, logo.sizeY = 1.2
		logo.y = -500

		start = graphics.newImage(graphics.imagePath("menu/start"))

		flowers = graphics.newImage(graphics.imagePath("menu/flowers"))
		flowers.y = 280

		leftArrow = graphics.newImage(graphics.imagePath("menu/left"))
		leftArrow.x, leftArrow.y = -100, -325

		rightArrow = graphics.newImage(graphics.imagePath("menu/right"))
		rightArrow.x, rightArrow.y = 80, -325

		options = graphics.newImage(graphics.imagePath("menu/options"))
		options.x, options.y = 600, -320

		flash = love.filesystem.load("sprites/menu/flash.lua")()
		flash.sizeX, flash.sizeY = 999

		difficulties = love.filesystem.load("sprites/menu/difficulties.lua")()
		difficulties.y = -320

		tweenMenu()

		function confirmFunc()
			music:stop()
			songNum = 1

			status.setLoading(true)

			graphics:fadeOutWipe(
				0.7,
				function()
					
					songAppend = difficultyStrs[songDifficulty]

					storyMode = true

					Gamestate.switch(weekData[weekNum], songNum, songAppend, weekNum)

					status.setLoading(false)
				end
			)
		end

		songNum = 0

		if firstStartup then
			graphics.setFade(0) 
			graphics.fadeIn(0.5) 
		else graphics:fadeInWipe(0.6) end

		firstStartup = false
		intro = true
	end,

	update = function(self, dt)
		flash:update(dt)
		difficulties:update(dt)
	
		if songDifficulty == 3 then
			difficulties:animate("hard", false)
		elseif songDifficulty == 2 then
			difficulties:animate("normal", false)
		else
			difficulties:animate("easy", false)
		end

		delta = love.timer.getDelta()

		gradient.x = gradient.x - 50 * love.timer.getDelta()
		start.y = 300 + math.sin(love.timer.getTime() * 6) * 4

		if gradient.x <= -45 then
			gradient.x = 0
		end

		Timer.after(
			2, 
			function()
				logo.y = logo.y + math.sin(love.timer.getTime() * 6) * 2
			end
		)

		Timer.after(
			6.7, 
			function()
				if intro then
					camera.zoom = camera.zoom + 0.2 * love.timer.getDelta()
				end
			end
		)

		Timer.after(
			9,
			function()
				if camera.zoom >= 1.2 then
					flash:animate("anim", false)
				end
				intro = false
			end
		)

		beatHandler.update(dt)

		if not graphics.isFading() then
			if not intro then
				if input:pressed("confirm") then
					audio.playSound(confirmSound)

					confirmFunc()
				elseif input:pressed("left") then
					audio.playSound(selectSound)
	
					if songDifficulty ~= 1 then
						songDifficulty = songDifficulty - 1
					else
						songDifficulty = 3 
					end
	
				elseif input:pressed("right") then
					audio.playSound(selectSound)
	
					if songDifficulty ~= 3 then
						songDifficulty = songDifficulty + 1
					else
						songDifficulty = 1
					end
				elseif input:pressed("back") then
					audio.playSound(selectSound)
					love.event.quit()
				elseif input:pressed("settings") then
					audio.playSound(confirmSound)
					Gamestate.push(menuSettings)
				end
			end
		end
	end,

	draw = function(self)
		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)
			love.graphics.scale(camera.zoom, camera.zoom)

			love.graphics.push()
				love.graphics.push()

				if not intro then
					titleBG:draw()
					gradient:draw()
				end
				
				love.graphics.pop()
				love.graphics.push()
					love.graphics.scale(0.9, 0.9)
					logo:draw()
					if not intro then
						flowers:draw()
						start:draw()
						difficulties:draw()
						leftArrow:draw()
						rightArrow:draw()
						options:draw()
					end
					cat:draw()

				love.graphics.pop()
				love.graphics.push()
					love.graphics.scale(0.9, 0.9)

				love.graphics.pop()
			love.graphics.pop()
			if flash:isAnimated() then
				flash:draw()
			end

		love.graphics.pop()
	end,

	leave = function(self)
		titleBG = nil
		gradient = nil
		logo = nil
		flowers = nil
		start = nil
		difficulties = nil
		leftArrow = nil
		rightArrow = nil
		options = nil
		cat = nil
		flash = nil
		camera.zoom = 1

		Timer.clear()
	end
}
