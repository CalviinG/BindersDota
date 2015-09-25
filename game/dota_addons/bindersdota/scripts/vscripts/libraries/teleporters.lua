-- variables
TELEPORTERS = {
    -- entrance_name = "exit_name"
    -- example:    teleport_southeast = "southeast_exit",
    teleporter_player1_tobuyzone = "teleporter_tobuyzone",
    teleporter_tospawn = "teleporter_player1_tospawn"
    -- Remember to always put a , between lines, but not on the last line
}

function Teleport_Hero(trigger)
    print ("start of teleport")
    -- Find the respective exit to every entrance
    local point = Entities:FindByName( nil, TELEPORTERS[trigger.caller:GetName()] ):GetAbsOrigin()
    -- Teleport the unit
    FindClearSpaceForUnit(trigger.activator, point, false)
    -- Stop the unit or else, it might move around after being teleported.
    trigger.activator:Stop()
    --[[
        print (trigger.caller:GetName())
        print ("Teleported!")
    --]]
    SendToConsole("dota_camera_center") -- Camera has to follow otherwise, the player might be lost.
end