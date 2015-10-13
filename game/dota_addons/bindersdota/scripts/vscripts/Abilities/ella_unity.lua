function UnityOnDamageTaken( keys )
	local caster = keys.caster
	local ability = keys.ability
	local damageToShare = keys.damageTaken
	local radius = ability:GetSpecialValueFor("radius")
	local damageTable = {}
	damageTable.attacker = caster
	damageTable.ability = ability
	damageTable.damage_type = DAMAGE_TYPE_PURE

	local unitsToDamage = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
	local count = 0
	for _ in pairs(unitsToDamage) do count = count + 1 end
	damageTable.damage = damageToShare / count

	for _,v in ipairs(unitsToDamage) do
		damageTable.victim = v
		ApplyDamage(damageTable)
	end
end