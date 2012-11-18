ui = { }

function ui:init( )
	self.uiTable = { }
end

function ui:newItemBar(_id, _posX, _posY, _width, _height, _img, _dockImage )
	__img = love.graphics.newImage(_img)
	__dockImage = love.graphics.newImage(_dockImage)

	local tempUi = {
		id = _id,
		posX = _posX,
		posY = _posY,
		width = _width,
		height = _height,
		hHeight = 20,
		image = __img,
		dockImage = __dockImage,
		bgSx = 1,
		bgSy = 1,	
		scaleFactorX,
		scaleFactorY,
		hScaleY,			
		}
	table.insert(self.uiTable, tempUi)
end

function ui:itemBarBackgroundImageAdjustment( id )
	self.uiTable[id].hScaleY = 1 - ( (100 - ( (100 * self.uiTable[id].hHeight ) /  self.uiTable[id].image:getHeight() - self.uiTable[id].hHeight ) ) / 100 )
	self.uiTable[id].scaleFactorX = 1 - ( (100 - ( (100 * self.uiTable[id].width) /  self.uiTable[id].image:getWidth()) ) / 100 )
	self.uiTable[id].scaleFactorY = 1 - ( (100 - ( (100 * self.uiTable[id].height ) /  self.uiTable[id].image:getHeight() - self.uiTable[id].hHeight ) ) / 100 )
	
	bgSx = self.uiTable[id].scaleFactorX
	bgSy = self.uiTable[id].scaleFactorY - self.uiTable[id].hScaleY
end

function ui:drawItemBar( id )
	
	-- handle
	love.graphics.rectangle("line", self.uiTable[id].posX, self.uiTable[id].posY, self.uiTable[id].width, self.uiTable[id].hHeight)
	-- main body
	love.graphics.draw(self.uiTable[id].image, self.uiTable[id].posX, self.uiTable[id].posY + self.uiTable[id].hHeight, 0, bgSx, bgSy )
	love.graphics.rectangle("line", self.uiTable[id].posX, self.uiTable[id].posY, self.uiTable[id].width, self.uiTable[id].height)

end

function ui:pressed(id)
	mPosX = love.mouse.getX()
	mPosY = love.mouse.getY()
	
	if love.mouse.isDown("l") then
		if mPosX >= self.uiTable[id].posX and mPosX <= self.uiTable[id].posX + self.uiTable[id].width then
			if mPosY >= self.uiTable[id].posY and mPosY <= self.uiTable[id].posY + self.uiTable[id].hHeight then	
				self.uiTable[id].posX = mPosX - math.floor(self.uiTable[id].width/2)
				self.uiTable[id].posY = mPosY - math.floor(self.uiTable[id].hHeight/2)
			end			
		end


		--if mPosX > 
		
	end

end


function ui:update( )
	for i,v in ipairs (self.uiTable) do
		ui:pressed(v.id)
		ui:itemBarBackgroundImageAdjustment( v.id )
	end
end

return ui