enemy = {}

animTimer = love.timer.getMicroTime( )
animTimerDelay = 1

bloodTimer = love.timer.getMicroTime( )
bloodTimerDelay = 0.1
bloodID = 1
deathID = 1
jDeathTimer = love.timer.getMicroTime()
function enemy:init(max_enemies)
	self.table = {}
	enemyNumber = max_enemies
end

function enemy:getMaxEnemies( )

	return enemyNumber

end

function enemy:getCurrentEnemies( )

	return #self.table

end

function enemy:dropBaddies( )
	self.table = { }
end

function enemy:removeFromTable( s )
	if soundOn == true then
		love.audio.play(snd.vampDeath)
	end

	table.remove(self.table,s)
	for i = 1, #self.table do
		self.table[i].s = i
	end
	hero.enemiesKilled = hero.enemiesKilled + 1
	eKillCounter = eKillCounter + 1

end

function enemy:playDeathAnimation()
	love.graphics.draw(dmg_anim[deathID],(hero.x - map.x)*32,(hero.y - map.y)*32)
	
	if deathID < 7 then
		if love.timer.getMicroTime() > jDeathTimer + 0.05 then
			deathID = deathID + 1
			jDeathTimer = love.timer.getMicroTime()		
			
		end
	else
		deathID = 1
		playerDeathAnim = false	
	end	
	

end

function BalanceEnemies( )

	if enemy:getCurrentEnemies( ) < 4 then
		enemy:spawnNewEnemy( )
		--enemy:spawnTier2Enemy( )
		
	end
	
	if eKillCounter >= 4 then
		enemy:spawnTier2Enemy( )
		eKillCounter = 0
	end

end

