function OnMyEvent( eventSourceIndex, args )
	print("***** Teleleport to the Fight Zone! *****")
	local startZone = Entities:FindByName( nil, "teleporter_player1_tofightzone" ):GetAbsOrigin()
	local goalZone = Entities:FindByName( nil, "teleporter_tobuyzone" ):GetAbsOrigin()

	-- https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting/API/Global.FindUnitsInRadius
	-- https://moddota.com/forums/search?Search=teamname

	-- Find all Players and their units
	playerUnits = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
	                              Vector(0, 0, 0),
	                              nil,
	                              FIND_UNITS_EVERYWHERE,
	                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	                              DOTA_UNIT_TARGET_ALL,
	                              DOTA_UNIT_TARGET_FLAG_NONE,
	                              FIND_ANY_ORDER,
	                              false)
	-- Teleport the units to the goalZone
	for _,unit in pairs(playerUnits) do
	   FindClearSpaceForUnit(unit, goalZone, false)
	   unit:Stop()
	end
end
 
CustomGameEventManager:RegisterListener( "my_event_name", OnMyEvent )