require("init")
require("map")
require("math")
require("baddies")
require("fov")
require("TLfres")
require("event_log")
require("weapons")
local Jumper = require('lib.jumper.init')

--[[
Portions of code in this project are borrowed from the following projects:
- https://love2d.org/forums/viewtopic.php?f=5&t=1942 ~ by arquivista
- a implementation of the roguebasin's shadowcasting algorithm, posted in the Love2D
forums. 
--]]
-----------------------------------------------------------------------------
-- INITIALZING VARS
-----------------------------------------------------------------------------
mapTilesX = 64 -- width of the map
mapTilesY = 64 -- height of the map

visW, visH, fs = 49, 31, 16

lPosVarX = 0
lPosVarY = 0
soundOn = true
function love.load()
	
	game_state = "nullState"	-- don't draw/do/input nothing in this mode
	ext_move = true				-- flag to enable diagonal movement

	-- initializing arrays

	window = {}
	tile = {} 
	snd = {}  
	record = {}      
	map = {}
	map.data= {}
	map.collision = {}
	map.explore = {}
	hero = {}
	mob = {}   
	bat_anim = { }
	bloodP = { }
	dmg_anim = { }
	death_anim = { }
	muzzle_anim = { }
	muzzle_timer = love.timer.getMicroTime()
	muzzleFrame = 1
	--path table. we store enemy routes in here
	tbpath = { }
	
	tableJumper = { }

	-- Enemies and all
	entities = { }
	
	-- load resources
	setupGFX()				-- Load Image Resources   
	setupSFX()				-- Load Sound Resources      
	-- vars to init once (records)
	record.hero_kills = 0	-- keeps best number of enemies killed in a single game
	record.hero_xp = 0		-- keeps highest XP reached in a single game
	record.hero_lvl = 1		-- keeps highest Level reached in a single game
	ORIENTATION = 3   
    tRotation = 0			-- initial player rotation
	-- prepare map and mob data
	setupMap()				-- General Map Data Setup
	setupLayer_LOW()		-- Low Map Layer (Ground) Setup
	setupLayer_MID()		-- Mid Map Layer (Objects) Setup	-- NOT YET IMPLEMENTED --
	setupLayer_HI()			-- Hi  Map Layer (Roofs...) Setup	-- NOT YET IMPLEMENTED --
	setupEnemies( )				-- Load base enemy data     
	setupJumper( )
	testingJumper = false
	
	initWindow()			-- OS/Window Setup 
	-- Do sequence of pre-game resets and go to intro
	restartGame() 
	game_state = "introState"  
	
	muzzleTimer = love.timer.getMicroTime()
	love.mouse.setVisible(true)
	playerTurn = true
	currentWeaponID = 1 --the pistol | 2 - rifle | 3 - shotgun | 4 - unnamed
	scaleIt = false
	love.mouse.setPosition( window.size_x/4, window.size_y/4 )
	
	------------------------
	miscEventString = ""
	miscEventBool = false
	

	
end -- end function --

function setupJumper( )

 	pather = Jumper(map.collision, 0, false)
 
 end
 
 function handleMiscEvents( )
 	if miscEventBool == true then
 		insertEvent(miscEventString)
 		miscEventBool = false
 	end 
 end
 
function performMovement( dapath )
	--[[if path then
		--success = love.filesystem.write("jumper.astar", "return"..table.tostring( tableJumper ))
			--for i = 1, #tableJumper do
				--love.graphics.print("Value X: "..tableJumper[i].x.." Value Y: "..tableJumper[i].y.."",0,64+i*20)
				return tableJumper[currentStep+1].x, tableJumper[currentStep+1].y
			--end
	end--]]
end

