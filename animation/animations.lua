animation = { }

---- Init the animation system
function animation:init( )
	self.animationTable = { }
	animationSpeed = 1
	self.timer = love.timer.getMicroTime()
	self.framePos = 1
end

------------------------------------------------------
-- new: loads the animation files. 
-- Parameters:
-- - _id: ID of the animation to be player
-- - _baseName - name of the .png files to be loaded.
-- 		|_ for example, if you have to load 5 frames, they must be named frame-number.png
-- 		|_ the function will load each frame into the memory like frame+_frameID+extension
-- - _frameNr: number of frames to load
--------------------------------------------------------
function animation:new( _id, _baseName, _frameNr)
	local tempHolder = { }
	tempHolder.frames = { }
	tempHolder.id = _id
	tempHolder.frameNr = _frameNr
	tempHolder.reset = true
	
	for i = 1, _frameNr do
		imageFrame = love.graphics.newImage("".._baseName..""..i..".png")
		table.insert(tempHolder.frames, imageFrame)		
	end
	table.insert(self.animationTable, tempHolder)
end

------------------------------------------------------
-- playAnimation: 
-- _id - id of the animation
-- _timePerFrame - for how much time do you want the
-- animation to be displayed
-- _posX, _posY: coordinates of the screen where the
-- animation should be displayed
-- The animation only plays once. To be used in conjunction
-- with getCurrentFrame() and getFrames()
------------------------------------------------------
function animation:playAnimation(_id, _timePerFrame, _posX, _posY, flip)
	if self.framePos < #self.animationTable[_id].frames then
		if love.timer.getMicroTime() > self.timer + _timePerFrame then
			self.framePos = self.framePos + 1
			self.timer = love.timer.getMicroTime()
		end
	end
	if flip == true then
		love.graphics.draw(self.animationTable[_id].frames[self.framePos],_posX, _posY,0,-1,1,self.animationTable[_id].frames[self.framePos]:getWidth(),0)	
	else
		love.graphics.draw(self.animationTable[_id].frames[self.framePos],_posX, _posY,0,1,1,0,0)		
	end		
end

function animation:setFrame(_id, frame)
	self.animationTable[_id].framePos = frame
end

function animation:getCurrentFrame(_id)
	return self.framePos
end

------------------------------------------------------
-- LoopAnimation: 
-- _id - id of the animation
-- _timePerFrame - for how much time do you want the
-- animation to be displayed
-- _posX, _posY: coordinates of the screen where the
-- animation should be displayed
-- NOTE: The animation loops as long time as the function
-- is called
------------------------------------------------------
function animation:loopAnimation(_id, _timePerFrame, _posX, _posY, flip)
	if self.framePos < #self.animationTable[_id].frames then
		if love.timer.getMicroTime() > self.timer + _timePerFrame then
			self.framePos = self.framePos + 1
			self.timer = love.timer.getMicroTime()
		end
	else
		self.framePos = 1				
	end	
	
	if flip == true then
		love.graphics.draw(self.animationTable[_id].frames[self.framePos],_posX, _posY,0,-1,1,self.animationTable[_id].frames[self.framePos]:getWidth(),0)	
	else
		love.graphics.draw(self.animationTable[_id].frames[self.framePos],_posX, _posY,0,1,1,0,0)		
	end

end

------------------------------------------------------
-- getFrames: return the total number of frames in
-- the animation.
------------------------------------------------------
function animation:getFrames(_id)
	return #self.animationTable[_id].frames
end
return animation