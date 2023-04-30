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

local fromState

return {
	enter = function(self, from)
		graphics.setFade(1)
		local boyfriend = fakeBoyfriend or boyfriend

		fromState = from

		scream = love.audio.newSource("sounds/scream.ogg", "static")

		jumpscare = graphics.newImage(graphics.imagePath("kyatto/hell/jumpscare"))
		jumpscare.sizeX, jumpscare.sizeY = 1.1

		if inst then inst:stop() end
		voices:stop()

		if musicTime >= 106666.666666667 then
			if not pauseRestart then
				scream:play()
			end
		end

		Timer.clear()
	end,

	update = function(self, dt)
		local boyfriend = fakeBoyfriend or boyfriend
			
		if not scream:isPlaying() then
			if input:pressed("confirm") or pauseRestart then
				pauseRestart = false

				if not pixel then
					inst = love.audio.newSource("music/game-over-end.ogg", "stream")
				else
					inst = love.audio.newSource("music/pixel/game-over-end.ogg", "stream")
				end
				inst:play()

				Timer.clear()

				camera.x, camera.y = -boyfriend.x, -boyfriend.y

				graphics.fadeOut(
					3,
					function()
						Gamestate.pop()

						fromState:load()
					end
				)
			elseif input:pressed("gameBack") then
				status.setLoading(true)

				graphics:fadeOutWipe(
					0.7,
					function()
						Gamestate.pop()

						Gamestate.switch(menuWeek)

						status.setLoading(false)

						if not music:isPlaying() then
							music:play()
						end
					end
				)
			end
		else
			jumpscareShakeX = love.math.random(-20, 20)
			jumpscareShakeY = love.math.random(-20, 20)
			jumpscare.x, jumpscare.y = 650 + jumpscareShakeX, 380 + jumpscareShakeY
		end


		boyfriend:update(dt)
	end,

	draw = function(self)
		local boyfriend = fakeBoyfriend or boyfriend

		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)

			love.graphics.push()
				love.graphics.scale(camera.zoom, camera.zoom)
				love.graphics.translate(camera.x, camera.y)

			love.graphics.pop()
		love.graphics.pop()

		if scream:isPlaying() then
			jumpscare:draw()
		end

	end,

	leave = function(self)
		Timer.clear()
		graphics.setFade(1)
	end
}