function setupGFX()

	tile.w = 32	-- Tile Size Width (X Axis)
	tile.h = 32	-- Tile Size Height (Y Axis)    
	
	tile.hero = love.graphics.newImage( "gfx/fighter.png" ) -- Load Hero Tile
	tile.hero:setFilter( "nearest", "nearest")
	tile.heroLeft = love.graphics.newImage( "gfx/fighter_left.png" ) -- Load Hero Tile
	tile.heroLeft:setFilter( "nearest", "nearest")
	tile.pointer = love.graphics.newImage( "gfx/laser_pointer.png") -- load the laser pointer
	tile.pointer:setFilter( "nearest", "nearest")
	
	tile.layer_low = {}
	
	for i=1,50 do -- Load Map Tiles
		tile.layer_low[i] = love.graphics.newImage( "gfx/tile"..i..".png" )
		tile.layer_low[i]:setFilter( "nearest", "nearest")
	end
	
	tile.mob = {}
	
	for i=1,12 do -- Load Mob Tiles
		tile.mob[i] = love.graphics.newImage( "gfx/mob"..i..".png" )
		tile.mob[i]:setFilter( "nearest", "nearest")
	end	
	-- load healthbar graphics.
	hb_background = love.graphics.newImage("gfx/healthBar_background.png")
	hb_foreground = love.graphics.newImage("gfx/healthBar_front.png")
	
	
	for i = 1, 15 do
		muzzle_anim[i] = love.graphics.newImage("gfx/muzzle-"..i..".png")
		muzzle_anim[i]:setFilter( "nearest", "nearest")
	end
	mStartFrame = 1
	mEndFrame = 4
	muzzleDuration = 0.05
	
	
	light_tile = love.graphics.newImage("gfx/light_tile.png")
	
	log_background = love.graphics.newImage("gfx/PvsP_Menu_Lowerbar.png")
	log_background:setFilter( "nearest", "nearest")
	top_bar = love.graphics.newImage("gfx/PvsP_Menu_Higherbar.png")
	top_bar:setFilter( "nearest", "nearest")
	cross_hair = love.graphics.newImage("gfx/aim_icon.png")
	cross_hair:setFilter( "nearest", "nearest")
	
	weapon_slot = love.graphics.newImage("gfx/weapon_slot.png")
	weapon_slot:setFilter( "nearest", "nearest")
	weapon_slot_activated = love.graphics.newImage("gfx/weapon_slot_activated.png")
	weapon_slot_activated:setFilter( "nearest", "nearest")
	
	--temp_bat = love.graphics.newImage("gfx/mob13.png")
	--temp_bat:setFilter( "nearest", "nearest")
	for i = 1, 10 do
		bat_anim[i] = love.graphics.newImage( "gfx/batmode-"..i..".png" )
		bat_anim[i]:setFilter( "nearest", "nearest")
	end
	menu_background = love.graphics.newImage("gfx/menu_background.png")
	batImageLoop = 1
	
	for i = 1, 5 do
		death_anim[i] = love.graphics.newImage("gfx/death_anim"..i..".png")
		death_anim[i]:setFilter("nearest", "nearest")	
	end
	
	----------------------------
	-- GUN Sprites and GunVariable
	----------------------------
	
	weapons:initSystem()
	weapons:newWeapon(1,"Pistol",5,7,4,"gfx/pistol.png")
	weapons:newWeapon(2,"Rifle",8,14,8,"gfx/rifle.png")
	weapons:newWeapon(3,"shotgun",12,15,8,"gfx/shotgun.png")
	weapons:newWeapon(4,"FreezeGun",1,2,10,"gfx/shutweapon.png")
	
	WeaponDraw = weapons:returnImage(1)

	
	-------------------------------------------------------
	-- Blood particles
	-- ----------------------------------------------------
	
	for i = 1, 5 do
		bloodP[i] = love.graphics.newImage("gfx/Blood"..i..".png")
		bloodP[i]:setFilter( "nearest", "nearest")
	end
	----------------------------
	-- Enemy Kill counter. It increments when an enemy dies
	-- we use it to spawn more powerful bitches!
	-- -------------------------
	eKillCounter = 0
	
	
	------------------------
	-- HEALTH PACKS :: aka, "PILLS!!!!!!!"
	-----------------------
	
	pills = love.graphics.newImage("gfx/pills.png")
	
	
	------------------------
	--- UserInterface Weapons
	-------------------------
	uiPistol1 = love.graphics.newImage("gfx/uiPistol1.png")
	uiPistol2 = love.graphics.newImage("gfx/uiPistol2.png")
    	
    uiRifle1 = love.graphics.newImage("gfx/uiRifle1.png")
	uiRifle2 = love.graphics.newImage("gfx/uiRifle2.png")
	
    uiShotgun1 = love.graphics.newImage("gfx/uiShotgun1.png")
	uiShotgun2 = love.graphics.newImage("gfx/uiShotgun2.png")
	
    uiFreeze1 = love.graphics.newImage("gfx/uiFreeze1.png")
	uiFreeze2 = love.graphics.newImage("gfx/uiFreeze2.png")	
	
	
	--------------------------
	-- PLAYER Damage animation
	--------------------------
	--[[damagePlayer1.png--]]
	for i = 1, 7 do
		dmg_anim[i] = love.graphics.newImage("gfx/damagePlayer"..i..".png")
	end
	
	
	PvsV_Button_Sound = love.graphics.newImage("gfx/PvsV_Button_Sound.png")
	tPvsV_Button_Sound = love.graphics.newImage("gfx/PvsV_Button_Sound_Off.png")
	
	PvsV_Button_Play = love.graphics.newImage("gfx/PvsV_Button_Play.png")
	PvsV_Button_Credits = love.graphics.newImage("gfx/PvsV_Button_Credits.png")
	PvsV_Button_Quit = love.graphics.newImage("gfx/PvsV_Button_Quit.png")
	
	Pimps_Background_Dead = love.graphics.newImage("gfx/Pimps_Background_Dead.png")
	PvsP_Menu_Credits = love.graphics.newImage("gfx/PvsP_Menu_Credits.png")
end -- end function --


-----------------------------------------------------------------------------

