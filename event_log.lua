----------------------------------------------------------
---event log:
---table called Events
---max_events = 3
---when action: insert into events $String
---if Events > max_events then
---		remove from Events, events[1]
---		pusback other events
---end

Events = { " You have entered the Mansion. Your fashion senses are tingling " }
max_events = 3

t_posY = 400
function dropEvents( )
	Events = { }
end

 function handleMiscEvents( )
 	if miscEventBool == true then
 		insertEvent(miscEventString)
 		miscEventBool = false
 	end 
 end
 
function displayEventLog( )

	displayTopBar( )
	love.graphics.draw(log_background,0,346)
	displayWeaponSlots( 4 )
	
	love.graphics.draw(cross_hair,(getMouseX()-map.x)*tile.w, (getMouseY()-map.y)*tile.h)
	--love.graphics.print(""..(getMouseX()).." | "..(getMouseY()),(getMouseX()-map.x)*tile.w+20, (getMouseY()-map.y)*tile.h-20)
	if #Events > max_events then
		removeEvent( )
	end
	--enemy:drawLine( )
	
	
	if love.keyboard.isDown("5") then
		t_posY = t_posY -1
	elseif love.keyboard.isDown("6") then
		t_posY = t_posY +1
	end

	if Events then
		for i = 1, #Events do
			love.graphics.print(""..Events[i].."",9, 352 - 8 + i*9)
		end
	end
	


end

function displayTopBar( )
	test_MinDmg, test_MaxDmg = weapons:getWeaponDamage(1)
	
	love.graphics.draw(top_bar,0,0)
	love.graphics.print("Health: "..hero.hp.." | Level: "..hero.lvl.." | Action Points: "..hero.ActionPoints.." | FPS: "..love.timer.getFPS( ).."Test Weapon min dmg:"..test_MinDmg.." Max Dmg: "..test_MaxDmg.."",6,3)

end

function displayDamageDealth( string, x, y)

		love.graphics.print( string, x, y )
end

function displayWeaponSlots( nr )
	
	love.graphics.draw(uiPistol1,4,305)
	love.graphics.draw(uiRifle1,55,305)
	love.graphics.draw(uiShotgun1,106,305)
	love.graphics.draw(uiFreeze1,155,305)
	
	if currentWeaponID == 1 then
		love.graphics.draw(uiPistol2,4,305)
	elseif currentWeaponID == 2 then
		love.graphics.draw(uiRifle2,55,305)
	elseif currentWeaponID == 3 then
		love.graphics.draw(uiShotgun2,106,305)
	elseif currentWeaponID == 4 then
		love.graphics.draw(uiFreeze2,155,305)
	end


end

function insertEvent( string )

	table.insert(Events, string)

end


function removeEvent( )

	table.remove(Events,1)
	--for i = 1, #self.table do
		--self.table[i].s = i
	--end

end

return Events