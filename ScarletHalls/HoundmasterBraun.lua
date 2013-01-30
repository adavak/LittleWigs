
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Houndmaster Braun", 871, 660)
mod:RegisterEnableMob(59303)

local percent = 90

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_say = "Hmm, did you hear something lads?"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {"ej:5611", 114259, "bosskill"}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "BloodyRage", 116140)
	self:Log("SPELL_CAST_SUCCESS", "CallDog", 114259)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 59303)
end

function mod:OnEngage()
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "RageWarn", "boss1")
	percent = 90
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CallDog(args)
	self:Message(args.spellId, ("%d%% - %s"):format(percent, args.spellName), "Urgent", args.spellId, "Alert")
	percent = percent - 10
end

function mod:BloodyRage(args)
	self:Message("ej:5611", "50% - "..args.spellName, "Attention", args.spellId, "Alert")
end

function mod:RageWarn(unitId)
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	if hp < 55 then
		self:Message("ej:5611", CL["soon"]:format(self:SpellName(116140)), "Positive", nil, "Info") -- Bloody Rage
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unitId)
	end
end