function setupSFX()	-- Load Sounds


	snd.hit = love.audio.newSource("sfx/hit.ogg")
	snd.track = love.audio.newSource("sfx/grundy_pimpsvsvamp_theme.ogg")	
	snd.track:setLooping(true)
	--love.audio.play(snd.track)
	
	snd.pistol = love.audio.newSource("sfx/PvsV_AFX_Pistol.ogg","static")
	snd.rifle = love.audio.newSource("sfx/PvsV_AFX_Rifle.ogg","static")
	snd.shotgun = love.audio.newSource("sfx/PvsV_AFX_Shotgun.ogg","static")
	snd.freeze = love.audio.newSource("sfx/PvsV_AFX_Freezeray.ogg","static")
	
	snd.playerHit = love.audio.newSource("sfx/PvsV_AFX_PlayerHit.ogg","static")
	snd.playerWalk = love.audio.newSource("sfx/PvsV_AFX_PlayerWalk.ogg","static")
	
	snd.vampDeath = love.audio.newSource("sfx/PvsV_AFX_VampDeath.ogg","static")

end -- end function --

-----------------------------------------------------------------------------


-----------------------------------------------------------------------------

function restartGame()
	--love.mouse.setPosition( 2, 2 )
	dropEvents( )
	enemy:dropBaddies( )
	resetVars()		-- Reset Hero Stats and some other pre-game vars.
	checkLVLup()	-- Check next level XP required
	spawnHero()		-- Random position Hero at Map
	centerMap ()	-- Focus the Map on Player
end -- end function --

-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
function distance2enemy(s)
		distance =  distanceToEnemy(hero.x, hero.y, enemy:checkX(s), enemy:checkY(s))
	return distance

end

function spawnHero ()
	repeat
		hero.x = 6
		hero.y = 6
		hero.check_walk = map.walk[map.data[hero.y][hero.x]]   		
	until hero.check_walk == 1
	ORIENTATION = 3 -- 1 = DOWN, 2 = UP, 3 = LEFT, 4 = RIGHT
	UpdateOctans( )
end -- end function --

-----------------------------------------------------------------------------

function resetVars()
	love.graphics.setNewFont(9)
	record.count = 0				-- reset counter for debrief screen
	hero.kills = 0					-- number of enemies killed
	hero.killed_by = ""
	hero.turn = 0					-- total of turns used
	hero.xp = 0						-- xp indicator
	hero.lvl = 1					-- level indicator
	hero.lvl_xp_unit = 35			-- number of xp needed for each level
	hero.lvl_hp_bonus = 2			-- amount of hp bonus when lvl up (use 0 for no bonus)
	hero.hp_base = 170				-- starting hero hp
	hero.hp = hero.hp_base			-- hero hp indicator 
	hero.ActionPoints = 16
	hero.name = "PIMP"	-- hero name (as obvious)  
	hero.damage = 0
	hero.minDamage = 5
	hero.maxDamage = 10
	hero.totalDamage = 0
	hero.enemiesKilled = 0
	hero.tagUsed = 0
	hero.turnsTillTag = 10
	hero.hasShoot = false
	setupLayer_LOW()				-- reload map in memory to erase exits or other map changes 
	--pMovementString = " "
	pAttackString = " "
	--insertEvent(pMovementString)
   
end -- end function --

function drawPlayerHealthBar( )
		local scaleFactor = 1 - ( (100 - ( (100 * hero.hp) / hero.hp_base ) ) / 100 )
		love.graphics.draw(hb_background, (hero.x - map.x) * 32, (hero.y - map.y) * 32 - 5)
		love.graphics.draw(hb_foreground, (hero.x - map.x) * 32, (hero.y - map.y)  * 32 - 5, 0, scaleFactor  ,1)
		--love.graphics.print(""..v.s.."",(hero.x - map.x) * 32, (v.y - map.y)  * 32 - 25)
		--love.graphics.print("Total X:"..hero.x - map.x.." Hero X: "..hero.x.." Map X: "..map.x.." ",0,96)
end

function love.mousepressed(x,y, button )
	--[[
	4,305
	55,305,
	106,
	155
	--]]
	if y > 305 and y < 305 + 41 then
		if x > 4 and x < 41 + 46 then
			currentWeaponID = 1
		elseif x > 55 and x < 55 + 46 then
			currentWeaponID = 2
		elseif x > 106 and x < 106 + 46 then
			currentWeaponID = 3
		elseif x > 155 and x < 155 + 46 then
			currentWeaponID = 4
		end
	end

end

function drawMuzzle()

	if love.timer.getMicroTime() > muzzle_timer + 0.1 then
		if muzzleFrame < mEndFrame then
			muzzleFrame = muzzleFrame + 1
		else
			muzzleFrame = mStartFrame
		end
	end
	love.graphics.setColor(255,255,255)
		--love.graphics.print("Total X:"..hero.x - map.x.." Hero X: "..hero.x.." Map X: "..map.x.." ",0,64)
		--if hero.ActionPoints >= 4 then
			if love.mouse.isDown("l") then
		
					if love.timer.getMicroTime() < muzzleTimer + 0.1 then
							if ORIENTATION == 3 then
								love.graphics.draw(muzzle_anim[muzzleFrame], (hero.x - map.x - 1) * 32, (hero.y - map.y) * 32,0,-1,1,32,0)
							elseif ORIENTATION == 4 then
								love.graphics.draw(muzzle_anim[muzzleFrame], (hero.x - map.x + 1) * 32, (hero.y - map.y) * 32,0)
							end			
							
					end 
					
			--end
			else
				muzzleTimer = love.timer.getMicroTime()
				muzzleFrame = mStartFrame
			end
		--end
	
	function love.mousereleased(x,y,button)
		if button == "l" then
			muzzleTimer = love.timer.getMicroTime()
		end
	
	end