function enemy:spawnTier2Enemy( )
	local life = math.random(30,56)
	local temp_X = 0
	local temp_y = 0
	local totDistance = 0
	local temp = {
					x = 6,
					y = 6,
					s = #self.table+1,
					w = 32,
					h = 32,
					timer = 0,
					hp = life,
					initialHP = life,
					type = math.random(8,12),
					oldx = 0,
					oldy = 0,
					actionString = " ",
					name = "<"..FirstNames[math.random(1,#FirstNames)].." "..SecondNames[math.random(1,#SecondNames)]..">",
					AP = math.random(3,7),
					enemy_x = 0,
					enemy_y = 0,
					path = { },
					lenght = 0,
					noticedPlayer = false,
					hasSummons = false,
					bloodTimer = love.timer.getMicroTime(),
					bloodFrame = 1,
					takingDamage = false,
					isTagged = false,
					TaggImg = love.graphics.newImage("gfx/Stone.png"),
					tagCount = 0,
					tagRegeneration = math.random(2,4),
					bDeathAnim = false,
					deathTimer = love.timer.getMicroTime(),
					deathFrame = 1,
				}
	table.insert( self.table, temp )

		repeat	
			self.table[#self.table].over_hero = 1 -- flag that checks
			self.table[#self.table].x = math.random(1,map.width)
			self.table[#self.table].y = math.random(1,map.height)
			temp_X = self.table[#self.table].x
			temp_Y = self.table[#self.table].y
			totDistance = distanceToPlayer(hero.x, hero.y, temp_X, temp_Y)
			--v.x = 10
			--v.y = 10
			self.table[#self.table].check_walk = map.walk[map.data[self.table[#self.table].y][self.table[#self.table].x]]	-- check if mob landed over non-walkable land. --]]
			if self.table[#self.table].y ~= hero_y or self.table[#self.table].x ~= hero_x then self.table[#self.table].over_hero = 0 end	-- check if mob landed over hero.
		until totDistance > 20 and totDistance < 35 and self.table[#self.table].check_walk == 1 and self.table[#self.table].over_hero == 0	-- get out of loop when coords are good

end


function enemy:spawnNewEnemy( )
	local life = math.random(11,24)
	local temp_X = 0
	local temp_y = 0
	local totDistance = 0
	local temp = {
					x = 6,
					y = 6,
					s = #self.table+1,
					w = 32,
					h = 32,
					timer = 0,
					hp = life,
					initialHP = life,
					type = math.random(1,7),
					oldx = 0,
					oldy = 0,
					actionString = " ",
					name = "<"..FirstNames[math.random(1,#FirstNames)].." "..SecondNames[math.random(1,#SecondNames)]..">",
					AP = math.random(3,7),
					enemy_x = 0,
					enemy_y = 0,
					path = { },
					lenght = 0,
					noticedPlayer = false,
					hasSummons = false,
					bloodTimer = love.timer.getMicroTime(),
					bloodFrame = 1,
					takingDamage = false,
					isTagged = false,
					TaggImg = love.graphics.newImage("gfx/Stone.png"),
					tagCount = 0,	
					tagRegeneration = math.random(2,4),	
					bDeathAnim = false,
					deathTimer = love.timer.getMicroTime(),
					deathFrame = 1,			
				}
	table.insert( self.table, temp )

		repeat	
			self.table[#self.table].over_hero = 1 -- flag that checks
			self.table[#self.table].x = math.random(1,map.width)
			self.table[#self.table].y = math.random(1,map.height)
			temp_X = self.table[#self.table].x
			temp_Y = self.table[#self.table].y
			totDistance = distanceToPlayer(hero.x, hero.y, temp_X, temp_Y)
			--v.x = 10
			--v.y = 10
			self.table[#self.table].check_walk = map.walk[map.data[self.table[#self.table].y][self.table[#self.table].x]]	-- check if mob landed over non-walkable land. --]]
			if self.table[#self.table].y ~= hero_y or self.table[#self.table].x ~= hero_x then self.table[#self.table].over_hero = 0 end	-- check if mob landed over hero.
		until totDistance > 20 and totDistance < 35 and self.table[#self.table].check_walk == 1 and self.table[#self.table].over_hero == 0	-- get out of loop when coords are good
end --

function enemy:new( s )
	local life = math.random(11,24)
	local temp = {
					x = math.random( 1,5 ),
					y = math.random( 1, 5 ),
					s = #self.table+1,
					w = 32,
					h = 32,
					timer = 0,
					hp = life,
					initialHP = life,
					type = math.random(1,7),
					oldx = 0,
					oldy = 0,
					name = "<"..FirstNames[math.random(1,#FirstNames)].." "..SecondNames[math.random(1,#SecondNames)]..">",
					AP = math.random(3,7),
					enemy_x = 0,
					enemy_y = 0,
					path = { },
					lenght = 0,
					noticedPlayer = false,
					hasSummons = false,
					bloodTimer = love.timer.getMicroTime(),
					bloodFrame = 1,
					takingDamage = false,
					isTagged = false,
					TaggImg = love.graphics.newImage("gfx/Stone.png"),
					tagCount = 0,
					tagRegeneration = math.random(2,4),
					bDeathAnim = false,
					deathTimer = love.timer.getMicroTime(),
					deathFrame = 1,
				}
	table.insert( self.table, temp )
end

function enemy:setUp (  )
	for i,v in ipairs( self.table ) do
		repeat	
			v.over_hero = 1 -- flag that checks
			v.x = math.random(1,map.width)
			v.y = math.random(1,map.height)  
			--v.x = 10
			--v.y = 10
			v.check_walk = map.walk[map.data[v.y][v.x]]	-- check if mob landed over non-walkable land. --]]
			if v.y ~= hero_y or v.x ~= hero_x then v.over_hero = 0 end	-- check if mob landed over hero.
		until v.check_walk == 1 and v.over_hero == 0	-- get out of loop when coords are good

	end
end

function enemy:checkX(s)
	for i,v in ipairs ( self.table ) do
		if s == v.s then
			return v.x
		end
	end
end

function enemy:checkY(s)
	for i,v in ipairs ( self.table ) do
		if s == v.s then
			return v.y
		end
	end
end

function enemy:setX(s,x)
	for i, v in ipairs ( self.table ) do
		if s == v.s then
			v.x = x
		end
	end
end

function enemy:setY(s,y)
	for i, v in ipairs ( self.table ) do
		if s == v.s then
			v.y = y
		end
	end
end

function enemy:isAware( s )

	for i,v in ipairs ( self.table ) do
		if s == v.s then
			if v.noticedPlayer == true then
				return true
			else
				return false
			end
		end
	end

end

function enemy:setAwareness( s )
	for i,v in ipairs ( self.table ) do
		if s == v.s then
			v.noticedPlayer = true
		end
	end

end

function enemy:knockBack(s,dir)
	knockBackRandom = math.random(1,5)
	for i,v in ipairs (self.table) do
		if s == v.s then
			if v.hp > 0 then
				if knockBackRandom >= 3 then
					if dir == 3 then
						if map.collision[v.y][v.x-2] == 0 then
							v.x = v.x - 2
						elseif map.collision[v.y][v.x-1] == 0 then
							v.x = v.x - 1
						end
					elseif dir == 4 then
						if map.collision[v.y][v.x+2] == 0 then
							v.x = v.x + 2
						elseif map.collision[v.y][v.x+1] == 0 then
							v.x = v.x + 1
						end	
					end	
				end		
			end
		end	
	end

end

function avoidHotSpots( )



end

function enemy:alterHp( s, value )
	if self.table then
		for i,v in ipairs ( self.table ) do
			if s == v.s then
				if currentWeaponID == 4 and hero.hasShoot == true then
					v.isTagged = true
					miscEventBool = true
					miscEventString = ""..v.name.." was turned to stone."
					--map.collision[v.y][v.x] = 1
				end
				v.hp = v.hp-value 
				enemy:spillBlood( v.s, v.x, v.y )
			end
		end
	end
end

function enemy:drawLine( )

	for i,v in ipairs ( self.table ) do
		if v.type == 2 then
			love.graphics.line(v.x,v.y,hero.x,hero.y)
		end
	end


end

---------------------------------------------------------
--	ToDo: independent move
---------------------------------------------------------
function enemy:astarMove(s)

end
function enemy:getOldPosition( s )
	for i, v in ipairs ( self.table ) do
		if s == v.s then
			v.oldx = v.x
			v.oldy = v.y
		end
	end

end
function enemy:moveTowardsPlayer(s,path)
	local tableForPath = path
	for i, v in ipairs ( self.table ) do
		if s == v.s then
			--if v.AP > 4 then
				if v.hp > 0  and v.isTagged == false then
					--
					--for it = 1, #tableForPath do
						if tableForPath[i] ~= nil then

							if distanceToEnemy(hero.x, hero.y, v.x, v.y) <= 10 then
							--if tableForPath[i+1].x ~= hero.x and tableForPath[i+1].y ~= hero.y then
								v.x = tableForPath[i].x
								v.y = tableForPath[i].y

								bInsertEvent = true
								v.AP = v.AP - 4
								evEnemyString = ""..v.name.." draws closer."
							end
						end	
					--end								
					--end
				end	
			--end
		end
	end
	--evEnemyString = ""..v.name.." draws closer."
end

function enemy:moveTowardsPlayer2(s)
	
	for i, v in ipairs ( self.table ) do
		if s == v.s then
			if v.hp > 0 and v.isTagged == false--[[and v.AP >= 4--]] then
				v.path, v.lenght = pather:getPath(enemy:checkX(i),  enemy:checkY(i), hero.x,hero.y)
				if v.path[i] ~= nil then
					--if distanceToEnemy(hero.x, hero.y, v.x, v.y) <= 10 then
						-- Tweening x = x + (target -x) *0.1
						v.x = v.path[i].x
						v.y = v.path[i].y
						--if distanceToPlayer(v.x, v.y, hero.x, hero.y) <= 5 then
														
						--end
					--end
				end	

			end	
		end
	end
end

function enemy:positionCorrectly( s )

	for i,v in ipairs ( self.table ) do
		if s == v.s then
			if v.hp > 0 then
				if v.x == hero.x and v.y == hero.y then
					v.x = v.oldx
					v.y = v.oldy
				end	
			end
		end
	end
	
end
	--[[local tableForPath = path
	for i, v in ipairs ( self.table ) do
		if s == v.s then
			if v.hp > 0 then
				for it = 1, #tableForPath do
					if tableForPath[i+1] ~= nil then
						--if tableForPath[i+1].x ~= hero.x and tableForPath[i+1].y ~= hero.y then
							v.x = tableForPath[i].x
							v.y = tableForPath[i].y
						--end	
					end			
				end				
			end
		end
	end--]]


function enemy:debugPathTowardsPlayer(s, path)
	local tableForPath = path
	--[[for i,v in ipairs ( self.table ) do
		if s == v.s then
			if v.hp > 0 and path then
				if tableForPath ~= nill then
					love.graphics.line(tableForPath[i].x, tableForPath[i].y, tableForPath[i+1].x, tableForPath[i+1].y)
				end
			end
		end
	end--]]
	for i = 1, #tableForPath do
		if tableForPath[i+1] ~= nil then
			love.graphics.line((tableForPath[i].x - map.x)*32, ( tableForPath[i].y - map.y)*32, (tableForPath[i+1].x - map.x)*32, (tableForPath[i+1].y - map.y)*32)
		end
	
	end

end

function enemy:move(s)
	mvRandom = math.random(1,4)
	for i,v in ipairs ( self.table ) do
		if s == v.s then	
			if v.hp > 0 and v.isTagged == false then
				if mvRandom == 1 then
					if map.walk[map.data[v.y][v.x+1]] == 1 then			
						v.x = v.x + 1
					end
				elseif mvRandom == 2 then
					if map.walk[map.data[v.y+1][v.x]] == 1 then	
						v.y = v.y + 1
					end
				elseif mvRandom == 3 then
					if map.walk[map.data[v.y][v.x-1]] == 1 then	
						v.x = v.x - 1
					end
				elseif mvRandom == 4 then
					if map.walk[map.data[v.y-1][v.x]] == 1 then	
						v.y = v.y - 1
					end			
				end
			end
			if v.x == hero.x and v.y == hero.y then
				hero.hp = hero.hp - 1 
			end
			
		end
	end

end

function enemy:getHp( s )
	for i,v in ipairs ( self.table ) do
		if s == v.s then
			return v.hp
		end
	end
end

function enemy:isDead( s )

	for i,v in ipairs( self.table ) do
		if s == v.s then
			if v.hp <= 0 then
				--bInsertEvent = true
				--pMovementString = ""..v.name.." has died. " --pMovementString because isDead is checked on the player's turn.
				enemy:removeFromTable( s )				
				-- Debug only. I'll remove them from the table later on :)
			end		
		end
	end 

end

function enemy:update()
	-- make burgers! Burgers are good.
	BalanceEnemies( )
	actionsDuringEnemyTurn ( )
	 enemy:checkTagg( )

end

function enemy:checkTagg( )

	for i,v in ipairs ( self.table ) do
	
		if v.isTagged == true then
			v.tagCount = v.tagCount + 1
		end
		
		if v.tagCount >= v.tagRegeneration then
			regenCheck = math.random(1,10)
			if regenCheck >= 7 then --- MAYBE LOWER IT LATER! FOR NOW IT SEEMS TO BE OK
				v.tagCount = 0
				v.isTagged = false
				v.tagRegeneration = math.random(2,4)
				miscEventBool = true
				miscEventString = ""..v.name.." is back to normal. He seems angry"
			end
			--map.collision[v.y][v.x] = 0
		end
	
	
	end

end


function enemy:retrieveBatTypesID( )


end

function enemy:loopAnims( )

	if love.timer.getMicroTime() > animTimer + 0.05 then
		if batImageLoop < 10 then
			batImageLoop = batImageLoop + 1
		else
			batImageLoop = 1
		end
		animTimer = love.timer.getMicroTime()
	end


end


function enemy:draw(lx,ly)

	for i,v in ipairs( self.table ) do
     	--if v.x == zx and v.y == zy then
     		love.graphics.setColor(255,255,255)
			--for ey=1, map.camera_height do		-- loop #1 (y-axis) 
	     		 --for ex=1, map.camera_width do
					if (v.x == lx) and (v.y == ly) then
		     		 	--if (ex+map.x == v.x) and (ey+map.y == v.y) then
		     		 	
		     		 	-- Tweening x = x + (target -x) *0.1
		     		 		--v.enemy_x = v.x + (v.x - v.oldx) * 0.1
		     		 		--v.enemy_y = v.y + (v.y - v.oldy) * 0.1
		     		 		if v.hp > v.initialHP then v.hp = v.initialHP end ----- Quick hack to keep enemy T2 vamps at max health.
		     		 		
		     		 			if v.isTagged == false then
				     		 		if v.x < hero.x then
										--love.graphics.draw(tile.mob[v.type], (ex*tile.w) - tile.w + map.camera_offset_x, (ey*tile.h) - tile.h + map.camera_offset_y)
										if v.type >= 8 and v.type <= 12 and distance2enemy(i) > 3 then
											love.graphics.draw(bat_anim[batImageLoop],(v.x - map.x) *32, (v.y - map.y) *32)
										else
											love.graphics.draw(tile.mob[v.type],(v.x - map.x) *32, (v.y - map.y) *32)
										end
									else
										if v.type >= 8 and v.type <= 12 and distance2enemy(i) > 3 then
											love.graphics.draw(bat_anim[batImageLoop],(v.x - map.x) *32, (v.y - map.y) *32,0,-1,1,32,0)
										else
										--love.graphics.draw(tile.mob[v.type], (ex*tile.w) - tile.w + map.camera_offset_x, (ey*tile.h) - tile.h + map.camera_offset_y,0,-1,1,32,0)	
											love.graphics.draw(tile.mob[v.type],(v.x - map.x) *32, (v.y - map.y) *32,0,-1,1,32,0)
										end
									end
								else
								
									love.graphics.draw(v.TaggImg,(v.x - map.x) *32, (v.y - map.y) *32,0,-1,1,32,0)
									
								end
							local scaleFactor = 1 - ( (100 - ( (100 * v.hp) / v.initialHP ) ) / 100 )
							love.graphics.draw(hb_background, (v.x - map.x) * 32, (v.y - map.y) * 32 - 5)
							love.graphics.draw(hb_foreground, (v.x - map.x) * 32, (v.y - map.y)  * 32 - 5, 0, scaleFactor  ,1)
							--love.graphics.print(""..v.s.."", (v.x - map.x) * 32, (v.y - map.y) * 32 )
							if v.takingDamage == true then 
								enemy:spillBlood( v.s, (v.x - map.x) * 32, (v.y - map.y) * 32 )
							end
							
						--end
					end
				--end
			--end
			

		--end
	
	--love.graphics.print(""..v.hp.."",(v.x - map.x) * 32 + 14, (v.y - map.y)  * 32 - 5)
	end	 -- end for inpairs

end

function enemy:drawNames( )

	for i,v in ipairs( self.table ) do
		love.graphics.print(""..v.name.."",(v.x - map.x) * 32 - string.len(v.name)*2.5, (v.y - map.y)  * 32 - 25)
	end

end

function enemy:attackPlayer( s )
	
		if self.table[s].isTagged == false then
			if self.table[s].type >= 1 and self.table[s].type <= 7  then
				dmgPlayer = math.random(2,8)
				hero.hp = hero.hp - dmgPlayer
				bInsertEvent = true
				evEnemyString = ""..self.table[s].name.." dealt "..dmgPlayer.." damage to you. "..self.table[s].name.." grins.".."Pos X: "..self.table[s].x.." Pos Y:"..self.table[s].y..""
				hero.killed_by = ""..self.table[s].name..""
				if hero.hp < 0 then hero.hp = 0 end
				
				if soundOn == true then
					love.audio.play(snd.playerHit)
				end
				
				deathID = 1
				playerDeathAnim = true
				
			elseif self.table[s].type >= 8 and self.table[s].type <= 12  then
				
				dmgPlayer = math.random(5,10)
				hero.hp = hero.hp - dmgPlayer
				bInsertEvent = true
				love.graphics.setColor(200,50,50)
				evEnemyString = ""..self.table[s].name.." has drained "..dmgPlayer.." life from the player."
				hero.killed_by = ""..self.table[s].name..""
				self.table[s].hp = self.table[s].hp + dmgPlayer-math.random(1,4)
				if hero.hp < 0 then hero.hp = 0 end	
				if soundOn == true then
					love.audio.play(snd.playerHit)		
				end
				deathID = 1
				playerDeathAnim = true
			end
		end
end

function enemy:spillBlood( s, pos__x, pos__y )

	--if love.timer.getMicroTime() > bloodTimer + 0.1 then
		love.graphics.draw(bloodP[self.table[s].bloodFrame],pos__x, pos__y)

			
		if  self.table[s].bloodFrame < 5 then
			if love.timer.getMicroTime() > self.table[s].bloodTimer + 0.25 then
				self.table[s].bloodFrame = self.table[s].bloodFrame + 1
				self.table[s].bloodTimer = love.timer.getMicroTime() 
			end
			
		else
			self.table[s].bloodFrame = 1
			self.table[s].takingDamage = false
		end

		

	--end

end

function setupEnemies( )
	enemy:init(8)
	for i = 1, enemy:getMaxEnemies() do
		enemy:new(i)
	end
	enemy:setUp ( )
end

function enemy:updateAP( )
	
	for i,v in ipairs ( self.table ) do
		if v.hp > 0 then
			v.AP = v.AP + 2
		end
	end

end
--[[postAttackActions = { 
" grins.",
" winks at "..FirstNames[math.random(1,#FirstNames)].." "..SecondNames[math.random(1,#SecondNames)]..".",
}

To Do: Split into more more strings, so concatenation is possible
--]]




FirstNames = { "Circe", 
"Anton",
"Aubrey",
"Cesar",
"Charity", 
"Christine", 
"Circe",
"Dante",
"Emmanuel",
"Enoch", 
"Evangeline", 
"Hope",
"Joseph",
"Kraig",  
"Kristopher",  
"Luciano",  
"Lucius",  
"Nathaniel",
"Nichole", 
"Pollux", 
"Raphael",
"Romulus",
"Vana",
"Ona",
"Costine",
"Fleturis",
"Tina",
"Seras",
"Integra",
"Andosan",
"Bob",
"Victorria",
"Salamy",
"Hanzel",

}

SecondNames = {
"Blackblade",
"Cruelblood",
"Cruelchain",
"Cryptgrief",
"Darkdragon",
"Devildragon",
"Devilwolf",
"Duskblade",
"Evilsmoke",
"Farsinner",
"Fatevenom",
"Grimbeast",
"Grimdragon",
"Helldirge",
"Iceblade",
"Icedamn",
"Shadowblade",
"Shadowwoe",
"Steelbrood",
"Steelstorm",
"Twistmist",
"Venomfate",
"Venomheart",
"Warcairn",
"Wildstorm",
"Moses",
"Florence",
"Hellsing",
"Donnet",
"Bernadette",
"Crimson",
"Fogripper",
"Le Mort",
"Fangy",
"Longshadow",
"Griefstrike",
"Bartholomew",
"Dhampir",
"Asscariot",
"PamaMia",
"Calinescu",
" ",
" ",
" ",

}


return enemy