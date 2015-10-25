function MendAddStacks(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")
	local maxStacks = ability:GetSpecialValueFor("max_stacks")

	local unitsNearCaster = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
	local count = 0
	for _ in pairs(unitsNearCaster) do count = count + 1 end
	if count ~= 1 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_mend_stack", nil)
	end
	for _,v in ipairs(unitsNearCaster) do
		if v~=caster then
			if caster:FindModifierByName("modifier_mend_stack"):GetStackCount() < maxStacks then
				caster:FindModifierByName("modifier_mend_stack"):IncrementStackCount()
			end
		end
	end
end