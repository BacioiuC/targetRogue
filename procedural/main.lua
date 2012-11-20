map = {}
map.data = { }
mapTilesX = 22
mapTilesY = 30

tile = {}
tile.h = 32
tile.w = 32

builder = { }
builderSpawned = 0
builderMoveDirection = 0
allocatedBlocks = 0 --variable used to track the percentage of the map filled
rootX = 8
rootY = 8 --this is where the growth starts from. Currently center of map
stepped = 0 --this is how long corridors can be
orthogonalAllowed = 0 --Orthogonal movement allowed? If not, it carves a wider cooridor on diagonal
cx = 0
cy = 0



function buildPath( )
	
	while allocatedBlocks < 280 do --quit when an eighth of the map is filled
		if builderSpawned ~= 1 then

			cx = math.random(2,mapTilesX-1)
			cy = math.random(2,mapTilesY-1)
			
			if rootX - cx <= 0 and rootY - cy <= 0 then
				if map.data[cy][cx] ~= 1 then
					map.data[cy][cx] = 1
					allocatedBlocks = allocatedBlocks + 1
				end
			else
				builderSpawned = 1
				builderMoveDirection = math.random(1,8)
				stepped = 0 
			end
		
		else --love.graphics.print("BuilderSpanwed == 1",0,0)
			--map.data[math.random(1,16)][math.random(1,16)] = 1
			--builderMoveDirection = math.random(1,4)
			if builderMoveDirection == 1 and cy > 1 then
				cy = cy - 1
				stepped = stepped + 1
			elseif builderMoveDirection == 2 and cx > 1 then
				cx = cx - 1
				stepped = stepped + 1
			elseif builderMoveDirection == 3 and cy < mapTilesY-1 then
				cy = cy + 1
				stepped = stepped + 1
			elseif builderMoveDirection == 4 and cx < mapTilesX-1 then
				cx = cx + 1
				stepped = stepped + 1
			elseif builderMoveDirection == 5 and cx < mapTilesX-1 and cy > 1 then
				cy = cy - 1
				cx = cx + 1
				stepped = stepped + 1
			elseif builderMoveDirection == 6 and cx < mapTilesX and cy < mapTilesY-1 then
				cy = cy + 1
				cx = cx + 1
				stepped = stepped + 1
			elseif builderMoveDirection == 7 and cx > 1 and cy < mapTilesY-1 then
				cy = cy + 1
				cx = cx - 1
				stepped = stepped + 1
			elseif builderMoveDirection == 8 and cx > 1 and cy >1 then
				cx = cx - 1
				cy = cy - 1
				stepped = stepped + 1
			end
			
			
			--if (cx<size && cy<size && cx>1 && cy>1 && stepped<=5){
			if cx < mapTilesX-1 and cy < mapTilesY-1 and cx > 2 and cy > 2 then
				
				--if (map.data[cx+1][cy]==1  ){if (map.data[cx][cy]!=1){map.data[cx][cy]=1;allocatedBlocks++;}
				if map.data[cy][cx+1] == 1 then
					if map.data[cy][cx] ~= 1 then
						map.data[cy][cx] = 1
						allocatedBlocks = allocatedBlocks + 1
					end
				--/* West      */ } else if (map.data[cx-1][cy]==1  ){if (map.data[cx][cy]!=1){map.data[cx][cy]=1;allocatedBlocks++;} 
				elseif map.data[cy][cx-1] == 1 then
					if map.data[cy][cx]~= 1 then
						map.data[cy][cx] = 1
						allocatedBlocks = allocatedBlocks + 1
					end
				--/* South     */ } else if (map.data[cx][cy+1]==1  ){if (map.data[cx][cy]!=1){map.data[cx][cy]=1;allocatedBlocks++;}
				elseif map.data[cy+1][cx]==1 then
					if map.data[cy][cx] ~= 1 then
						map.data[cy][cx] = 1
						allocatedBlocks = allocatedBlocks + 1
					end
				--/* North     */ } else if (map.data[cx][cy-1]==1  ){if (map.data[cx][cy]!=1){map.data[cx][cy]=1;allocatedBlocks++;}
				elseif map.data[cy-1][cx]==1 then
					if map.data[cy][cx]~=1 then
						map.data[cy][cx]=1
						allocatedBlocks = allocatedBlocks + 1
					end

				--/* Northeast */ } else if (map.data[cx+1][cy-1]==1){if (map.data[cx][cy]!=1){map.data[cx][cy]=1;allocatedBlocks++;
				elseif map.data[cy-1][cx+1] == 1 then
					if map.data[cy][cx]~= 1 then
						map.data[cy][cx] = 1
						allocatedBlocks = allocatedBlocks + 1
					end
				--/* Southeast */ } else if (map.data[cx+1][cy+1]==1){if (map.data[cx][cy]!=1){map.data[cx][cy]=1;allocatedBlocks++;	
				elseif map.data[cy+1][cx+1] == 1 then
					if map.data[cy][cx] ~= 1 then
						map.data[cy][cx] = 1 
						allocatedBlocks = allocatedBlocks + 1
					end
				--/* Southwest */ } else if (map.data[cx-1][cy+1]==1){if (map.data[cx][cy]!=1){map.data[cx][cy]=1;allocatedBlocks++; 
				elseif map.data[cy+1][cx-1] == 1 then
					if map.data[cy][cx] ~= 1 then
						map.data[cy][cx] = 1
						allocatedBlocks = allocatedBlocks + 1
					end
				--/* Northwest */ } else if (map.data[cx-1][cy-1]==1){if (map.data[cx][cy]!=1){map.data[cx][cy]=1;allocatedBlocks++;
				elseif map.data[cy-1][cx-1] == 1 then
					if map.data[cy][cx] ~= 1 then
						map.data[cy][cx] = 1
						allocatedBlocks = allocatedBlocks + 1
					end
				end
			
			else
				builderSpawned = 0
			end
			--map.data[cy][cx] = 1
			love.graphics.print("IN DA ELSE",0,0)
			--allocatedBlocks = allocatedBlocks + 1
		end
	
	
	
	end


end


function love.load()
	math.randomseed(os.time())
	math.random()
	math.random()
	math.random()	
	
	
	ceiling = love.graphics.newImage("tile1.png")
	floor = love.graphics.newImage("tile2.png")
	wall = love.graphics.newImage("tile3.png")
	generateEmptyMap ( )
	
	
	
end


function love.draw()
	love.graphics.print("Builders Spawned "..builderSpawned,0,0)
	love.graphics.print("allocatedBlocks: "..allocatedBlocks,0,20)
	for i = 1, mapTilesY do
		for j = 1, mapTilesX do
			if map.data[i][j] == 0 then
				love.graphics.draw(ceiling,i*tile.w,j*tile.h)
			elseif map.data[i][j] == 1 then
				love.graphics.draw(floor,i*tile.w,j*tile.h)
			elseif map.data[i][j] == 2 then
				love.graphics.draw(wall,i*tile.w,j*tile.h)
			end
		end
	end
	
	onKeyPressed( )
end


function love.update()
	

end

function onKeyPressed( )
	function love.keypressed(key)
		if key == " " then
			allocatedBlocks = 0
			resetMap ( )
			buildPath( )
			
			--map.data[math.random(1,12)][math.random(1,12)] = 0
		end
		
		if key == "lshift" then
			cleanMap( )
		end
	
	end

end

function generateEmptyMap ( )
	for i = 1, mapTilesY do 
		map.data[i] = {}
		for j = 1, mapTilesX do
			map.data[i][j] = 0--math.random(1,5)--
		end
	end
end

function cleanMap( )
	for i = 2, mapTilesY-2 do
		for j = 2, mapTilesX-2 do
			if map.data[i][j+1] ~= nil then
				if map.data[i][j] == 1 and map.data[i][j+1] == 0 then
					map.data[i][j+1] = 2
				end
			end
			if map.data[i][j-1] ~= nil then
				if map.data[i][j] == 1 and map.data[i][j-1] == 0 then
					map.data[i][j-1] = 2
				end
			end
		end
	end


end

function resetMap ( )
	for i = 1, mapTilesY do 
			for j = 1, mapTilesX do
			map.data[i][j] = 0--math.random(1,5)--
		end
	end
end
