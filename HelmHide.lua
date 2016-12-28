function helmHideFrameOnEvent(self, event, message)
	if IsResting() then
		HelmHideHide()
	else
		HelmHideShow()
	end
end

function HelmHideHide()
	PickupInventoryItem(GetInventorySlotInfo("HeadSlot"))
	helmHideType, helmHideId = GetCursorInfo()
	if helmHideId ~= nil then
		helmHideHelm = GetItemInfo(helmHideId)
		PutItemInBag(ContainerIDToInventoryID(4))
	end
end

function HelmHideShow()
	for i = 1, GetContainerNumSlots(4) do
		local helmHideId = GetContainerItemID(4, i)
		if helmHideId ~= nil then
			local helmHideName = GetItemInfo(helmHideId)
			if helmHideName == helmHideHelm then
				PickupContainerItem(4, i)
				PickupInventoryItem(GetInventorySlotInfo("HeadSlot"))
			end
		end
	end
end

local helmHideFrame = CreateFrame("FRAME", nil, UIParent)
helmHideFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
helmHideFrame:RegisterEvent("PLAYER_UPDATE_RESTING");
helmHideFrame:RegisterEvent("ZONE_CHANGED");
helmHideFrame:RegisterEvent("ZONE_CHANGED_INDOORS");
helmHideFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
helmHideFrame:RegisterEvent("PLAYER_LOGIN");
helmHideFrame:SetScript("OnEvent", helmHideFrameOnEvent)