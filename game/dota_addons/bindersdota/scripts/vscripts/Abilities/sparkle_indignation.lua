-- Start indignation
function indignation_start(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	ability.bounceTable = {}

	ability_indignation_bolt = caster:FindAbilityByName("sparkle_indignation_bolt")
	if ability_indignation_bolt ~= nil then
		ability.damage = ability_indignation_bolt:GetAbilityDamage()
	else
		ability.damage = 1000
	end

	ability.radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	ability.bolt_interval = ability:GetLevelSpecialValueFor("bolt_interval", ability:GetLevel() - 1)
	ability.bolts = ability:GetLevelSpecialValueFor("bolts", ability:GetLevel() - 1) 

	for delay = 0, (ability.bolts-1) * ability.bolt_interval, ability.bolt_interval do
		Timers:CreateTimer(delay, function ()
				if caster:IsAlive() == false then
					return
				end
				local newOrder = {
			 		UnitIndex = caster:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			 		AbilityIndex = caster:FindAbilityByName("sparkle_indignation_bolt"):entindex()
			 	}
				ExecuteOrderFromTable(newOrder)
			end)
	end 
end

-- Upgrade Indignation bolt
function indignation_upgrade(keys)
	local indignation_bolt_ability = keys.caster:FindAbilityByName("sparkle_indignation_bolt")
	local indignation_level = keys.ability:GetLevel()
	
	if indignation_bolt_ability ~= nil and indignation_bolt_ability:GetLevel() ~= indignation_level then
		indignation_bolt_ability:SetLevel(indignation_level)
	end
end