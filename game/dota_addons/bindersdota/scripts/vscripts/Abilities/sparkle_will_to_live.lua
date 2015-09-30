-- 	Removes the applied positive dodge buffs from the target]]
function WillToLiveRemove( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier = keys.modifier

	-- Modifier variables
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local tick_interval = ability:GetLevelSpecialValueFor("tick_interval", ability_level)

	-- Calculating how many modifiers we have to remove
	local modifiers_to_remove = duration / tick_interval

	-- Removing them
	for i = 1, modifiers_to_remove do
		target:RemoveModifierByNameAndCaster(modifier, caster)
	end
end