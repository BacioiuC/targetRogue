
function setupMap()

	map.width = mapTilesX											-- Map Size Width (X Axis)
	map.height = mapTilesY											-- Map Size Height (Y Axis)
	map.x = 0														-- Reset Current X Map Position
	map.y = 0														-- Reset Current Y Map Position
	map.camera_offset_x = 32										-- Pseudo-Camera Window Desired PX Offset (X) -Put 0 to move it to left of the window-
	map.camera_offset_y = 32										-- Pseudo-Camera Window Desired PX Offset (Y) -Put 0 to move it to top of the window- 		
	map.camera_width = 16	  										-- Pseudo-Camera Window Size in Tiles - Width (X Axis)
	map.camera_height = 12  										-- Pseudo_Camera Window Size in Tiles - Height (Y Axis)
	map.camera_mid_x = math.floor (map.camera_width / 2) + 1 		-- Center of Pseudo-Camera display in Tiles (X Axis)
	map.camera_mid_y = math.floor (map.camera_height / 2) + 1 		-- Center of Pseudo-Camera display in Tiles (Y Axis)  	
	map.center_x = 0												-- Virtual Center of Pseudo-Camera in px (X Axis) -used to center Hero-
	map.center_y = 0												-- Virtual Center of Pseudo-Camera in px (Y Axis) -used to center Hero- 
	--randomize()
    
end -- end function --



-----------------------------------------------------------------------------
function generateEmptyMap ( )
	for i = 1, mapTilesY do 
		map.data[i] = {}
		for j = 1, mapTilesX do
			map.data[i][j] = 1--math.random(1,5)--
		end
	end
end

function generateExploreMap ( )
	for i = 1, mapTilesY do 
		map.explore[i] = {}
		for j = 1, mapTilesX do
			map.explore[i][j] = 0--math.random(1,5)--
		end
	end
end

function generateEmptyCollisionMap ( )
	for i = 1, mapTilesY do
		map.collision[i] = { }
		for j = 1, mapTilesX do
			map.collision[i][j] = 1
		end
	end
end

--------------------------------------------------------------------------------
-- Parse entity table and retrieve number of entities @@@@@@
-------------------------------------------------------------

function getNumberOfEntities( )

	

end


function setupLayer_LOW()

	generateEmptyMap ( )
	
	map.walk={ 
		1,0,0,0,0,0,1,1,0,1,1,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0 -- 1 = walkable map, 0 = interdit tile map -TO DO- convert to Boolean
	}
	
	
	table_string = love.filesystem.load("map1.ftj")
	collision_map = love.filesystem.load("map1.col")
	map.data = table_string()
	map.collision = collision_map()
  
end -- end function --

-----------------------------------------------------------------------------

function setupLayer_MID ()	-- setup of above ground elements
   
    -- empty for now since no objects are used yet!
   
end -- end function --

-----------------------------------------------------------------------------

function setupLayer_HI ()	-- setup  of above the head elements
  
    -- empty for now since no roof/high trees elements are used yet!

end

function dist2d(x1,y1, x2,y2)
	return ((x2-x1)^2+(y2-y1)^2)^0.5
end

function draw_map()
	local ww, hh = (visW+1)/2, (visH+1)/2

 	
  for y=1, map.camera_height do		 
		for x=1, map.camera_width do	
  
      	love.graphics.setColor(90,90,90)

			if map.data[y+map.y][x+map.x] ~= 9 then
			         love.graphics.draw(
			            tile.layer_low[map.data[y+map.y][x+map.x]], 
			            (x*tile.w) - tile.w + map.camera_offset_x, 
			            (y*tile.h) - tile.h + map.camera_offset_y)
			end

      end	
   end		


    
  	if octans then
		for i,v in ipairs(octans) do
			if distanceToEnemy(hero.x, hero.y, v.x, v.y) < 2 then
				love.graphics.setColor(255,255,255)
			elseif distanceToEnemy(hero.x, hero.y, v.x, v.y) < 4 then
				love.graphics.setColor(225,225,225)
			elseif distanceToEnemy(hero.x, hero.y, v.x, v.y) < 6 then
				love.graphics.setColor(190,190,190)
			else
				love.graphics.setColor(155,155,155)
			end
			
			if v.y < map.camera_height+map.y then				
				love.graphics.draw(tile.layer_low[map.data[v.y][v.x]],(v.x-map.x)*32, (v.y-map.y)*32)
				enemy:draw(v.x,v.y)	
			end
			love.graphics.draw(tile.layer_low[map.data[hero.y][hero.x]],(hero.x-map.x)*32,(hero.y-map.y)*32)
			
		end
		
		
	end	    
	
	
	love.graphics.print("HP: "..hero.hp,0,0)
    drawMuzzle( )  
      
    for y=1, map.camera_height do	 
		for x=1, map.camera_width do
			player_renderx = (x*tile.w) - tile.w + 16 + map.camera_offset_x
			player_rendery = (y*tile.h) - tile.h + 16 + map.camera_offset_y

			if (x+map.x == hero.x) and (y+map.y == hero.y) then 
				if ORIENTATION == 4 then
					love.graphics.draw( tile.hero, player_renderx,  player_rendery, 0,1,1,16,16)
					sx = 1
					offset = 0
				elseif ORIENTATION == 3 then
					love.graphics.draw( tile.heroLeft, player_renderx,  player_rendery, 0,1,1,16,16)
					sx = -1
					offset = 32
				end
				
				love.graphics.draw(WeaponDraw,(hero.x-map.x)*32,(hero.y-map.y)*32,0,sx,1,offset,0)
				drawPlayerHealthBar( )				
				
			end  
		end
	end
	
	if playerDeathAnim == true then enemy:playDeathAnimation() end
	
	

end -- end function --
