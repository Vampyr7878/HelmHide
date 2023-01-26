SLASH_HELMHIDE1 = "/helmhide"
SLASH_HELMHIDE2 = "/hh"

local helmHideHelmButton
local helmHideCloakButton
helmHideButtons = {}

function SlashCmdList.HELMHIDE(msg, editbox)
	if msg == "on" then
		helmHideHelmEnabled = true
		helmHideCloakEnabled = true
		print("Helm Hide Enabled")
	elseif msg == "helm" then
		helmHideHelmEnabled = true
		helmHideCloakEnabled = false
		print("Helm Hide Helm Only Enabled")
	elseif msg == "cloak" then
		helmHideHelmEnabled = false
		helmHideCloakEnabled = true
		print("Helm Hidee Claok Only Enabled")
	elseif msg == "off" then
		helmHideHelmEnabled = false
		helmHideCloakEnabled = false
		print("Helm Hide Disabled")
	end
end

function helmHideFrameOnEvent(self, event, message)
	if helmHideHelmEnabled then
		if IsResting() then
			HelmHideHelmHide()
		else
			HelmHideHelmShow()
		end
	end
	if helmHideCloakEnabled then
		if IsResting() then
			HelmHideCloakHide()
		else
			HelmHideCloakShow()
		end
	end
end

function HelmHideHelmHide()
	PickupInventoryItem(GetInventorySlotInfo("HeadSlot"))
	local helmHideType, helmHideId = GetCursorInfo()
	if helmHideId ~= nil then
		helmHideHelm = GetItemInfo(helmHideId)
		PutItemInBag(C_Container.ContainerIDToInventoryID(4))
	end
end

function HelmHideHelmShow()
	for i = 1, C_Container.GetContainerNumSlots(4) do
		local helmHideId = C_Container.GetContainerItemID(4, i)
		if helmHideId ~= nil then
			local helmHideName = GetItemInfo(helmHideId)
			if helmHideName == helmHideHelm then
				C_Container.PickupContainerItem(4, i)
				PickupInventoryItem(GetInventorySlotInfo("HeadSlot"))
			end
		end
	end
end

function HelmHideHelmToggle()
	PickupInventoryItem(GetInventorySlotInfo("HeadSlot"))
	local helmHideType, helmHideId = GetCursorInfo()
	if helmHideId ~= nil then
		HelmHideHelmHide()
		HelmHideHelmHide()
	else
		HelmHideHelmShow()
	end
end

function HelmHideCloakHide()
	PickupInventoryItem(GetInventorySlotInfo("BackSlot"))
	local helmHideType, helmHideId = GetCursorInfo()
	if helmHideId ~= nil then
		helmHideCloak = GetItemInfo(helmHideId)
		PutItemInBag(C_Container.ContainerIDToInventoryID(4))
	end
end

function HelmHideCloakShow()
	for i = 1, C_Container.GetContainerNumSlots(4) do
		local helmHideId = C_Container.GetContainerItemID(4, i)
		if helmHideId ~= nil then
			local helmHideName = GetItemInfo(helmHideId)
			if helmHideName == helmHideCloak then
				C_Container.PickupContainerItem(4, i)
				PickupInventoryItem(GetInventorySlotInfo("BackSlot"))
			end
		end
	end
end

function HelmHideCloakToggle()
	PickupInventoryItem(GetInventorySlotInfo("BackSlot"))
	local helmHideType, helmHideId = GetCursorInfo()
	if helmHideId ~= nil then
		HelmHideCloakHide()
		HelmHideCloakHide()
	else
		HelmHideCloakShow()
	end
end

function HelmHideCreateButton(icon_on, help, toggle, ...)
	local button = CreateFrame("BUTTON", nil, CharacterModelScene)
	local hilite = button:CreateTexture(nil, "HIGHLIGHT")
	hilite:SetAllPoints()
	hilite:SetTexture("Interface\\Common\\UI-ModelControlPanel")
	hilite:SetTexCoord(0.57812500, 0.82812500, 0.00781250, 0.13281250)
	button:SetWidth(32)
	button:SetHeight(32)
	button:SetPoint(...)
	button:Hide()
	button:SetNormalTexture(icon_on)
	button:RegisterEvent("PLAYER_FLAGS_CHANGED")
	button:RegisterEvent("PLAYER_ENTERING_WORLD")
	button:SetScript("OnEvent", update)
	button:SetScript("OnClick", function()
		toggle()
	end)
	button:SetScript("OnEnter", function()
		button:SetAlpha(1)
		GameTooltip:SetOwner(button, "ANCHOR_TOPRIGHT")
		GameTooltip:SetText(help, nil, nil, nil, nil, 1)
	end)
	button:SetScript("OnLeave", function()
		button:SetAlpha(0.5)
		GameTooltip_Hide()
		helmHideHelmButton:Hide()
		helmHideCloakButton:Hide()
	end)
	button:SetAlpha(0.5)
	CharacterModelScene:HookScript("OnEnter", function()
		button:Show()
	end)
	CharacterModelScene:HookScript("OnLeave", function(self)
		if not self:IsMouseOver() then
			button:Hide()
		end
	end)
	return button
end

function helmHideCheckButton(text, parent, x, y)
	local button = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
	local font = button:CreateFontString(nil, nil, "GameFontNormal")
	font:SetText(text)
	font:SetPoint("LEFT", x + 10, 0)
	button:SetFontString(font)
	button:SetPoint("TOPLEFT", x, y)
	button:Show()
	table.insert(helmHideButtons, button)
end

function helmHideOptionsRefresh()
	helmHideButtons[1]:SetChecked(helmHideHelmEnabled)
	helmHideButtons[2]:SetChecked(helmHideCloakEnabled)
end

function helmHideOptionsOkay()
	helmHideHelmEnabled = helmHideButtons[1]:GetChecked()
	helmHideCloakEnabled = helmHideButtons[2]:GetChecked()
end

local helmHideFrame = CreateFrame("FRAME", nil, UIParent)
helmHideFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
helmHideFrame:RegisterEvent("PLAYER_UPDATE_RESTING");
helmHideFrame:RegisterEvent("ZONE_CHANGED");
helmHideFrame:RegisterEvent("ZONE_CHANGED_INDOORS");
helmHideFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
helmHideFrame:RegisterEvent("PLAYER_LOGIN");
helmHideFrame:SetScript("OnEvent", helmHideFrameOnEvent)

helmHideHelmButton = HelmHideCreateButton("Interface\\AddOns\\HelmHide\\HelmShow", SHOW_HELM, HelmHideHelmToggle, "BOTTOMLEFT", 5, 5)

helmHideCloakButton = HelmHideCreateButton("Interface\\AddOns\\HelmHide\\CloakShow", SHOW_CLOAK, HelmHideCloakToggle, "BOTTOMRIGHT", -5, 5)

local helmHideOptions = CreateFrame("FRAME")
helmHideOptions.name = "Helm Hide"
helmHideCheckButton("Enable autohiding helmet", helmHideOptions, 20, -20)
helmHideCheckButton("Enable autohiding cloak", helmHideOptions, 20, -50)
helmHideOptions.refresh = helmHideOptionsRefresh
helmHideOptions.okay = helmHideOptionsOkay
helmHideOptions.cancel = helmHideOptionsRefresh
InterfaceOptions_AddCategory(helmHideOptions)