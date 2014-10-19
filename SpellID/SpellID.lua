SLASH_SPELLID1="/spellid"

SlashCmdList["SPELLID"]=function(msg) local link,tradelink=GetSpellLink(msg) 
  if link then ChatFrame1:AddMessage("/SpellID: " .. link .. "  Id: " .. link:match("spell:(%d+)")) 
  else ChatFrame1:AddMessage("/SpellID: No match")
  end 
end



