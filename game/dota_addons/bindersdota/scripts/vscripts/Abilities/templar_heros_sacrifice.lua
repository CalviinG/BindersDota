function HerosSacrificeInit( keys )
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")
	local healAmount = ability:GetLevelSpecialValueFor("heal_amount", ability:GetLevel() - 1)

	local unitsToHeal = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_NONE, 0, false)

	for _,v in pairs(unitsToHeal) do 
		if v ~= caster then
			v:Heal(healAmount, caster)
		end
	end
end