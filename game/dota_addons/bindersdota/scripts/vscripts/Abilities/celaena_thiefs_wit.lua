function ThiefsWitCrit( keys )
	local target = keys.target
	local ability = keys.ability
	local caster = keys.caster
	local damage = keys.critDamage

	local targets = FindUnitsInRadius(
									caster:GetTeamNumber(), 
									caster:GetAbsOrigin(), 
									nil, 
									FIND_UNITS_EVERYWHERE, 
									DOTA_UNIT_TARGET_TEAM_ENEMY, 
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL, 
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
									FIND_ANY_ORDER, 
									false)

	local damage_table = {}

	damage_table.attacker = caster
	damage_table.ability = ability
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.damage = damage

	for _,enemy in pairs(targets) do
		if enemy:FindModifierByName("modifier_branded") ~= nil and enemy ~= target then
			damage_table.victim = enemy
			ApplyDamage(damage_table)
		end
	end
end