end

function distanceToEnemy(x1,y1, x2,y2)
	return ((x2-x1)^2+(y2-y1)^2)^0.5
end
function distanceToPlayer(x1,y1, x2,y2)
	return ((x2-x1)^2+(y2-y1)^2)^0.5
end
-----------------------------------------------------------------------------

function checkLVLup()
	hero.xp_advance = hero.lvl_xp_unit*(hero.lvl)	-- calculate the XP needed to reach next level	
end -- end function --

-----------------------------------------------------------------------------

function checkGoal()
	if hero.lvl >= map.exit[1] then							-- check if objective level for exit has been reached
		map.data[map.exit[3]][map.exit[4]] = map.exit[2]	-- pump final exit tile to map 	
		map.name[map.exit[2]] = map.exit[5]					-- put a name in exit tile 		
	end
end -- end function --

-----------------------------------------------------------------------------

function centerMap()
  -- love.mouse.setPosition( window.size_x/2, window.size_y/2 )
   map.center_x = math.min(hero.x-map.camera_mid_x, map.width-map.camera_width)
   map.center_y = math.min(hero.y-map.camera_mid_y, map.height-map.camera_height)
   if map.center_x > 0 then map.x = map.center_x else map.x = 0 end
   if map.center_y > 0 then map.y = map.center_y else map.y = 0 end
end -- end function --

-----------------------------------------------------------------------------
function actionsDuringEnemyTurn ( )
	for i = 1, enemy:getCurrentEnemies( ) do
		enemy:getOldPosition( i )
		if enemy:getHp(i) > 0 then
			--spath, slength = pather:getPath(enemy:checkX(i),  enemy:checkY(i), hero.x,hero.y)
			--if spath then
			--if 	distanceToPlayer(enemy:checkX(i),enemy:checkY(i), hero.x, hero.y) > 1 and distanceToPlayer(enemy:checkX(i),enemy:checkY(i), hero.x, hero.y) <= 7 then
				enemy:moveTowardsPlayer2(i)
				
				enemy:positionCorrectly(i)
			if distanceToPlayer(enemy:checkX(i),enemy:checkY(i), hero.x, hero.y) <= 2 then
				enemy:attackPlayer( i )
			elseif distanceToPlayer(enemy:checkX(i),enemy:checkY(i), hero.x, hero.y) >8 then
				--enemy:move(i)
			end
			--end
		end
	end
end

