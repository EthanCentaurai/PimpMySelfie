
--<< ================================================= >>--
--     Upvalues                                          --
--<< ================================================= >>--

local _G = _G

local ActionStatus = _G.ActionStatus
local CreateFrame = _G.CreateFrame
local UnitBuff = _G.UnitBuff


--<< ================================================= >>--
--     Local Variables                                   --
--<< ================================================= >>--

local isTakingSelfie = false


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
		ActionStatus:UnregisterEvent("SCREENSHOT_SUCCEEDED")
		ActionStatus:UnregisterEvent("SCREENSHOT_FAILED")
	else
		ActionStatus:RegisterEvent("SCREENSHOT_SUCCEEDED")
		ActionStatus:RegisterEvent("SCREENSHOT_FAILED")
	end
end

PimpMySelfie:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR")
PimpMySelfie:SetScript("OnEvent", PimpMySelfie.UPDATE_OVERRIDE_ACTIONBAR)
PimpMySelfie:Hide()
