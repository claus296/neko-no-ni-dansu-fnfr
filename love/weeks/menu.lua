--[[----------------------------------------------------------------------------
This file is part of Friday Night Funkin' Rewritten by HTV04
------------------------------------------------------------------------------]]

menu = {
	init = function()
		menuState = 0
		weekSongs = {
			{
				"Tutorial"
			},
			{
				"Bopeebo",
				"Fresh",
				"Dadbattle"
			},
			{
				"Spookeez",
				"South"
			},
			{
				"Pico",
				"Philly Nice",
				"Blammed"
			}
		}
		difficultyStrs = {
			"-easy",
			"",
			"-hard"
		}
		
		selectSound = love.audio.newSource("sounds/scrollMenu.ogg", "static")
		confirmSound = love.audio.newSource("sounds/confirmMenu.ogg", "static")
		
		titleBG = Image("images/titleBG.png")
		logo = Image("images/logo.png")
		
		girlfriendTitle = love.filesystem.load("sprites/girlfriend-dance-title.lua")()
		
		logo.x, logo.y = -350, -125
		logo.sizeX, logo.sizeY = 1.25, 1.25
		
		girlfriendTitle.x, girlfriendTitle.y = 300, -75
		
		music = love.audio.newSource("music/freakyMenu.ogg", "stream")
		music:setLooping(true)
		music:play()
	end,
	
	update = function(dt)
		if graphics.fade[1] == 1 then
			if input:pressed("left") then
				audio.playSound(selectSound)
				
				if menuState == 0 then
					weekNum = weekNum - 1
					
					if weekNum < 0 then
						weekNum = 3
					end
				elseif menuState == 1 then
					songNum = songNum - 1
					
					if songNum < 0 then
						songNum = #weekSongs[weekNum + 1]
					end
				elseif menuState == 2 then
					songDifficulty = songDifficulty - 1
					
					if songDifficulty < 1 then
						songDifficulty = 3
					end
				end
			elseif input:pressed("right") then
				audio.playSound(selectSound)
				
				if menuState == 0 then
					weekNum = weekNum + 1
					
					if weekNum > 3 then
						weekNum = 0
					end
				elseif menuState == 1 then
					songNum = songNum + 1
					
					if songNum > #weekSongs[weekNum + 1] then
						songNum = 0
					end
				elseif menuState == 2 then
					songDifficulty = songDifficulty + 1
					
					if songDifficulty > 3 then
						songDifficulty = 1
					end
				end
			elseif input:pressed("confirm") then
				audio.playSound(confirmSound)
				
				menuState = menuState + 1
				
				if menuState > 2 then
					music:stop()
					
					menuState = 2 -- So menuState isn't an "invalid" value
					
					graphics.fadeOut(
						1,
						function()
							songAppend = difficultyStrs[songDifficulty]
							
							inMenu = false
							inGame = true
							
							if songNum == 0 then
								songNum = 1
								storyMode = true
							end
							
							if weekNum == 3 then
								week3.init()
							elseif weekNum == 2 then
								week2.init()
							elseif weekNum == 1 then
								week1.init()
							else
								tutorial.init()
							end
						end
					)
				end
			elseif input:pressed("back") then
				audio.playSound(selectSound)
				
				menuState = menuState - 1
				
				if menuState == 1 then
					songDifficulty = 2
				elseif menuState == 0 then
					songNum = 0
				elseif menuState < 0 then
					menuState = 0 -- So menuState isn't an "invalid" value
					
					love.event.quit()
				end
			end
		end
		
		girlfriendTitle:update(dt)
	end,
	
	draw = function()
		titleBG:draw()
		
		love.graphics.push()
			love.graphics.scale(cam.sizeX, cam.sizeY)
			
			logo:draw()
			
			girlfriendTitle:draw()
			
			love.graphics.printf("By HTV04\nv1.0.0 beta 1\n\nOriginal game by ninjamuffin99, PhantomArcade, kawaisprite, and evilsk8er, in association with Newgrounds", -525, 90, 450, "right", nil, 1, 1)
			
			graphics.setColor(1, 1, 0)
			if menuState == 0 then
				if weekNum == 0 then
					love.graphics.printf("Choose a week: < Tutorial >", -640, 285, 853, "center", nil, 1.5, 1.5)
				else
					love.graphics.printf("Choose a week: < Week " .. weekNum .. " >", -640, 285, 853, "center", nil, 1.5, 1.5)
				end
			elseif menuState == 1 then
				if songNum == 0 then
					love.graphics.printf("Choose a song: < (Full Week) >", -640, 285, 853, "center", nil, 1.5, 1.5)
				else
					love.graphics.printf("Choose a song: < " .. weekSongs[weekNum + 1][songNum] .. " >", -640, 285, 853, "center", nil, 1.5, 1.5)
				end
			elseif menuState == 2 then
				if songDifficulty == 1 then
					love.graphics.printf("Choose a difficulty: < Easy >", -640, 285, 853, "center", nil, 1.5, 1.5)
				elseif songDifficulty == 2 then
					love.graphics.printf("Choose a difficulty: < Normal >", -640, 285, 853, "center", nil, 1.5, 1.5)
				elseif songDifficulty == 3 then
					love.graphics.printf("Choose a difficulty: < Hard >", -640, 285, 853, "center", nil, 1.5, 1.5)
				end
			end
			graphics.setColor(1, 1, 1)
			
			if menuState <= 0 then
				if input:getActiveDevice() == "joy" then
					love.graphics.printf("Left Stick/D-Pad: Select | A: Confirm | B: Exit", -640, 350, 1280, "center", nil, 1, 1)
				else
					love.graphics.printf("Arrow Keys: Select | Enter: Confirm | Escape: Exit", -640, 350, 1280, "center", nil, 1, 1)
				end
			else
				if input:getActiveDevice() == "joy" then
					love.graphics.printf("Left Stick/D-Pad: Select | A: Confirm | B: Back", -640, 350, 1280, "center", nil, 1, 1)
				else
					love.graphics.printf("Arrow Keys: Select | Enter: Confirm | Escape: Back", -640, 350, 1280, "center", nil, 1, 1)
				end
			end
		love.graphics.pop()
	end
}
