local HelmHide = LibStub("AceAddon-3.0"):NewAddon("HelmHide")

SLASH_HELMHIDE1 = "/helmhide"
SLASH_HELMHIDE2 = "/hh"

HelmHide.Buttons = {}

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

function HelmHide:FrameOnEvent()
	if helmHideHelmEnabled then
		if IsResting() then
			HelmHide:HelmHide()
		else
			HelmHide:HelmShow()
		end
	end
	if helmHideCloakEnabled then
		if IsResting() then
			HelmHide:CloakHide()
		else
			HelmHide:CloakShow()
		end
	end
end

function HelmHide:HelmHide()
	PickupInventoryItem(GetInventorySlotInfo("HeadSlot"))
	local type, id = GetCursorInfo()
	if id ~= nil then
		self.Helm = C_Item.GetItemInfo(id)
		PutItemInBag(C_Container.ContainerIDToInventoryID(4))
	end
end

function HelmHide:HelmShow()
	for i = 1, C_Container.GetContainerNumSlots(4) do
		local id = C_Container.GetContainerItemID(4, i)
		if id ~= nil then
			name = C_Item.GetItemInfo(id)
			if name == self.Helm then
				C_Container.PickupContainerItem(4, i)
				PickupInventoryItem(GetInventorySlotInfo("HeadSlot"))
			end
		end
	end
end

function HelmHide:HelmToggle()
	PickupInventoryItem(GetInventorySlotInfo("HeadSlot"))
	local type, id = GetCursorInfo()
	if id ~= nil then
		HelmHide:HelmHide()
		HelmHide:HelmHide()
	else
		HelmHide:HelmShow()
	end
end

function HelmHide:CloakHide()
	PickupInventoryItem(GetInventorySlotInfo("BackSlot"))
	local type, id = GetCursorInfo()
	if id ~= nil then
		self.Cloak = C_Item.GetItemInfo(id)
		PutItemInBag(C_Container.ContainerIDToInventoryID(4))
	end
end

function HelmHide:CloakShow()
	for i = 1, C_Container.GetContainerNumSlots(4) do
		local id = C_Container.GetContainerItemID(4, i)
		if id ~= nil then
			local name = C_Item.GetItemInfo(id)
			if name == self.Cloak then
				C_Container.PickupContainerItem(4, i)
				PickupInventoryItem(GetInventorySlotInfo("BackSlot"))
			end
		end
	end
end

function HelmHide:CloakToggle()
	PickupInventoryItem(GetInventorySlotInfo("BackSlot"))
	local type, id = GetCursorInfo()
	if id ~= nil then
		HelmHide:CloakHide()
		HelmHide:CloakHide()
	else
		HelmHide:CloakShow()
	end
end

function HelmHide:CreateButton(icon_on, help, toggle, ...)
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
		self.HelmButton:Hide()
		self.CloakButton:Hide()
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

function HelmHide:OnInitialize()
	self.Frame = CreateFrame("FRAME", nil, UIParent)
	self.Frame:RegisterEvent("PLAYER_ENTERING_WORLD");
	self.Frame:RegisterEvent("PLAYER_UPDATE_RESTING");
	self.Frame:RegisterEvent("ZONE_CHANGED");
	self.Frame:RegisterEvent("ZONE_CHANGED_INDOORS");
	self.Frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	self.Frame:RegisterEvent("PLAYER_LOGIN");
	self.Frame:SetScript("OnEvent", self.FrameOnEvent)
	self.HelmButton = HelmHide:CreateButton("Interface\\AddOns\\HelmHide\\HelmShow", SHOW_HELM, self.HelmToggle, "BOTTOMLEFT", 5, 5)
	self.CloakButton = HelmHide:CreateButton("Interface\\AddOns\\HelmHide\\CloakShow", SHOW_CLOAK, self.CloakToggle, "BOTTOMRIGHT", -5, 5)
	local options = {
		name = "Helm Hide",
		handler = HelmHide,
		type = "group",
		args = {
			helm = {
				name = "Enable autohiding helmet",
				type = "toggle",
				desc = "Enable autohiding helmet when enter resting area",
				width = "full",
				set = "SetHelm",
				get = "GetHelm",
			},
			cloak = {
				name = "Enable autohiding cloak",
				type = "toggle",
				desc = "Enable autohiding cloak when enter resting area",
				width = "full",
				set = "SetClolak",
				get = "GetClolak",
			}
		}
	}
	LibStub("AceConfig-3.0"):RegisterOptionsTable("HelmHide", options, nil)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("HelmHide", "Helm Hide")
end

function HelmHide:SetHelm(info, val)
	helmHideHelmEnabled = val
end

function HelmHide:GetHelm(info)
	return helmHideHelmEnabled
end

function HelmHide:SetClolak(info, val)
	helmHideCloakEnabled = val
end

function HelmHide:GetClolak(info)
	return helmHideCloakEnabled
end