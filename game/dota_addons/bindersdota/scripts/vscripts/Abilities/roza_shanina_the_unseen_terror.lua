function TheUnseenTerrorInitialize( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel()
	local ability_name = ability:GetAbilityName()

	local caster_location = caster:GetAbsOrigin()
	local player = caster:GetPlayerID()
	local caster_direction = caster:GetForwardVector()

	local fire_interval = ability:GetSpecialValueFor("fire_interval")
	local nr_of_arrows = ability:GetLevelSpecialValueFor("nr_of_arrows", ability:GetLevel() - 1)

	local dummy_modifier = keys.dummy_modifier
	local dummy_modifier_invis = keys.dummy_modifier_invis

	for delay = 0, nr_of_arrows-1, fire_interval do
		Timers:CreateTimer(delay, function ()
			if caster:IsAlive() == false then
				return
			end
			if caster:IsChanneling() == false then
				return
			end
			caster.unseen_terror_dummy = CreateUnitByName("npc_dummy_unit", caster_location, false, caster, caster, caster:GetTeam())
			caster.unseen_terror_dummy:SetForwardVector(caster_direction)
			caster.unseen_terror_dummy.unseen_terror_dummy_position = caster_location
			caster.unseen_terror_dummy.unseen_terror_dummy_direction = caster_direction
			ability:ApplyDataDrivenModifier(caster, caster.unseen_terror_dummy, dummy_modifier, {duration = 0.5})
			ability:ApplyDataDrivenModifier(caster, caster.unseen_terror_dummy, dummy_modifier_invis, {duration = 0.6})
		end)
	end
end

function TheUnseenTerrorFire( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local startTraverseSound = "Ability.Powershot"

	StartSoundEvent( startTraverseSound, caster )
	caster:StartGesture( ACT_DOTA_ATTACK )

	-- Ability variables
	caster.unseen_terror_arrow_damage = (caster:GetAttackDamage() * 1.5)

	-- Projectile variables
	local projectile_name = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf"
	local projectile_speed = ability:GetSpecialValueFor("speed")
	local projectile_distance = ability:GetSpecialValueFor("range")
	local projectile_radius = ability:GetSpecialValueFor("radius")

	-- Create projectile
	local projectileTable =
	{
		EffectName = projectile_name,
		Ability = ability,
		vSpawnOrigin = target.unseen_terror_dummy_position,
		vVelocity = target.unseen_terror_dummy_direction * projectile_speed,
		fDistance = projectile_distance,
		fStartRadius = projectile_radius,
		fEndRadius = projectile_radius,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = true,
		iUnitTargetTeam = ability:GetAbilityTargetTeam(),
		iUnitTargetFlags = ability:GetAbilityTargetFlags(),
		iUnitTargetType = ability:GetAbilityTargetType()
	}
	Timers:CreateTimer(0.2, function()
		caster.unseen_terror_arrow_projectileID = ProjectileManager:CreateLinearProjectile( projectileTable )
	end)
	
	-- Kill the dummy
	Timers:CreateTimer(0.03, function()
		target:RemoveSelf()
	end)
end

function TheUnseenTerrorProjectileHit( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	local damage_table = {}

	damage_table.attacker = caster
	damage_table.victim = target
	damage_table.ability = ability
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.damage = caster.unseen_terror_arrow_damage

	ApplyDamage(damage_table)

	ability:ApplyDataDrivenModifier(caster, target, "modifier_unseen_terror_slow", nil)
end