function Shatter( keys )
	local caster = keys.caster
	local ability = keys.ability
	local baseMovement = ability:GetSpecialValueFor("base_ms")
	local dmgMultiplier = ability:GetLevelSpecialValueFor("dmg_multiplier", (ability:GetLevel() - 1))
	local radius = ability:GetSpecialValueFor("radius")

	local damageTable = {}
	damageTable.attacker = caster
	damageTable.ability = ability
	damageTable.damage_type = ability:GetAbilityDamageType()

	local unitsToDamage = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_NONE, 0, false)

	for _,v in ipairs(unitsToDamage) do
		-- Damage calculation depending on movement speed
		damageTable.damage = (v:GetBaseMoveSpeed() - v:GetIdealSpeed()) * dmgMultiplier
		damageTable.victim = v
		ApplyDamage(damageTable)
		print(v:GetBaseMoveSpeed())
	end
end