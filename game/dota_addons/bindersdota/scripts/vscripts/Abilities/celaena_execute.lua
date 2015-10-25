function ExecuteInit( keys )
	local ability = keys.ability
	local caster = keys.caster
	ability.damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	ability.execute_threshold = ability:GetLevelSpecialValueFor("execute_threshold", ability:GetLevel() - 1)
	local particleName = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_attack_blink.vpcf"
	local targets = FindUnitsInRadius(
									caster:GetTeamNumber(), 
									caster:GetAbsOrigin(), 
									nil, 
									FIND_UNITS_EVERYWHERE, 
									DOTA_UNIT_TARGET_TEAM_ENEMY, 
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL, 
									DOTA_UNIT_TARGET_FLAG_NONE, 
									FIND_ANY_ORDER, 
									false)

	local damage_table = {}

	damage_table.attacker = caster
	damage_table.ability = ability
	damage_table.damage_type = DAMAGE_TYPE_MAGICAL
	damage_table.damage = ability.damage
	for _,enemy in pairs(targets) do
		if enemy:FindModifierByName("modifier_branded") ~= nil then
			-- Execute
			if enemy:GetHealth() <= ability.execute_threshold then
				PopupNumbers(enemy, "crit", Vector(255, 0, 0), 3.0, ability.execute_threshold)
				enemy.ExecuteParticle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, enemy)
				ParticleManager:SetParticleControl(enemy.ExecuteParticle, 0, enemy:GetAbsOrigin())
				ParticleManager:SetParticleControlEnt(enemy.ExecuteParticle, 1, enemy, PATTACH_ABSORIGIN, "attach_absorigin", enemy:GetAbsOrigin(), true)
				enemy:Kill(ability, caster)
			else
				enemy.ExecuteParticle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, enemy)
				ParticleManager:SetParticleControl(enemy.ExecuteParticle, 0, enemy:GetAbsOrigin())
				ParticleManager:SetParticleControlEnt(enemy.ExecuteParticle, 1, enemy, PATTACH_ABSORIGIN, "attach_absorigin", enemy:GetAbsOrigin(), true)
				damage_table.victim = enemy
				ApplyDamage(damage_table)
			end
		end
	end
end

function PopupNumbers(target, pfx, color, lifetime, number)
    local pfxPath = string.format("particles/msg_fx/msg_%s.vpcf", pfx)
    local pidx = ParticleManager:CreateParticle(pfxPath, PATTACH_ABSORIGIN_FOLLOW, target)


    local digits = #tostring(number) + 1

    ParticleManager:SetParticleControl(pidx, 1, Vector(nil, tonumber(number), 4))
    ParticleManager:SetParticleControl(pidx, 2, Vector(lifetime, digits, 0))
    ParticleManager:SetParticleControl(pidx, 3, color)
end