function ThiefsWitCrit( keys )
	local target = keys.target
	local ability = keys.ability
	local caster = keys.caster
	local damage = keys.critDamage
	local particleName = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_impact_dagger_arcana.vpcf"
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
	damage_table.damage_type = DAMAGE_TYPE_PHYSICAL
	damage_table.damage = damage
	for _,enemy in pairs(targets) do
		if enemy:FindModifierByName("modifier_branded") ~= nil and enemy ~= target then
			enemy.ThiefsWitParticle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, enemy)
			ParticleManager:SetParticleControl(enemy.ThiefsWitParticle, 0, enemy:GetAbsOrigin())
			ParticleManager:SetParticleControlEnt(enemy.ThiefsWitParticle, 1, enemy, PATTACH_ABSORIGIN, "attach_absorigin", enemy:GetAbsOrigin(), true)
			PopupNumbers(enemy, "crit", Vector(24, 171, 219), 3.0, damage)
			damage_table.victim = enemy
			ApplyDamage(damage_table)
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