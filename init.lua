-----------------------------------------------------------------------------
-- OPERATING I/O GAME SETTINGS --
-----------------------------------------------------------------------------
displaymode = {
	w = 800,
	h = 600,
	full = false,
	vsync = false,
	aa = 0
}

screenwidth = 1024
function initWindow ()

	font_size = 10

	window.size_x = 1024
	window.size_y = 768
	resolution = {}
	--TLfres.setScreen(displaymode, screenwidth)
	window.features = love.graphics.setMode( window.size_x, window.size_y, no, no, no )
	love.graphics.setCaption( " PIMPS vs VAMPS v0.1.3 - made by Bacioiu 'Zapa' Ciprian and Thomas Noppers" )
	love.mouse.setPosition( window.size_x/2, window.size_y/2 )
	--love.graphics.setFont(font_size)

	math.randomseed (os.time())
	

end -- end function --

