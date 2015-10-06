function hailstorm_start(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local particleName = "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf"

	ability.bounceTable = {}
	ability.search_radius = ability:GetLevelSpecialValueFor("search_radius", ability:GetLevel() - 1)
	ability.nova_radius = ability:GetLevelSpecialValueFor("nova_radius", ability:GetLevel() - 1)
	ability.damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)


	for delay = 0, 2, 1 do
		
		local unitsNearTarget = FindUnitsInRadius(caster:GetTeamNumber(),
			caster:GetAbsOrigin(),
			nil,
			ability.search_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		-- finds the first target with < max_hit_count
				target = nil
				for k, v in pairs(unitsNearTarget) do
					if ability.bounceTable[v] == nil or ability.bounceTable[v] < 1 then
						target = v
						break
					end
				end

		-- if it finds a target, deals damage and then adds it to the bounceTable
		if target ~= nil then
			-- Fire effect
			local fxIndex = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControl( fxIndex, 0, target:GetAbsOrigin() )

			local units = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, ability.nova_radius,
											DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
											DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
			for k, v in pairs( units ) do
				local damageTable =
				{
					victim = v,
					attacker = caster,
					damage = ability.damage,
					damage_type = DAMAGE_TYPE_MAGICAL
				}
				ApplyDamage( damageTable )
				ability:ApplyDataDrivenModifier( caster, v, "modifier_hailstorm_debuff", nil)
			end

			ability.bounceTable[target] = ((ability.bounceTable[target] or 0) + 1)

		end
	end 
end