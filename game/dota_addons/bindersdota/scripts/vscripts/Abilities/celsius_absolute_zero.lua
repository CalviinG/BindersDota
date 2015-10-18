function apply_debuff(params)

	local hero_base = params.target:FindModifierByName("modifier_absolute_zero_base")
	local hero_stack = params.target:FindModifierByName("modifier_absolute_zero_stack")

	-- Case 1: Target does not have the base debuff.
	-- In this case, apply the base debuff and a stack debuff
	if hero_base == nil then
		params.ability:ApplyDataDrivenModifier(params.caster, params.target, "modifier_absolute_zero_base", nil)
		params.ability:ApplyDataDrivenModifier(params.caster, params.target, "modifier_absolute_zero_stack", nil)
		params.target:FindModifierByName("modifier_absolute_zero_stack"):IncrementStackCount()

	-- Case 2: Target is a hero. Target has the base debuff.
	-- In this case, increment the stack count if needed and reset the durations on both the base and stack debuffs.
	elseif hero_base ~= nil then
		-- Only update the stack count if we are below what's defined as the maximum number.
		if hero_stack:GetStackCount() < params.max_stacks then hero_stack:IncrementStackCount() end
		hero_base:SetDuration(params.debuff_duration, true)
		hero_stack:SetDuration(params.debuff_duration, true)
	end
end