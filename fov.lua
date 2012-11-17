function UpdateOctans( )

	octans = {}
	for v=1,8 do
		newScan(v,2,1,0)
	end

end


function newScan(no, start, sSlope, eSlope)

	local x, y, active
	local last, solid = nil, nil
	local ss, es = sSlope, eSlope
	local signs = 	{
				{	rowSign = -1,	colSign = -1	},
				{	rowSign = -1,	colSign = 1		},
				{	rowSign = -1,	colSign = 1		},
				{	rowSign = 1,	colSign = 1		},
				{	rowSign = 1,	colSign = 1		},
				{	rowSign = 1,	colSign = -1	},
				{	rowSign = 1,	colSign = -1	},
				{	rowSign = -1,	colSign = -1	},
				--{   rowSign = 1,	colSign = -1	},
				--{   rowSign = -1,	colSign = -1	}
				}
	
	if no == 1 or no == 2 or no == 5 or no == 6 then
		for row = start, 30 do
			y = hero.y + (row - 1) * signs[no].rowSign
			if y >= 3 and y <= mapTilesY - 2 then
				for column = 1, row do
					x = hero.x + (row - column) * signs[no].colSign
					if x >= 3 and x <= mapTilesX-2 then
						active = math.abs((hero.x - x) / (hero.y - y))
						if sSlope >=  active and eSlope <= active then
							if column > 1 then
								if map.collision[y][x] ~= map.collision[y][x+signs[no].colSign] then
									if map.collision[y][x] == 0 then
										last = "ss"
										ss = active
									else
										es  = math.abs((hero.x - (x+signs[no].colSign)) / (hero.y - y))
										newScan(no, row+1, ss, es)
										es = active
										last = "es"
									end
								end
							end
							
							if math.abs((hero.x - (x - signs[no].colSign)) / (hero.y - y)) < eSlope and last == "ss" and map.collision[y][x] == 0 then
								newScan(no, row+1, ss, eSlope)
							end

 							if column == row and last == "ss" and map.collision[y][x] == 0 then
 								newScan(no, row+1, ss, eSlope)
 							end

							if map.collision[y][x] == 0 then
								table.insert(octans, {x = x, y = y})
							else
								solid = true			
							end
						end
					end
				end
			end
			if last or solid then
				break
			end
		end
	else
		for column = start, 30 do
			x = hero.x + (column - 1) * signs[no].colSign
			if x >= 3 and x <= mapTilesX - 2 then
				for row = 1, column do
					y = hero.y + (column - row) * signs[no].rowSign
					if y >= 3 and y <= mapTilesY - 2 then
						active = math.abs( (hero.y - y) / (hero.x - x))
						if sSlope >=  active and eSlope <= active then
							if row > 1 then
								if map.collision[y][x] ~= map.collision[y+signs[no].rowSign][x] then
									if map.collision[y][x] == 0 then
										last = "ss"
										ss = active
									else
										es  = math.abs((hero.y - (y+signs[no].rowSign)) / (hero.x - x))
										newScan(no, column+1, ss, es)
										es = active
										last = "es"
									end
								end
							end
							
							if math.abs((hero.y - (y-signs[no].rowSign)) / (hero.x - x)) < eSlope and last == "ss" and map.collision[y][x] == 0 then
								newScan(no, column+1, ss, eSlope)
							end

 							if row == column and last == "ss" and map.collision[y][x] == 0 then
 								newScan(no, column+1, ss, eSlope)
 							end
							
							if map.collision[y][x] == 0 then
								table.insert(octans, {x = x, y = y})
							else
								solid = true			
							end
						end
					end
				end
			end
			if last or solid then
				break
			end
		end
	end
end