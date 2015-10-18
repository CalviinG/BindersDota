function BloodDaggerDamage( keys )
	local target = keys.target
	local ability = keys.ability
	local caster = keys.caster
	local brandDebuff = target:FindModifierByName("modifier_branded")
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local damagePerSecond = ability:GetSpecialValueFor("damage_per_second")


	local damage_table = {}

	damage_table.attacker = caster
	damage_table.victim = target
	damage_table.ability = ability
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.damage = damage

	ApplyDamage(damage_table)

	SpreadBrand(caster, ability, target, brandDebuff)

	damage_table.damage = damagePerSecond / 2
	local done = false;
	for delay = 0.50, duration, 0.50 do
		Timers:CreateTimer(delay, function ()

			ApplyDamage(damage_table)
			if done ~= true then
				done = SpreadBrand(caster, ability, target, brandDebuff)
			end
		end)
	end
end

function SpreadBrand(caster, ability, target, brandDebuff)
	if brandDebuff ~= nil and target:IsAlive() == false then
		local spreadDone = true;
		ability.bounceTable = {}
		ability.spread_radius = ability:GetSpecialValueFor("spread_radius")

		for brand = 0, 1, 1 do
			
			local unitsNearTarget = FindUnitsInRadius(caster:GetTeamNumber(),
				target:GetAbsOrigin(),
				nil,
				ability.spread_radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_MECHANICAL,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_CLOSEST,
				false)

			-- finds the first target not branded
			target = nil
			for k, v in pairs(unitsNearTarget) do
				if ability.bounceTable[v] == nil or ability.bounceTable[v] < 1 then
					if v:FindModifierByName("modifier_branded") == nil then
						target = v
						break
					end
				end
			end

			if target ~= nil then
				ability:ApplyDataDrivenModifier( caster, target, "modifier_branded", nil)
				ability.bounceTable[target] = ((ability.bounceTable[target] or 0) + 1)
			end

		end 
		return spreadDone;
	end
end