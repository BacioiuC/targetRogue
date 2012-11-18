weapons = { }


function weapons:initSystem()
	self.weaponTable = {}
end
function weapons:newWeapon(_id,name,min_damage,max_damage,_AP,_image)
	__image = love.graphics.newImage(_image)
	__image:setFilter("nearest","nearest")
	
	local temp = { 
			id = _id,
			ap = _AP,
			weaponName = name,
			minDamage = min_damage,
			maxDamage = max_damage,
			image = __image,
			}
			
	table.insert( self.weaponTable, temp )
end


function weapons:returnImage(id)
	for i,v in ipairs(self.weaponTable) do
		if v.id == id then
			return v.image		
		end
	end
end

function weapons:returnAP(id)
	for i,v in ipairs(self.weaponTable) do
		if v.id == id then
			return v.ap		
		end
	end
end

function weapons:getWeaponDamage(id)
	for i,v in ipairs(self.weaponTable) do
		if v.id == id then
			return v.minDamage, v.maxDamage
		
		end
	end
end

function weapons:doDamage(target)
	if currentWeaponID == 3 and distance2enemy(target) > 4 then
		damageDone = 0
	else
		damageDone = math.floor( math.random(weapons:getWeaponDamage(currentWeaponID) ) - distance2enemy(target))
	end
	return damageDone
end



return weapons