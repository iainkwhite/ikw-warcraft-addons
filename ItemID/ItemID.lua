SLASH_ITEMID1="/itemid"

SlashCmdList["ITEMID"]=function(msg) local name,link,quality,ilevel=GetItemInfo(msg) 
  if link then ChatFrame1:AddMessage("/ItemID: " .. link .. "  Id: " .. link:match("item:(%d+)") .. "  ilvl: " .. ilevel ) 
  else ChatFrame1:AddMessage("/ItemID: No match")
  end 
end


function addline_itemid()
	itemName,itemLink = ItemRefTooltip:GetItem()
	if itemLink ~= nil then
		local itemString = string.match(itemLink, "item[%-?%d:]+")
		local _, itemId, junk = strsplit(":", itemString)
		local _, _, quality, ilevel = GetItemInfo(itemId)
		ItemRefTooltip:AddLine("ItemID: |cFFFFFFFF"..itemId.."|cFFFFFF00  ilevel: |cFFFFFFFF"..ilevel)
		ItemRefTooltip:Show();
	end
end

function addline_gametip()
	itemName,itemLink = GameTooltip:GetItem()
	if itemLink ~= nil then	   
		local itemString = string.match(itemLink, "item[%-?%d:]+")
		local _, itemId, junk = strsplit(":", itemString)
		local _, _, quality, ilevel = GetItemInfo(itemId)
		GameTooltip:AddLine("ItemID: |cFFFFFFFF"..itemId.."|cFFFFFF00  ilevel: |cFFFFFFFF"..ilevel)
		GameTooltip:Show();
	end
end

ItemRefTooltip:HookScript("OnTooltipSetItem",addline_itemid)
GameTooltip:HookScript("OnTooltipSetItem",addline_gametip)


