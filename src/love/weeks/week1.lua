--[[----------------------------------------------------------------------------
This file is part of Friday Night Funkin' Rewritten

Copyright (C) 2021  HTV04

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
------------------------------------------------------------------------------]]

local difficulty

local stageBack, stageFront, curtains

local shader_invert = [[ 
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords) { 
	
	vec4 col = texture2D( texture, texture_coords ); 
	return vec4(1-col.r, 1-col.g, 1-col.b, col.a); 
} 
]]

return {
	enter = function(self, from, songNum, songAppend)
		weeks:enter()
		camera.defaultZoom = 0.6

		song = songNum
		difficulty = songAppend

		sky = graphics.newImage(graphics.imagePath("kyatto/sky"))
		sky.sizeX, sky.sizeY = 2

		hills = graphics.newImage(graphics.imagePath("kyatto/hills"))
		hills.y = -200

		trees = graphics.newImage(graphics.imagePath("kyatto/trees"))

		ground = graphics.newImage(graphics.imagePath("kyatto/ground"))
		ground.y = 600

		hud = graphics.newImage(graphics.imagePath("kyatto/hud"))
		hud.sizeX, hud.sizeY = 0.75
		hud.x, hud.y = 620, 350

		skyEvil = graphics.newImage(graphics.imagePath("kyatto/evil/sky"))
		skyEvil.sizeX, skyEvil.sizeY = 2

		hillsEvil = graphics.newImage(graphics.imagePath("kyatto/evil/hills"))
		hillsEvil.y = -200

		treesEvil = graphics.newImage(graphics.imagePath("kyatto/evil/trees"))

		groundEvil = graphics.newImage(graphics.imagePath("kyatto/evil/ground"))
		groundEvil.y = 600

		hudEvil = graphics.newImage(graphics.imagePath("kyatto/evil/hud"))
		hudEvil.sizeX, hudEvil.sizeY = 0.75
		hudEvil.x, hudEvil.y = 620, 350

		warning = graphics.newImage(graphics.imagePath("kyatto/evil/warning"))
		warning.x, warning.y = 1445, 360

		skyHell = graphics.newImage(graphics.imagePath("kyatto/hell/sky"))
		skyHell.sizeX, skyHell.sizeY = 2

		hillsHell = graphics.newImage(graphics.imagePath("kyatto/hell/hills"))
		hillsHell.sizeX, hillsHell.sizeY = 2

		pillarsHell = graphics.newImage(graphics.imagePath("kyatto/hell/pillars"))
		pillarsHell.sizeX, pillarsHell.sizeY = 2
		
		foregroundHell = graphics.newImage(graphics.imagePath("kyatto/hell/foreground"))
		foregroundHell.sizeX, foregroundHell.sizeY = 2
		
		overlay = graphics.newImage(graphics.imagePath("kyatto/hell/overlay"))

		jumpscare = graphics.newImage(graphics.imagePath("kyatto/hell/jumpscare"))
		jumpscare.sizeX, jumpscare.sizeY = 1.1
		jumpscare.x, jumpscare.y = 650, 380

		nyanyo = love.filesystem.load("sprites/kyatto/nyanyo.lua")()

		bfNormal = love.filesystem.load("sprites/boyfriend.lua")()

		bfScared = love.filesystem.load("sprites/kyatto/evil/bfScared.lua")()
		bfScared.x = 410

		nyanyoScared = love.filesystem.load("sprites/kyatto/evil/nyanyoScared.lua")()
		nyanyoScared.x, nyanyoScared.y = -330, 250

		nyanyoHell = love.filesystem.load("sprites/kyatto/hell/nyanyoHell.lua")()
		nyanyoHell.x, nyanyoHell.y = -730, -50

		sun = love.filesystem.load("sprites/kyatto/sun.lua")()
		sun.x, sun.y = 70, -500

		sunEvil = love.filesystem.load("sprites/kyatto/evil/sun.lua")()
		sunEvil.sizeX, sunEvil.sizeY = 1.4
		sunEvil.x, sunEvil.y = 80, -800

		static = love.filesystem.load("sprites/kyatto/hell/static.lua")()
		static.sizeX, static.sizeY = 1.1
		static.x, static.y = 650, 380

		enemy = nyanyo
		boyfriend = bfNormal

		enemy.x, enemy.y = -330, 250
        boyfriend.x, boyfriend.y = 310, 300

		sun:animate("anim", true)
		sunEvil:animate("anim", true)
		static:animate("anim", true)

		self:load()
	end,

	load = function(self)
		weeks:load()

		invert = love.graphics.newShader(shader_invert)

		inst = love.audio.newSource("songs/kyatto/Inst.ogg", "stream")
		voices = love.audio.newSource("songs/kyatto/Voices.ogg", "stream")

		self:initUI()

		weeks:setupCountdown()
	end,

	initUI = function(self)
		weeks:initUI()

		weeks:generateNotes("data/kyatto/kyatto" .. difficulty .. ".json")
	end,

	update = function(self, dt)
		weeks:update(dt)
		sun:update(dt)
		sunEvil:update(dt)
		static:update(dt)

		if musicTime <= 0 then
			camera.x, camera.y = -boyfriend.x + 100, -boyfriend.y + 215
		end

		if musicTime <= 59718.75 then
			warning.x = 1445
			sunEvil.y = -800
			camera.defaultZoom = 0.6
			camera:removePoint("boyfriend")
			camera:removePoint("enemy")
			if not camera.points["boyfriend"] then camera:addPoint("boyfriend", -boyfriend.x + 100, -boyfriend.y + 215) end
			if not camera.points["enemy"] then camera:addPoint("enemy", -enemy.x - 100, -enemy.y + 215) end
			enemy = nyanyo
			enemyIcon:animate("nyanyo", false)
		end

		if musicTime <= 106638.888888889 then
			boyfriend = bfNormal
			boyfriendIcon:animate("boyfriend", false)
		end

		if musicTime >= 127328.125 then
			if musicTime <= 127328.125 + 700 then
				jumpscareShakeX = love.math.random(-20, 20)
				jumpscareShakeY = love.math.random(-20, 20)
			end
		end

		accuracy = ((math.floor(ratingPercent * 10000) / 100))

		hudAlpha = math.sin(love.timer.getTime() * 2.3) * 0.6
		
		--if musicTime >= 24000 then
		--	if musicTime <= 24000 + 12000 then
		--		camScaleTimer = Timer.tween(12, camera, {zoom = camera.zoom * 1.02}, "out-quad", function() camScaleTimer = Timer.tween(12, camera, {zoom = camera.defaultZoom}, "out-quad") end)
		--	end
		--end
		if musicTime >= 30000 then
			if musicTime <= 30000 + 50 then
				boyfriend:animate("hey", false)
				enemy:animate("nya", false)
			end
		end
		if musicTime >= 59718.75 then
			if musicTime <= 59718.75 + 50 then
				enemy = nyanyoScared
				enemyIcon:animate("nyanyo 2", false)
				camera.defaultZoom = 0.8
				camera:removePoint("boyfriend")
				camera:removePoint("enemy")
				camera.x, camera.y = -boyfriend.x + 100, -boyfriend.y + 115
				if not camera.points["boyfriend"] then camera:addPoint("boyfriend", -boyfriend.x + 100, -boyfriend.y + 115) end
				if not camera.points["enemy"] then camera:addPoint("enemy", -enemy.x - 100, -enemy.y + 115) end
			end
		end
		if musicTime >= 59718.75 then
			if sunEvil.y == -800 then
				Timer.tween(1, sunEvil, {x = sunEvil.x, y = -200}, "out-sine")
			end
		end

		if musicTime >= 60718.75 then
			if warning.x == 1445 then
				Timer.tween(1, warning, {x = 645, y = warning.y}, "out-sine")
			end
		end

		if musicTime >= 60718.75 + 4000 then
			if accuracy < 70 then
				health = 0
			end
			warning.x = 645
			if warning.x == 645 then
				Timer.tween(1, warning, {x = 1445, y = warning.y}, "out-sine")
			end
		end
		if musicTime >= 60718.75 + 7000 then
			if musicTime <= 106638.888888889 then
				if sunEvil.y > -210 then
					sunEvil.y = -200
				end
				if sunEvil.y == -200 then
					Timer.tween(1, sunEvil, {x = sunEvil.x, y = -250}, "out-sine")
				end
			end
		end
		if musicTime >= 82781.25 then
			if musicTime <= 82781.25 + 50 then
				enemy:animate("nya", false)
			end
		end
		if musicTime >= 106638.888888889 then
			if sunEvil.y == -400 then
				Timer.tween(2.5, sunEvil, {x = sunEvil.x, y = 900}, "in-back")
			end
			if musicTime <= 106638.888888889 + 50 then
				if sunEvil.y ~= -400 then
					sunEvil.y = -400
				end
				bfNormal:animate("idle", false) -- so bf doesnt do the down anim at the beginning of the song after restarting
				enemy = nyanyoHell
				enemyIcon:animate("nyanyo 3", false)
				boyfriendIcon:animate("boyfriend 2", false)
				boyfriend = bfScared
				camera:removePoint("boyfriend")
				camera:removePoint("enemy")
				camera.x, camera.y = -boyfriend.x + 100, -boyfriend.y + 215
				if not camera.points["boyfriend"] then camera:addPoint("boyfriend", -boyfriend.x + 100, -boyfriend.y + 215) end
				if not camera.points["enemy"] then camera:addPoint("enemy", -enemy.x - 300, -enemy.y + 215) end
			end
		end
		if musicTime >= 127328.125 then
			camera.defaultZoom = 0.55
		end
		if musicTime >= 127328.125 then
			if musicTime <= 127328.125 + 1000 then
				jumpscare.x, jumpscare.y = 650 + jumpscareShakeX, 380 + jumpscareShakeY
			end
		end

		if health >= 1.595 then
			if enemyIcon:getAnimName() == "nyanyo" then
				enemyIcon:animate("nyanyo losing", false)
			end
		else
			if enemyIcon:getAnimName() == "nyanyo losing" then
				enemyIcon:animate("nyanyo", false)
			end
		end
		if health >= 1.595 then
			if enemyIcon:getAnimName() == "nyanyo 2" then
				enemyIcon:animate("nyanyo 2 losing", false)
			end
		else
			if enemyIcon:getAnimName() == "nyanyo 2 losing" then
				enemyIcon:animate("nyanyo 2", false)
			end
		end
		if health >= 1.595 then
			if enemyIcon:getAnimName() == "nyanyo 3" then
				enemyIcon:animate("nyanyo 3 losing", false)
			end
		else
			if enemyIcon:getAnimName() == "nyanyo 3 losing" then
				enemyIcon:animate("nyanyo 3", false)
			end
		end
		if health > 0.325 and boyfriendIcon:getAnimName() == "boyfriend 2 losing" then
			boyfriendIcon:animate("boyfriend 2", false)
		elseif health <= 0.325 and boyfriendIcon:getAnimName() == "boyfriend 2" then
			boyfriendIcon:animate("boyfriend 2 losing", false)
		end

		if not (countingDown or graphics.isFading()) and not (inst:isPlaying() and voices:isPlaying()) and not paused then
			if storyMode and song < 1 then
				song = song + 1

				self:load()
			else
				status.setLoading(true)

				graphics:fadeOutWipe(
					0.7,
					function()
						Gamestate.switch(menuCredits)

						status.setLoading(false)
					end
				)
			end
		end

		weeks:updateUI(dt)
	end,

	draw = function(self)
		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)
			love.graphics.scale(camera.zoom, camera.zoom)

			love.graphics.push()
				love.graphics.translate(camera.x * 0.9, camera.y * 0.9)
				love.graphics.translate(camera.ex * 0.9, camera.ey * 0.9)

				if musicTime <= 84000 then
					love.graphics.setShader()
				end
				if musicTime >= 84000 then
					if musicTime <= 90000 then
						love.graphics.setShader(invert)
					end
				end
				if musicTime >= 90000 then
					if musicTime <= 97500 then
						love.graphics.setShader()
					end
				end
				if musicTime >= 97500 then
					if musicTime <= 101333.333333333 then
						love.graphics.setShader(invert)
					end
				end
				if musicTime >= 101333.333333333 then
					love.graphics.setShader()
				end

				if musicTime <= 59718.75 then
					sky:draw()
					sun:draw()
					hills:draw()
					trees:draw()
					ground:draw()
				end
				if musicTime >= 59718.75 then
					if musicTime <= 106666.666666667 then
						skyEvil:draw()
						sunEvil:draw()
						hillsEvil:draw()
						treesEvil:draw()
						groundEvil:draw()
					end
				end

				if musicTime >= 106666.666666667 then
					skyHell:draw()
					if sunEvil.y < 790 then
						sunEvil:draw()
					end
					hillsHell:draw()
					pillarsHell:draw()
					foregroundHell:draw()
				end

			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(camera.x, camera.y)
				love.graphics.translate(camera.ex, camera.ey)

				enemy:draw()
				boyfriend:draw()

			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(camera.x * 1.1, camera.y * 1.1)
				love.graphics.translate(camera.ex * 1.1, camera.ey * 1.1)

			love.graphics.pop()
		love.graphics.pop()

		love.graphics.setShader()

		if musicTime >= 59718.75 then
			if musicTime <= 106666.666666667 then
				graphics.setColor(1, 1, 1, hudAlpha)

				hudEvil:draw()
			end
		end

		graphics.setColor(1, 1, 1, 1)

		if musicTime <= 59718.75 then
			hud:draw()
		end

		graphics.setColor(0, 0, 0, 1)

		if musicTime >= 59531.25 then
			if musicTime <= 60000 then
				love.graphics.rectangle("fill", 9000, 10000, -10000, -10000)
			end
		end
		if musicTime >= 104250 then
			if musicTime <= 104666.666666667 then
				love.graphics.rectangle("fill", 9000, 10000, -10000, -10000)
			end
		end
		if musicTime >= 105000 then
			if musicTime <= 105333.333333333 then
				love.graphics.rectangle("fill", 9000, 10000, -10000, -10000)
			end
		end
		if musicTime >= 105500 then
			if musicTime <= 105666.666666667 then
				love.graphics.rectangle("fill", 9000, 10000, -10000, -10000)
			end
		end
		if musicTime >= 105833.333333333 then
			if musicTime <= 106000 then
				love.graphics.rectangle("fill", 9000, 10000, -10000, -10000)
			end
		end
		if musicTime >= 106083.333333333 then
			if musicTime <= 106166.666666667 then
				love.graphics.rectangle("fill", 9000, 10000, -10000, -10000)
			end
		end
		if musicTime >= 106250 then
			if musicTime <= 106333.333333333 then
				love.graphics.rectangle("fill", 9000, 10000, -10000, -10000)
			end
		end
		if musicTime >= 106416.666666667 then
			if musicTime <= 106500 then
				love.graphics.rectangle("fill", 9000, 10000, -10000, -10000)
			end
		end
		if musicTime >= 106583.333333333 then
			if musicTime <= 106750 then
				love.graphics.rectangle("fill", 9000, 10000, -10000, -10000)
			end
		end
		if musicTime >= 106666.666666667 then
			if musicTime <= 127328.125 then
				graphics.setColor(0, 0, 0, 0.8)
				love.graphics.rectangle("fill", 9000, 10000, -10000, -10000)
			end
		end
		if musicTime >= 148083.333333333 then
			if musicTime <= 148250 then
				love.graphics.rectangle("fill", 9000, 10000, -10000, -10000)
			end
		end
		if musicTime >= 148416.666666667 then
			if musicTime <= 148583.333333333 then
				love.graphics.rectangle("fill", 9000, 10000, -10000, -10000)
			end
		end
		if musicTime >= 148750 then
			if musicTime <= 148916.666666667 then
				love.graphics.rectangle("fill", 9000, 10000, -10000, -10000)
			end
		end
		if musicTime >= 149083.333333333 then
			if musicTime <= 149250 then
				love.graphics.rectangle("fill", 9000, 10000, -10000, -10000)
			end
		end

		graphics.setColor(1,1,1)
		
		if not paused then
			weeks:drawUI()
		end

		if musicTime >= 60718.75 then
			if musicTime <= 60718.75 + 4500 then
				warning:draw()
			end
		end
		if musicTime >= 127328.125 then
			if musicTime <= 127328.125 + 700 then
				jumpscare:draw()
			end
		end
		graphics.setColor(1, 1, 1, 0.3)

		if musicTime >= 127333.333333333 then
			if musicTime <= 127333.333333333 + 500 then
				static:draw()
			end
		end
		if musicTime >= 128000 then
			if musicTime <= 128000 + 500 then
				static:draw()
			end
		end
		if musicTime >= 139250 then
			if musicTime <= 139250 + 500 then
				static:draw()
			end
		end
		if musicTime >= 139500 then
			if musicTime <= 139500 + 500 then
				static:draw()
			end
		end
		if musicTime >= 144583.333333333 then
			if musicTime <= 144583.333333333 + 500 then
				static:draw()
			end
		end
		if musicTime >= 144916.666666667 then
			if musicTime <= 144916.666666667 + 500 then
				static:draw()
			end
		end

		if paused then
			weeks:drawUI()
		end
	end,

	leave = function(self)
		enemy = nil
		boyfriend = nil
		girlfriend = nil

		graphics.clearCache()

		weeks:leave()
	end
}
