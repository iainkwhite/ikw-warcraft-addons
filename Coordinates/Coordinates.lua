-- Coordinates
-- Updated for 8.1
-- Previous versions by Szandos

--Variables
local Coordinates_UpdateInterval = 0.2
local timeSinceLastUpdate = 0
local color = "|cff00ffff"
local fontStyle = "Fonts\\FRIZQT__.TTF"
local fontOutline = "OUTLINE"

-------------------------------------------------------------------------------

-- Need a frame for events
local Coordinates_eventFrame = CreateFrame("Frame")
Coordinates_eventFrame:RegisterEvent("VARIABLES_LOADED")
Coordinates_eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
Coordinates_eventFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
Coordinates_eventFrame:RegisterEvent("ZONE_CHANGED")
Coordinates_eventFrame:SetScript("OnEvent",function(self,event,...) self[event](self,event,...);end)

-- Create slash command
SLASH_COORDINATES1 = "/coordinates"
SLASH_COORDINATES2 = "/coord"

-- Handle slash commands
function SlashCmdList.COORDINATES(msg)
	msg = string.lower(msg)
	local command, rest = msg:match("^(%S*)%s*(.-)$")
	if (command == "worldmap" or command =="w") then
		if CoordinatesDB["worldmap"] == true then 
			CoordinatesDB["worldmap"] = false
			DEFAULT_CHAT_FRAME:AddMessage(color.."Coordinates: World map coordinates disabled")
		else
			CoordinatesDB["worldmap"] = true
			DEFAULT_CHAT_FRAME:AddMessage(color.."Coordinates: World map coordinates enabled")
		end
	elseif (command == "minimap" or command =="m") then
		if CoordinatesDB["minimap"] == true then 
			CoordinatesDB["minimap"] = false
			MinimapZoneText:SetText( GetMinimapZoneText() )
			DEFAULT_CHAT_FRAME:AddMessage(color.."Coordinates: Mini map coordinates disabled")
		else
			CoordinatesDB["minimap"] = true
			DEFAULT_CHAT_FRAME:AddMessage(color.."Coordinates: Mini map coordinates enabled")
		end
	elseif (command == "size" or command =="fontsize") then
		rest = tonumber(rest)
		if rest >= 6 and rest <= 15 then
			CoordinatesDB["fontSize"] = rest
			DEFAULT_CHAT_FRAME:AddMessage(color.."Coordinates: Font size set to "..CoordinatesDB["fontSize"])
		else
			DEFAULT_CHAT_FRAME:AddMessage(color.."Coordinates: Invalid font size - must be between 6 and 15")
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage(color.."Coordinates")
		DEFAULT_CHAT_FRAME:AddMessage(color.."Version: "..GetAddOnMetadata("Coordinates", "Version"))
		DEFAULT_CHAT_FRAME:AddMessage(color.."Usage:")
		DEFAULT_CHAT_FRAME:AddMessage(color.."/coordinates worldmap - Enable/disable coordinates on the world map")
		DEFAULT_CHAT_FRAME:AddMessage(color.."/coordinates minimap - Enable/disable coordinates on the mini-map")
		DEFAULT_CHAT_FRAME:AddMessage(color.."/coordinates fontsize <size> - Sets the size of the mini-map font")
	end
end

--Event handler
function Coordinates_eventFrame:VARIABLES_LOADED()
	if (not CoordinatesDB) then
		CoordinatesDB = {}
		CoordinatesDB["worldmap"] = true
		CoordinatesDB["minimap"] = true
		CoordinatesDB["fontSize"] = 9
	elseif not CoordinatesDB["fontSize"] then
		CoordinatesDB["fontSize"] = 9
	end
	Coordinates_eventFrame:SetScript("OnUpdate", function(self, elapsed) Coordinates_OnUpdate(self, elapsed) end)
end

function Coordinates_eventFrame:ZONE_CHANGED_NEW_AREA()
	Coordinates_UpdateCoordinates()
end

function Coordinates_eventFrame:ZONE_CHANGED_INDOORS()
	Coordinates_UpdateCoordinates()
end

function Coordinates_eventFrame:ZONE_CHANGED()
	Coordinates_UpdateCoordinates()
end

--OnUpdate
function Coordinates_OnUpdate(self, elapsed)
	timeSinceLastUpdate = timeSinceLastUpdate + elapsed
	if (timeSinceLastUpdate > Coordinates_UpdateInterval) then
		-- Update the update time
		timeSinceLastUpdate = 0
		Coordinates_UpdateCoordinates()
	end
end

function Coordinates_UpdateCoordinates()
	--MinimapCoordinates
	local mapID
	local position
	if (CoordinatesDB["minimap"] and Minimap:IsVisible()) then
		mapID = C_Map.GetBestMapForUnit("player")
		if (mapID) then
			position = C_Map.GetPlayerMapPosition(mapID,"player")
			if (position and position.x ~= 0 and position.y ~= 0 ) then
				MinimapZoneText:SetText( format("(%d:%d) ",position.x*100.0,position.y*100.0) .. GetMinimapZoneText() );
			end
			MinimapZoneText:SetFont(fontStyle, CoordinatesDB["fontSize"], fontOutline)
		end
	end

	--WorldMapCoordinates
 	if (CoordinatesDB["worldmap"] and WorldMapFrame:IsVisible()) then
		-- Get the cursor's coordinates
		local cursorX, cursorY = GetCursorPosition()

		-- Calculate cursor position
		local scale = WorldMapFrame:GetCanvas():GetEffectiveScale()
		cursorX = cursorX / scale
		cursorY = cursorY / scale
		local width = WorldMapFrame:GetCanvas():GetWidth()
		local height = WorldMapFrame:GetCanvas():GetHeight()
		local left = WorldMapFrame:GetCanvas():GetLeft()
		local top = WorldMapFrame:GetCanvas():GetTop()
		cursorX = max(min((cursorX - left) / width * 100, 100),0)
		cursorY = max(min((top - cursorY) / height * 100, 100),0)
		local worldmapCoordsText = "Cursor(X,Y): "..format("%.1f , %.1f    ", cursorX, cursorY)
		-- Player position
		if (not mapID) then
			mapID = C_Map.GetBestMapForUnit("player")
		end
		if (mapID) then
			position = C_Map.GetPlayerMapPosition(mapID,"player")
		end
		if (position and position.x ~= 0 and position.y ~= 0 ) then
			worldmapCoordsText = worldmapCoordsText.." Player(X,Y): "..format("%.1f , %.1f", position.x * 100, position.y * 100)
		else
			worldmapCoordsText = worldmapCoordsText.." Player(X,Y): n/a"
		end
		-- Add text to world map
		WorldMapFrame.BorderFrame.TitleText:SetText(worldmapCoordsText)
	elseif (WorldMapFrame:IsVisible()) then
		WorldMapFrame.BorderFrame.TitleText:SetText(MAP_AND_QUEST_LOG)
	end
end