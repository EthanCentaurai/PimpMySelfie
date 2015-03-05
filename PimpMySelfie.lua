
--<< ================================================= >>--
--     Upvalues                                          --
--<< ================================================= >>--

local _G = _G

local ActionStatus = _G.ActionStatus
local CreateFrame = _G.CreateFrame
local GetCVar = _G.GetCVar
local SetCVar = _G.SetCVar
local UnitBuff = _G.UnitBuff

local pairs = _G.pairs


--<< ================================================= >>--
--     Local Variables                                   --
--<< ================================================= >>--

local isTakingSelfie = false

local cVars = {
	-- player name
	["UnitNameOwn"] = GetCVar("UnitNameOwn"),

	-- npc names
	["UnitNameFriendlySpecialNPCName"] = GetCVar("UnitNameFriendlySpecialNPCName"),
	["UnitNameHostileNPC"] = GetCVar("UnitNameHostileNPC"),
	["UnitNameNPC"] = GetCVar("UnitNameNPC"),
	["UnitNameNonCombatCreatureName"] = GetCVar("UnitNameNonCombatCreatureName"),

	-- friendly players
	["UnitNameFriendlyPlayerName"] = GetCVar("UnitNameFriendlyPlayerName"),
	["UnitNameFriendlyPetName"] = GetCVar("UnitNameFriendlyPetName"),
	["UnitNameFriendlyGuardianName"] = GetCVar("UnitNameFriendlyGuardianName"),
	["UnitNameFriendlyTotemName"] = GetCVar("UnitNameFriendlyTotemName"),

	-- enemy players
	["UnitNameEnemyPlayerName"] = GetCVar("UnitNameEnemyPlayerName"),
	["UnitNameEnemyPetName"] = GetCVar("UnitNameEnemyPetName"),
	["UnitNameEnemyGuardianName"] = GetCVar("UnitNameEnemyGuardianName"),
	["UnitNameEnemyTotemName"] = GetCVar("UnitNameEnemyTotemName"),

	-- nameplates
	["nameplateShowFriends"] = GetCVar("nameplateShowFriends"),
	["nameplateShowEnemies"] = GetCVar("nameplateShowEnemies"),
}


--<< ================================================= >>--
--     The Part Where the Magic Happens                  --
--<< ================================================= >>--

local PimpMySelfie = CreateFrame("Frame")

function PimpMySelfie:UPDATE_OVERRIDE_ACTIONBAR()
--	isTakingSelfie = UnitBuff("player", "S.E.L.F.I.E. Camera")

	local i = 1
	local _, name, spellID

	-- there is probably a better way to do this
	while true do
		name, _, _, _, _, _, _, _, _, _, spellID = UnitBuff("player", i)

		if not name then
			isTakingSelfie = false
			break
		end

		if spellID == 181765 or spellID == 181884 then
			isTakingSelfie = true
			break
		end

		i = i + 1
	end

	if isTakingSelfie then
		-- hide "screenshot taken" text
		ActionStatus:UnregisterEvent("SCREENSHOT_SUCCEEDED")
		ActionStatus:UnregisterEvent("SCREENSHOT_FAILED")

		-- hide names and nameplates
		for cVar, _ in pairs(cVars) do
			cVars[cVar] = GetCVar(cVar)
			SetCVar(cVar, 0)
		end
	else
		ActionStatus:RegisterEvent("SCREENSHOT_SUCCEEDED")
		ActionStatus:RegisterEvent("SCREENSHOT_FAILED")

		for cVar, value in pairs(cVars) do
			SetCVar(cVar, cVars[cVar])
		end
	end
end

PimpMySelfie:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR")
PimpMySelfie:SetScript("OnEvent", PimpMySelfie.UPDATE_OVERRIDE_ACTIONBAR)
PimpMySelfie:Hide()