function handleMovement( )
	if hero.hp > hero.hp_base then hero.hp = hero.hp_base end
	
	function love.keypressed(key)
	
			if hero.hp <= 0 then
				love.mouse.setVisible(true)
				game_state = 'StateChange'
			end
	

			
	   		muzzleTimer = love.timer.getMicroTime()
	   		
	   		--[[if key == "x" then
				--game_state = 'drawStateChange'
				love.graphics.push()
				scaleIt = true

				
	   		end--]]
	   		
	   		--[[if key == "z" then
				enemy:spawnTier2Enemy( )
 
	   		end--]]
	   		
	   		if key == " " then
	   			pMovementString = "You decided to wait for a few moments."
	   			insertEvent(pMovementString)
	   			playerTurn = false
	   			
	   		end
	   		
	   		--[[if key == 'i' then
	   			enemy:spawnNewEnemy( )
	   		end--]]
	
	      if key == 'up' or key == 'w' or key == 'kp8' and hero.y-1 == 1 then
	         move_y = hero.y-1
	         move_x = hero.x
	         pMovementString = "You took 1 step up"
	         validateMove ()
	         UpdateOctans( )
	         if soundOn == true then
	         	love.audio.play(snd.playerWalk)
	         end
	         --ORIENTATION = 2
	         --tRotation = 0
	         --hero.ActionPoints = hero.ActionPoints - 4
	        
	         
	      end
	      

	      
	      if key == 'down' or key == 's' or key == 'kp2' and hero.y+1 <= map.height then
	         move_y = hero.y+1
	         move_x = hero.x
	         pMovementString = "You took 1 step down"
	         validateMove () 
	         UpdateOctans( )
	         if soundOn == true then
	         	love.audio.play(snd.playerWalk)
	         end
	        -- ORIENTATION = 1   
	         --tRotation = 180     
	        -- hero.ActionPoints = hero.ActionPoints - 4
	         
		  end
	      
	      if key == 'left' or key == 'a' or key == 'kp4' and hero.x-1 == 1 then
	         move_x = hero.x-1
	         move_y = hero.y
	         pMovementString = "You took 1 step to the left"
	         validateMove ()   
	         ORIENTATION = 3   
	         tRotation = 180   
	         UpdateOctans( )
	         if soundOn == true then
	        	 love.audio.play(snd.playerWalk)
	         end
	         --hero.ActionPoints = hero.ActionPoints - 4
	         
	      end
	      
	      if key == 'right' or key == 'd' or key == 'kp6' and hero.x+1 <= map.width then
	         move_x = hero.x+1
	         move_y = hero.y
	         pMovementString = "You took 1 step to the right"
	         validateMove ()
	         ORIENTATION = 4
	         tRotation = 0
	         UpdateOctans( )
	         if soundOn == true then
	         	love.audio.play(snd.playerWalk)
	         end
	         --hero.ActionPoints = hero.ActionPoints - 4
	         
	      end 
	      
		-- extended key movement	       
	      
	     --[[ if ext_move then
	      
		      if key == 'q' or key == 'kp7' and hero.y-1 > 0 and hero.x-1 > 0 then
		         move_y = hero.y-1
		         move_x = hero.x-1
		         validateMove ()
		      end
		      
		      if key == 'e' or key == 'kp9' and hero.x+1 <= map.width  and hero.y-1 > 0 then
		         move_y = hero.y-1
		         move_x = hero.x+1
		         validateMove ()
		      end
		      
		      if key == 'z' or key == 'kp1' and hero.y+1 <= map.height and hero.x-1 > 0 then
		         move_y = hero.y+1
		         move_x = hero.x-1
		         validateMove ()
		      end
		      
		      if key == 'c' or key == 'kp3' and  hero.x+1 <= map.width and hero.y+1 <= map.height then
		         move_y = hero.y+1
		         move_x = hero.x+1
		         validateMove ()
		      end  
	      
	      end -- end if --   --]] 
	            
	   	-- key for focus on player
	      
	      if key == 's' then
			centerMap ()
	      end
	      
	   	-- key for help
	      
	      --[[if key == 'h' then
			game_state = "helpState"
			love.audio.play(snd.level)
	      end      
	      
	   	-- key for pause
	      
	      if key == 'p' then
			game_state = "pauseState"
			if soundOn == true then
				--love.audio.play(snd.level)
		    end
	      end--]]
	      
	   	-- key for quit
	      
	      if key == 'escape' then
			game_state = "quitState"

	      end
	      
	      
	      if key == '1' then
	      	currentWeaponID = 1
	      	WeaponDraw = weapons:returnImage(1)
	      	mStartFrame = 1
	      	mEndFrame = 4
	      	hero.minDamage = 5
	      	hero.maxDamage = 7
	      elseif key == '2' then
	      	currentWeaponID = 2
	      	WeaponDraw = weapons:returnImage(2)
	      	mStartFrame = 5
	      	mEndFrame = 11
	      	hero.minDamage = 8
	      	hero.maxDamage = 14
	      elseif key == '3' then
	      	WeaponDraw = weapons:returnImage(3)
	      	mStartFrame = 12
	      	mEndFrame = 15
	      	currentWeaponID = 3
	      	hero.minDamage = 5
	      	hero.maxDamage = 12
	      elseif key == '4' then
	      	WeaponDraw = weapons:returnImage(4)
	      	currentWeaponID = 4
	      	hero.minDamage = 1
	      	hero.maxDamage = 2
	      else
			      playerTurn = false
			      hero.hp = hero.hp + 2	      
	      end
			--if key ~= '1' or key ~= '2' or key ~= '3' or key ~= '4' then
			     -- playerTurn = false
			      --hero.hp = hero.hp + 2
			--end
	      --insertEvent(pMovementString)
	 	end -- end function (love.keypressed)
		
end

function turnUpdate( )
	handleMiscEvents( )
	if playerTurn == true then
		handle_gun_sounds( )
		
		handleMovement( )
		if hero.ActionPoints <= 0 then
			enemy:updateAP( )
			playerTurn = false
		end
	elseif playerTurn == false then
		
		enemy:update()		
		hero.ActionPoints = 16
		if bInsertEvent == true then
			insertEvent(evEnemyString)
			bInsertEvent = false
		end
		
		playerTurn = true
	end

end

function validateMove ()
		combat_on = 0 -- this flag avoids hero go to defeated mob place after combat
		
		for i = 1,enemy:getCurrentEnemies( ) do			
			if move_y == enemy:checkY(i) and move_x == enemy:checkX(i) then
				combat(i)
				hero.ActionPoints = hero.ActionPoints - 2
			end -- checks if hero is attacking mob
			
		end
		
		if map.collision[move_y][move_x] == 0 and combat_on == 0 then
				hero.x = move_x --hero.x = hero.x + (move_x - hero.x) * 0.6--
				hero.y = move_y --hero.y = hero.y + (move_y - hero.y) * 0.6--
				if hero.x == move_x and hero.y == move_y then
					hero.turn = hero.turn+1
					centerMap ()
					--actionsDuringEnemyTurn ( )
					--[[if hero.x == map.exit[4] and hero.y == map.exit[3] then	-- check if hero reached exit
						checkRecords()	
						game_state = "goalState" 
					end	-- end if --
					--]]
				end
		end -- end if --
		insertEvent(pMovementString)
	
	
