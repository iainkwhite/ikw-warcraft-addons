
fishfeast = CreateFrame("Frame")
fishfeast:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
fishfeast:RegisterEvent("PLAYER_REGEN_DISABLED")
fishfeast:RegisterEvent("PLAYER_REGEN_ENABLED")

fishfeast:SetScript("OnEvent", function( self, event, ...)
  if event == "PLAYER_REGEN_DISABLED" then
    fishfeast:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")  -- dont parse while in combat
  elseif event == "PLAYER_REGEN_ENABLED" then
    fishfeast:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")  -- parse when out of combat
  elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
  	local timestamp, subevent, hideCaster, srcGUID, srcname, srcflags, srcflags2, dstGUID, dstname, dstflags, dstflags2, spellID, spellname, spellschool, extraspellID, extraspellname, extraspellschool, auratype = ... 
  	if subevent == "SPELL_CAST_START" then
	  	if spellID == 87644 or spellID == 87643 or spellID == 87915 or spellID == 57426 or spellID == 57301 or spellID == 43808 or spellID == 66476 or spellID == 92649 or spellID == 92712 then  -- Seafood Magnifique Feast, Broiled Dragon Feast, Goblin BBQ, Fish Feast, Great Feast, Brewfest Pony Keg, Bountiful Feast, Cauldron of Battle, Big Cauldron
 	  		Fishfeast_msg(srcname .. " has created a " .. GetSpellLink(spellID) ) 
	  	elseif spellID == 87226 or spellID == 87228 or spellID == 87230 or spellID == 87232 or spellID == 87234 or spellID == 87236 or spellID == 87238 or spellID == 87240 or spellID == 87242 or spellID == 87244 or spellID == 87246 or spellID == 87248 then  -- various Pandaren feasts
 	  		Fishfeast_msg(srcname .. " has created a " .. GetSpellLink(spellID) ) 
  		end
  	elseif subevent == "SPELL_CAST_SUCCESS" then
  		if spellID == 116133 or spellID == 29893 then  -- Ritual of Refreshment, Ritual of Souls 
  			Fishfeast_msg(srcname .. " has cast a " .. GetSpellLink(spellID) ) 
  		elseif spellID == 67826 then -- Jeeves
  			Fishfeast_msg(srcname .. " has created a " .. GetSpellLink(spellID) .. ", 'You rang, Sir?' " ) 
  		elseif spellID == 54711 or spellID == 22700 or spellID == 44389 or spellID == 54710 then -- Scrapbot, Field repair Bot 74A, F-r Bot 100G, Moll-E
  			Fishfeast_msg(srcname .. " has created a " .. GetSpellLink(spellID) ) 
  		elseif spellID == 126459 then -- BlingoTron
  			Fishfeast_msg(srcname .. " has created a " .. GetSpellLink(spellID) ) 
  		end
  	end
  end
end)

function Fishfeast_msg(text)
 	local channel =  UnitInRaid("player") and "RAID" or UnitInParty("player") and "PARTY" or "PRINT" 
  if channel == "PRINT" then DEFAULT_CHAT_FRAME:AddMessage(text)
  else SendChatMessage(text, channel)
  end
end
