function BloodsportInit( keys )
	local target = keys.target
	local ability = keys.ability
	local caster = keys.caster
	local brandDebuff = target:FindModifierByName("modifier_branded")

	if brandDebuff == nil then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_branded", {Duration = 10})
	end
end