end -- end function --

function handle_gun_sounds( )

	if currentWeaponID == 1 then
		gunsound = snd.pistol
	elseif currentWeaponID == 2 then
		gunsound = snd.rifle
	elseif currentWeaponID == 3 then
		gunsound = snd.shotgun
	elseif currentWeaponID == 4 then
		gunsound = snd.freeze
	end
		

end
-----------------------------------------------------------------------------
function gun_combat( s )

	
	
	--[[if currentWeaponID == 1 then	
		hero.ActionPoints = hero.ActionPoints - 4
		
	elseif currentWeaponID == 2 then
		hero.ActionPoints = hero.ActionPoints - 8
	elseif currentWeaponID == 3 then
		hero.ActionPoints = hero.ActionPoints - 12
	elseif currentWeaponID == 4 then
		hero.ActionPoints = hero.ActionPoints - 8
		hero.tagUsed = hero.tagUsed + 1
	end--]]
	hero.ActionPoints = hero.ActionPoints - weapons:returnAP(currentWeaponID)
	
	--[[if currentWeaponID == 3 and distance2enemy(s) > 4 then
		hero.damage = 0	
		pMovementString = "You used - The Shotgun - against "..enemy.table[s].name.." for a long range attack. It's not very effective"
		insertEvent(pMovementString)
	else
		hero.damage = math.floor(math.random(hero.minDamage, hero.maxDamage) - distance2enemy(s))
		if hero.damage < 0 then hero.damage = 0 end
		pMovementString = "You shot "..enemy.table[s].name.." for "..hero.damage.." "
		insertEvent(pMovementString)
	end--]]
	
	hero.damage = weapons:doDamage(s)
	pMovementString = "You shot "..enemy.table[s].name.." for "..hero.damage.." "
	
	if hero.damage < 0 then hero.damage = 0 end
	hero.totalDamage = hero.totalDamage + hero.damage
	hero.turn = hero.turn + 1
	enemy:setAwareness( s )
	enemy.table[s].takingDamage = true
	hero.hasShoot = true
	
	-- If the stun weapon is used beyond it's 3 limit:
		if hero.tagUsed == 3 then
			if hero.hp > 0 then
				hero.hp = hero.hp - math.random(5,15)
				
			end
			hero.tagUsed = 0
		end
	if soundOn == true then
		love.audio.play(gunsound)
	end
	UpdateOctans( )
	return hero.damage
end
-------------------------------------------------------------------------------
function love.mousepressed(x,y, button )

	
	if x > (hero.x- map.x)*tile.w  then
		ORIENTATION = 4
		tRotation = 90
	elseif x < (hero.x- map.x)*tile.w then
		ORIENTATION = 3
		tRotation = 270
	end

	if testingJumper == false then
	
		for i = 1, enemy:getCurrentEnemies( ) do	
			--if hero.ActionPoints >= 4 then	
			
				if button == "l" and getMouseX( ) == enemy:checkX(i) and getMouseY( ) == enemy:checkY(i) then
					enemy:alterHp(i,gun_combat( i ))
					enemy:isDead(i)
						if currentWeaponID == 3 then
							enemy:knockBack(i,ORIENTATION)
						end
					--actionsDuringEnemyTurn()
					
					--enemy:move(i)
				end
			--end
		end
	end
end -- function

--------------------------------------------------------------------------------

function getMouseX( )
	mx = love.mouse.getX( )
	r_mouseX = 0  + mx / tile.w
	return map.x + math.modf(r_mouseX)
end

function getMouseY( )
	my = love.mouse.getY( )
	r_mouseY = 0  + my / tile.h
	return map.y + math.modf(r_mouseY)
end

--------------------------------------------------------------------------------
--
function combat( s )
	hero.hasShoot = false
	combat_on = 1

	diceRoll_Combat = math.random(1,6)
	hero.turn = hero.turn+1	-- attack is also a move/turn
		if diceRoll_Combat >= 2 and diceRoll_Combat<6 then	-- simple random fight combat  (at least 3 hurts mob, less than that hero gets "PAIN") 
			pMovementString = "You stabbed "..enemy.table[s].name.." for 4 damage"
			enemy:alterHp(s,4) -- mob.hp = mob.hp - 1
			hero.totalDamage = hero.totalDamage + 4
			love.audio.play(snd.hit)	
		elseif diceRoll_Combat >= 6 then -- Same Damage + Knockback
			pMovementString = "You stabbed "..enemy.table[s].name.." for 6 damage"
			hero.totalDamage = hero.totalDamage + 6
			enemy:alterHp(s,6)
			love.audio.play(snd.hit)	
		end
		
		--[[if hero.hp <= 0 then	-- hero is dead, prepare game over
			hero.killed_by = mob.random	-- mark wich mob killed hero 
			checkRecords() -- checks wich records are achieved
			game_state = "ripState" 
		end--]]
		
		enemy:isDead( s )
