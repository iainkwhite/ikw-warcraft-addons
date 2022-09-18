SLASH_QCHECK1="/qcheck"

SlashCmdList["QCHECK"]=function(msg) local result=IsQuestFlaggedCompleted(msg) 
  if result then ChatFrame1:AddMessage("/Qcheck: Quest " .. msg .. " Completed") 
  else ChatFrame1:AddMessage("/Qcheck: Quest not completed or no match for quest " .. msg)
  end 
end
