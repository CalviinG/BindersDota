-- Resets the Grace timer
function GraceBonusReset( event )
	local caster = event.caster
	local ability = event.ability
	local break_time = ability:GetLevelSpecialValueFor( "break_time" , ability:GetLevel() - 1 )
	
	-- Keep track of the time of this attack
	caster.last_attacked = GameRules:GetGameTime()

	-- Create a timer for this attack taken, after break_time duration, check if this was the last time attacked and grant bonuses
	Timers:CreateTimer(break_time, function() 
		if GameRules:GetGameTime() >= caster.last_attacked + break_time then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_grace_active", nil)
		end
	end)
end