end -- end function --

-----------------------------------------------------------------------------

function checkRecords ()

	if hero.kills > record.hero_kills then
		 record.hero_kills_previous = record.hero_kills
		 record.hero_kills = hero.kills
    	 record.count = record.count+1
    	 record.hero_kills_badge = 1
    else
    	 record.hero_kills_badge = 0
	end	
		
	if  hero.lvl > record.hero_lvl then
		record.hero_lvl_previous = record.hero_lvl
    	record.hero_lvl = hero.lvl
    	record.count = record.count+1
    	record.hero_lvl_badge = 1
    else
    	record.hero_lvl_badge = 0
    end
    
	-- checks if hero made more XP than before				    
	if hero.xp > record.hero_xp then 
		record.hero_xp_previous = record.hero_xp
    	record.hero_xp = hero.xp
    	record.count = record.count+1
    	record.hero_xp_badge = 1
    else
    	record.hero_xp_badge = 0		    	
	end
end -- end function --

-----------------------------------------------------------------------------

-----------------------------------------------------------------------------

function bgDraw ()

	love.graphics.draw(menu_background)    

end -- end function --

-----------------------------------------------------------------------------
-- UPDATE ROUTINES --
-----------------------------------------------------------------------------

function updateNull()

end -- end function --

-----------------------------------------------------------------------------

function updateIntro()
	function love.keypressed(key, unicode)
   
		if key == ' ' then
			restartGame() 
			game_state = "playState" 	
		end
   end	
end 

-----------------------------------------------------------------------------

function updatePlay()
    turnUpdate( )
end -- end function --

-----------------------------------------------------------------------------

function updateHelp()
         	
	function love.keypressed(key, unicode)
      
      if key == 'escape' then
		game_state = "playState"
		--love.audio.play(snd.level)
      end
      
    end -- end function (love.keypressed)

end -- end function --

-----------------------------------------------------------------------------

function updatePause()
         	
	function love.keypressed(key, unicode)

   	-- key for return to game
    
      if key == 'escape' then
		game_state = "playState"
		--love.audio.play(snd.level)
      end
      
    end -- end function (love.keypressed)

end -- end function --

-----------------------------------------------------------------------------

function updateQuit()
         	
	game_state = "introState"  
	end -- end function --

-----------------------------------------------------------------------------

function updateDebriefing()
	
	function love.keypressed(key, unicode)
	
	-- SPACE to restart	
	 
		if key == ' ' then
			restartGame() 
	    	game_state = "playState" 			
	  	end
	 
	end -- end function --

end -- end function --

function updateStateChange( )
	--895, 635
	
	enemy:dropBaddies( )
	
	
	--function love.mousepressed (x,y, button)
	if love.mouse.isDown("l") then
		x = love.mouse.getX()
		y = love.mouse.getY()
		
		if x > 895 and x < 895 + 44 and y > 635 and y < 635+53 then
			love.mouse.setVisible(false)
			restartGame() 
	    	game_state = "playState" 	
			
		end
	end
	
	
	--end
	
	
	function love.keypressed(key, unicode)
	
	-- SPACE to restart	
	 	enemy:dropBaddies( )
		if key == '.' then
			restartGame() 
	    	game_state = "playState" 			
	  	end
	 
	end -- end function --

end
-----------------------------------------------------------------------------

function love.update()

	if(game_state == 'nullState') then updateNull()
	elseif(game_state == 'introState') then updateIntro()
	elseif(game_state == 'StateChange') then updateStateChange( )
	elseif(game_state == 'playState') then
	 updatePlay()  	
	 enemy:loopAnims( )
	elseif(game_state == 'ripState' or game_state == 'goalState') then updateDebriefing()
	elseif(game_state == 'drawStateChange') then updateStateChange( )
	elseif(game_state == 'helpState') then updateHelp() 	
	elseif(game_state == 'pauseState') then updatePause() 
	elseif(game_state == 'quitState') then updateQuit() 
	else error('game_state is not valid')
	end -- end if --
			
end -- end function --

-----------------------------------------------------------------------------
-- DRAW ROUTINES --
-----------------------------------------------------------------------------

function drawNull()

end -- end function --

-----------------------------------------------------------------------------

function drawIntro()
	love.mouse.setVisible(true)
	bgDraw () -- call backgroud draw routine
	--love.graphics.print("Press SPACE to begin!", 500,700)  

	if soundOn == true then
		love.graphics.draw(PvsV_Button_Sound, 10, 740)
	else
		love.graphics.draw(tPvsV_Button_Sound, 10, 740)
	end
	
	love.graphics.draw(PvsV_Button_Play,470,500)
	love.graphics.draw(PvsV_Button_Credits,470,550)
	love.graphics.draw(PvsV_Button_Quit,470,600)
	
	x = love.mouse.getX( )
	y = love.mouse.getY( )
	--function love.mousepressed(x,y, button)
	if love.mouse.isDown("l") then
		if x > 470 and x < 470 + 61 and y > 500 and y < 521 then
			love.mouse.setVisible(false)	
			restartGame() 
			game_state = "playState" 
					
		elseif x > 470 and x < 470 + 61 and y > 550 and y < 571 then
			--game_state = "credits"
			love.graphics.draw(PvsP_Menu_Credits,288,45)
		elseif x > 470 and x < 470 + 61 and y > 600 and y < 621 then
			love.event.quit( )
		end
		
		if x > 10 and x < 10 + 49 and y > 740 and y < 761 then
			if soundOn == true then
				soundOn = false
				love.audio.pause()
			elseif soundOn == false then
				soundOn = true
				love.audio.resume( )
			end
		end
	
	end
