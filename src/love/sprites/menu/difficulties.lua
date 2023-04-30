return graphics.newSprite(
	love.graphics.newImage(graphics.imagePath("menu/dificulties")),
	-- Automatically generated from dificulties.xml
	{
		{x = 10, y = 10, width = 168, height = 76, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 1: easy0000
		{x = 10, y = 96, width = 168, height = 76, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 2: normal0001
		{x = 10, y = 182, width = 168, height = 76, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0} -- 3: hard0002
	},
	{
		["easy"] = {start = 1, stop = 1, speed = 0, offsetX = 0, offsetY = 0},
		["normal"] = {start = 2, stop = 2, speed = 0, offsetX = 0, offsetY = 0},
		["hard"] = {start = 3, stop = 3, speed = 0, offsetX = 0, offsetY = 0}
	},
	"normal",
	false
)