end -- end function --

-----------------------------------------------------------------------------

function drawPlay()
	love.mouse.setVisible(false)
	love.graphics.scale(2,2)
	love.graphics.setBackgroundColor(1,1,1)
	draw_map()	  
	data = map.data[hero.y][hero.x]   
	--drawPlayerHealthBar( )
	--enemy:spillBlood( 1 )
 	--love.graphics.setColor( 255, 255, 255, 255)
 	
	printJumperValues()
end -- end function --

-----------------------------------------------------------------------------
function drawStateChange( )



end
function drawHelp()
	love.graphics.setBackgroundColor(100,100,100)
	draw_map()	  
 	love.graphics.setColor( 0, 0, 0, 150)
	love.graphics.rectangle("fill",0,0,window.size_x,window.size_y)
 	love.graphics.setColor( 255, 255, 255, 255)
	love.graphics.printf(comm_keys_help,tile.w+25,tile.h+25,map.camera_width*tile.w-50,"left")
 	love.graphics.setColor( 255, 255, 255, 255)
	love.graphics.printf("Press ESC to return to game!", tile.w,window.size_y-font_size,map.camera_width*tile.w,"center")  
end -- end function --

-----------------------------------------------------------------------------

function drawPause()
	love.mouse.setVisible(true)
	love.graphics.setBackgroundColor(100,100,100)
	 	 	
end -- end function --

-----------------------------------------------------------------------------

function drawQuit()
	
end

-----------------------------------------------------------------------------


function drawDebriefing()
 
end -- end function --

function drawStateChange()
	
	love.graphics.setNewFont(15)
	love.graphics.draw(Pimps_Background_Dead,0,0)
	love.graphics.print(" You were killed by "..hero.killed_by.." after "..hero.turn.." turns.",10,300)
	love.graphics.print(" In your life time you have dealt: "..hero.totalDamage.." damage and killed "..hero.enemiesKilled.." vampires.",10,321)
	 

end
-----------------------------------------------------------------------------

function love.draw()
	--love.mouse.setVisible(false)
	--TLfres.transform()
	
	if(game_state == 'nullState') then drawNull()
	elseif(game_state == 'introState') then drawIntro()
	elseif(game_state == 'StateChange') then drawStateChange()
	elseif(game_state == 'playState') then 
		drawPlay()  
		--debugctionsDuringEnemyTurn( )
		displayEventLog( )
		
		--if love.keyboard.isDown("t") then
			--removeEvent( )
			
		--end
		--love.graphics.print(""..distanceToPlayer(enemy:checkX(1),enemy:checkY(1), hero.x, hero.y).."",400,0)
	elseif(game_state == 'ripState' or game_state == "goalState") then drawDebriefing()
	elseif(game_state == 'drawStateChange') then  drawStateChange( )
	elseif(game_state == 'helpState') then drawHelp()		
	elseif(game_state == 'pauseState') then drawPause()	
	elseif(game_state == 'quitState') then drawQuit()	
	else error('game_state is not valid')
	end -- end if --
	
	--TLfres.letterbox(4,3)
 	
 	--performMovement(path)
end -- end function --

-----------------------------------------------------------------------------

function love.quit()
	-- do save rotines here
	love.event.push("q")
end -- end function --

-----------------------------------------------------------------------------
-- END CODE --
-----------------------------------------------------------------------------
--
--

-----------------------------------------------------------------------------
-- Debug stuff
-- --------------------------------------------------------------------------
--
function printJumperValues (  )

	if tbpath then
		for i = 1, #tableJumper do
				love.graphics.print("Value X: "..tableJumper[i].x.." Value Y: "..tableJumper[i].y.."",0,64+i*20)
		end
	end
end

function StepByStep(dapath)
	tableJumper = path
	currentStep = 1

end


function computeLight( )
	
	for i = 1, 64 do
		for j = 1, 64 do
			
			
			
		end
	end

end

--enemy:debugPathTowardsPlayer(s, path)
function debugctionsDuringEnemyTurn( )
	--[[for i = 1, enemy:getCurrentEnemies( ) do
		if enemy:getHp(i) > 0 then
				spath, slength = pather:getPath(enemy:checkX(i),  enemy:checkY(i), hero.x,hero.y)
				if spath then
					enemy:debugPathTowardsPlayer(i,spath)
				end
		end
	end--]]
end

