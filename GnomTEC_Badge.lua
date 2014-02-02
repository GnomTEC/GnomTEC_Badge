GnomTEC_Badge_Player = {
	["Versions"] = {},
	["Fields"] = {
		["NA"] = UnitName("player"),
		["NT"] = "",
		["FR"] = nil,
		["FC"] = nil,
		["DE"] = "",
	},
}

GnomTEC_Badge_Flags = {
	[GetRealmName()] = {
		[UnitName("player")] = {};
	},
}

GnomTEC_Badge_Options = {
	["MouseOver"] = false,
	["LockOnTarget"] = true,
	["AutoHide"] = true,	
	["DisableInCombat"] = true,
}
 

local str_fr = {"Rollenspieler","Gelegenheits-Rollenspieler","Vollzeit-Rollenspieler","Rollenspielneuling","Erwachsener Rollenspieler",}
local str_fc = {"Außerhalb des Rollenspiels (OOC)", "Im Rollenspiel (IC)", "Suche Kontakt", "Erzähler (SL)",}

local playerisInCombat = false;

local options = {
	name = "GnomTEC Badge " .. GetAddOnMetadata("GnomTEC_Badge", "Version"),
	type = 'group',
	args = {
		badgeOptions = {
			name = "GnomTEC Badge",
			desc = '',
			order = 1,
			type = 'group',
			args = {
				badgePlayerProfile = {
					name = "Character Profil",
					type = 'group',
					order = 1,
					guiInline = true,
					args = {
						badgePlayerNA = {
							type = "input",
							name = "Name",
							desc = "",
							set = function(info,val) GnomTEC_Badge_Player["Fields"]["NA"] = val; GnomTEC_Badge:SetMSP() end,
	   		   				get = function(info) return GnomTEC_Badge_Player["Fields"]["NA"] end,
							multiline = false,
							width = 'full',
							order = 1
						},
						badgePlayerNT = {
							type = "input",
							name = "Titel",
							desc = "",
							set = function(info,val) GnomTEC_Badge_Player["Fields"]["NT"] = val; GnomTEC_Badge:SetMSP() end,
    		  				get = function(info) return GnomTEC_Badge_Player["Fields"]["NT"] end,
							multiline = false,
							width = 'full',
							order = 2
						},
						badgePlayerDE = {
							type = "input",
							name = "Beschreibung",
							desc = "",
							set = function(info,val) GnomTEC_Badge_Player["Fields"]["DE"] = val; GnomTEC_Badge:SetMSP() end,
     		 				get = function(info) return GnomTEC_Badge_Player["Fields"]["DE"] end,
							multiline = 13,
							width = 'full',
							order = 3
						},
						badgePlayerFR = {
							type = "select",
							name = "Rollenspielerfahrung",
							desc = "",
							set = function(info,val) GnomTEC_Badge_Player["Fields"]["FR"] = val; GnomTEC_Badge:SetMSP() end,
      						get = function(info) return GnomTEC_Badge_Player["Fields"]["FR"] end,
							values = str_fr,
							order = 4
						},
						badgePlayerFC = {
							type = "select",
							name = "Rollenspielstatus",
							desc = "",
							set = function(info,val) GnomTEC_Badge_Player["Fields"]["FC"] = val; GnomTEC_Badge:SetMSP() end,
      						get = function(info) return GnomTEC_Badge_Player["Fields"]["FC"] end,
							values = str_fc,
							order = 5
						},
					},
				},
				badgeOptions = {
					name = "Anzeigeoptionen",
					type = 'group',
					order = 2,
					guiInline = true,
					args = {
						badgeOptionMouseOver = {
							type = "toggle",
							name = "Zeige Rollenspielflag auch bei MouseOver.",
							desc = "",
							set = function(info,val) GnomTEC_Badge_Options["MouseOver"] = val end,
	   		   				get = function(info) return GnomTEC_Badge_Options["MouseOver"] end,
							width = 'full',
							order = 1
						},
						badgeOptionLockOnTarget = {
							type = "toggle",
							name = "Bevorzuge Target vor MouseOver bei der Anzeige.",
							desc = "",
							set = function(info,val) GnomTEC_Badge_Options["LockOnTarget"] = val end,
	   		   				get = function(info) return GnomTEC_Badge_Options["LockOnTarget"] end,
							width = 'full',
							order = 2
						},
						badgeOptionAutoHide = {
							type = "toggle",
							name = "Verstecke Rollenspielflag automatisch.",
							desc = "",
							set = function(info,val) GnomTEC_Badge_Options["AutoHide"] = val end,
	   		   				get = function(info) return GnomTEC_Badge_Options["AutoHide"] end,
							width = 'full',
							order = 3
						},
						badgeOptionDisableInCombat = {
							type = "toggle",
							name = "Während des Kampfes keine Flags anzeigen oder aktualisieren.",
							desc = "",
							set = function(info,val) GnomTEC_Badge_Options["DisableInCombat"] = val end,
	   		   				get = function(info) return GnomTEC_Badge_Options["DisableInCombat"] end,
							width = 'full',
							order = 4
						},
					},
				},
			},
		},
	},
}

local displayedPlayerName = ""
local displayedPlayerRealm = ""
local displayedPlayerNote = false;


GnomTEC_Badge = LibStub("AceAddon-3.0"):NewAddon("GnomTEC_Badge", "AceConsole-3.0", "AceEvent-3.0")
LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC_Badge", options, nil)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC_Badge", "GnomTEC Badge", nil, "badgeOptions");

-- Detect any other MSP AddOn and bail out in case of conflict
if _G.msp_RPAddOn or _G.mrp then
 	StaticPopupDialogs[ "GNOMTEC_BADGE_MSP_CONFLICT" ] = {
		text = format( "ERROR: You can only use one MSP AddOn at once, but you have both GnomTEC_Badge and %s loaded.\n\nAll MSP AddOns can communicate with each other, but please do not try to use more than one at once as conflicts will arise.", tostring(_G.msp_RPAddOn) or "another MSP AddOn" ),
		button1 = OKAY or "OK",
		whileDead = true,
		timeout = 0,
	}
	StaticPopup_Show( "GNOMTEC_BADGE_MSP_CONFLICT" )
	return
end 
_G.msp_RPAddOn = "GnomTEC_Badge"


function GnomTEC_Badge:OnInitialize()
 	-- Code that you want to run when the addon is first loaded goes here.
  
  	GnomTEC_Badge:Print("Willkommen bei GnomTEC_Badge")

end

function GnomTEC_Badge:AddToVAString( addon )
	if not select( 4, GetAddOnInfo( addon ) ) then return end
	msp.my['VA'] = strtrim( format( "%s;%s/%s%s", (msp.my['VA'] or ""), addon, 
		( GetAddOnMetadata( addon, "Version" ) or "" ), 
		(	(GetAddOnMetadata( addon, "X-Test" )=="Alpha" and "a") or 
			(GetAddOnMetadata( addon, "X-Test" )=="Beta" and "b") or "" ) ), "; " )
end

local function emptynil( x ) return x ~= "" and x or nil end

function GnomTEC_Badge:SaveFlag(realm, player)
	-- for first experiments taken from FlagRSP2
	if not GnomTEC_Badge_Flags[realm] then GnomTEC_Badge_Flags[realm] = {} end
	if not GnomTEC_Badge_Flags[realm][player] then GnomTEC_Badge_Flags[realm][player] = {} end
	local r = GnomTEC_Badge_Flags[realm][player]
	
	r.FlagMSP = true
	r.timeStamp = time()
	r.faction = faction
	local p = msp.char[ player ]
	r.NA = emptynil( strtrim( p.field.NA ) )
	if ( tonumber( p.field.FC ) or -1 ) > 0 then
		r.FC = tonumber( p.field.FC )
	elseif p.field.FC == "0" then
		r.FC = nil
	else
		r.FC = emptynil( strtrim( p.field.FC ) )
	end
	if ( tonumber( p.field.FR ) or -1 ) > 0 then
		r.FR = tonumber( p.field.FR )
	elseif p.field.FR == "Mature" then
		r.FR = 5
	elseif p.field.FR == "0" then
		r.FR = nil
	else
		r.FR = emptynil( strtrim( p.field.FR ) )
	end
	r.NT = emptynil( strtrim( p.field.NT ) )
	r.DE = emptynil( strtrim( p.field.DE ) )	

end

function GnomTEC_Badge:SetMSP()
	local playername = UnitName("player")

	wipe( msp.my )
	wipe( msp.char[ playername ].field )

	for field, value in pairs( GnomTEC_Badge_Player.Fields ) do
		msp.my[ field ] = value
	end

	-- Fields not set by the user
	msp.my['VP'] = tostring( msp.protocolversion )
	msp.my['VA'] = ""
	GnomTEC_Badge:AddToVAString( "MyRolePlay" )
	GnomTEC_Badge:AddToVAString( "flagRSP2" )
	GnomTEC_Badge:AddToVAString( "GHI" )
	GnomTEC_Badge:AddToVAString( "Lore" )
	GnomTEC_Badge:AddToVAString( "Tongues" )

	msp.my['GU'] = UnitGUID("player")
	msp.my['GS'] = tostring( UnitSex("player") )
	msp.my['GC'] = select( 2, UnitClass("player") )
	msp.my['GR'] = select( 2, UnitRace("player") )

	msp:Update()

	for field, ver in pairs( msp.myver ) do
		GnomTEC_Badge_Player.Versions[ field ] = ver
		msp.char[ playername ].ver[ field ] = ver
		msp.char[ playername ].field[ field ] = msp.my[ field ]
		msp.char[ playername ].time[ field ] = 999999999
	end

	msp.char[ playername ].supported = true
	
	GnomTEC_Badge:SaveFlag(GetRealmName(), playername)

end

function GnomTEC_Badge:FlagRSP_DPULL(realm, player)
	local id = GetChannelName("xtensionxtooltip2");

	if not (id >= 1) then 
		JoinPermanentChannel("xtensionxtooltip2", "", DEFAULT_CHAT_FRAME:GetID(), 1);
		id = GetChannelName("xtensionxtooltip2");
	end
	SendChatMessage("<DPULL>" .. player, "CHANNEL", nil, id);
end


function GnomTEC_Badge:OnEnable()
    -- Called when the addon is enabled

	GnomTEC_Badge:Print("GnomTEC_Badge Enabled")
	GnomTEC_Badge:RegisterEvent("CURSOR_UPDATE");
	GnomTEC_Badge:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
	GnomTEC_Badge:RegisterEvent("PLAYER_TARGET_CHANGED");
	GnomTEC_Badge:RegisterEvent("CHAT_MSG_CHANNEL");
	GnomTEC_Badge:RegisterEvent("PLAYER_REGEN_DISABLED");
	GnomTEC_Badge:RegisterEvent("PLAYER_REGEN_ENABLED");
	
	table.insert( msp.callback.received, GnomTEC_Badge_MSPcallback )

	-- Restore saved versions
	for field, ver in pairs( GnomTEC_Badge_Player.Versions ) do
		msp.myver[ field ] = ver
	end
	GnomTEC_Badge:SetMSP()
	
	local player, realm = UnitName("player")
    realm = realm or GetRealmName()
	if not GnomTEC_Badge_Flags[realm] then GnomTEC_Badge_Flags[realm] = {} end
    if not GnomTEC_Badge_Flags[realm][player] then GnomTEC_Badge_Flags[realm][player] = {} end
	GnomTEC_Badge_Flags[realm][player].Guild = emptynil(GetGuildInfo("player"))	
	GnomTEC_Badge_Flags[realm][player].EngineData = "Stufe "..UnitLevel("player").." "..UnitRace("player").." "..UnitClass("player")	
	GNOMTEC_BADGE_FRAME_PLAYERMODEL:SetUnit("player")
	GNOMTEC_BADGE_FRAME_PLAYERMODEL:SetCamera(0)
	GnomTEC_Badge:DisplayBadge(realm, player)
	
end

function GnomTEC_Badge:OnDisable()
    -- Called when the addon is disabled
    
    GnomTEC_Badge:UnregisterAllEvents();
    table.vanish( msp.callback.received, GnomTEC_Badge_MSPcallback )
end

function GnomTEC_Badge:PLAYER_REGEN_DISABLED(event)
	playerisInCombat = true;
	GNOMTEC_BADGE_FRAME:Hide();
end

function GnomTEC_Badge:PLAYER_REGEN_ENABLED(event)
	playerisInCombat = false;
end

function GnomTEC_Badge:DisplayBadge(realm, player)

	displayedPlayerRealm = realm;
	displayedPlayerName = player;
	
	if (GnomTEC_Badge_Flags[realm][player]) then	
		local f = GnomTEC_Badge_Flags[realm][player].FRIEND or 0;
		if (f < 0) then
			GNOMTEC_BADGE_FRAME_NA:SetText("|cffff0000"..(GnomTEC_Badge_Flags[realm][player].NA or player).."|r")
		elseif (f > 0) then
			GNOMTEC_BADGE_FRAME_NA:SetText("|cff00ff00"..(GnomTEC_Badge_Flags[realm][player].NA or player).."|r")
		else
			GNOMTEC_BADGE_FRAME_NA:SetText("|cff8080ff"..(GnomTEC_Badge_Flags[realm][player].NA or player).."|r")
		end
		GNOMTEC_BADGE_FRAME_NT:SetText(GnomTEC_Badge_Flags[realm][player].NT or "")
		GNOMTEC_BADGE_FRAME_GUILD:SetText(GnomTEC_Badge_Flags[realm][player].Guild or "")
		GNOMTEC_BADGE_FRAME_ENGINEDATA:SetText(GnomTEC_Badge_Flags[realm][player].EngineData or "")

		local fr, fc, msp
		
		if type(GnomTEC_Badge_Flags[realm][player].FR) == "number" then
			fr = str_fr[GnomTEC_Badge_Flags[realm][player].FR]
		elseif type(GnomTEC_Badge_Flags[realm][player].FR) == "string" then
			fr = GnomTEC_Badge_Flags[realm][player].FR
		end
		if type(GnomTEC_Badge_Flags[realm][player].FC) == "number" then
			fc = str_fc[GnomTEC_Badge_Flags[realm][player].FC]
		elseif type(GnomTEC_Badge_Flags[realm][player].FC) == "string" then
			fc = GnomTEC_Badge_Flags[realm][player].FC
		end
		if GnomTEC_Badge_Flags[realm][player].FlagMSP == nil then
			msp = "<kein Rollenspielflag vorhanden>"
		elseif GnomTEC_Badge_Flags[realm][player].FlagMSP then
			msp= ""
		else
			msp= "<RSP>"		
		end
			
		if fr and fc then
			GNOMTEC_BADGE_FRAME_FR_FC:SetText("<"..fr.."><"..fc..">"..msp)
		elseif fr then
			GNOMTEC_BADGE_FRAME_FR_FC:SetText("<"..fr..">"..msp)
		elseif fc then
			GNOMTEC_BADGE_FRAME_FR_FC:SetText("<"..fc..">"..msp)
		else
			GNOMTEC_BADGE_FRAME_FR_FC:SetText(msp)
		end
		if (displayedPlayerNote) then
			GNOMTEC_BADGE_FRAME_SCROLL_DE:SetText(GnomTEC_Badge_Flags[realm][player].NOTE or "")
		else
			GNOMTEC_BADGE_FRAME_SCROLL_DE:SetText(GnomTEC_Badge_Flags[realm][player].DE or "")
		end
	else
		GNOMTEC_BADGE_FRAME_NA:SetText("|cff4040ff"..player.."|r")
		GNOMTEC_BADGE_FRAME_NT:SetText("")
		GNOMTEC_BADGE_FRAME_GUILD:SetText("")
		GNOMTEC_BADGE_FRAME_ENGINEDATA:SetText("")
		GNOMTEC_BADGE_FRAME_FR_FC:SetText("<kein Rollenspielflag vorhanden>")
		GNOMTEC_BADGE_FRAME_SCROLL_DE:SetText("")
	end
	GNOMTEC_BADGE_FRAME_SCROLL:UpdateScrollChildRect()
	GNOMTEC_BADGE_FRAME_SCROLL_SLIDER:SetMinMaxValues(0, GNOMTEC_BADGE_FRAME_SCROLL:GetVerticalScrollRange())
	GNOMTEC_BADGE_FRAME_SCROLL_SLIDER:SetValue(GNOMTEC_BADGE_FRAME_SCROLL:GetVerticalScroll()) 

end

function GnomTEC_Badge:UpdatePlayerList()
	local key,value,id,count
	local results = {}	
	local filter = string.lower(GNOMTEC_BADGE_PLAYERLIST_FILTER:GetText());
	

	count = 0;
	for key,value in pairs(GnomTEC_Badge_Flags[GetRealmName()]) do
	 	if (filter == "") or (string.match(string.lower(key),filter) ~= nil) or (string.match(string.lower(value.NA or ""),filter) ~= nil ) then
			count = count + 1;
			results[count] = key;
		end
	end
	
	table.sort(results)

	GNOMTEC_BADGE_PLAYERLIST_LIST:SetFading(false);
	GNOMTEC_BADGE_PLAYERLIST_LIST:EnableMouse(true);
	GNOMTEC_BADGE_PLAYERLIST_LIST:SetHyperlinksEnabled(true) 
	GNOMTEC_BADGE_PLAYERLIST_LIST:SetScript("OnHyperlinkClick", function(self, linkData, link, button) GNOMTEC_BADGE_FRAME_PLAYERMODEL:ClearModel();GnomTEC_Badge:DisplayBadge(GetRealmName(), select(2,strsplit(":", linkData))) end)
	GNOMTEC_BADGE_PLAYERLIST_LIST:Clear();		
	if (count == 0) then
		count = 1;
		GNOMTEC_BADGE_PLAYERLIST_LIST:SetMaxLines(count);
		GNOMTEC_BADGE_PLAYERLIST_LIST:AddMessage("<Keine Eintrag>");
	else
		GNOMTEC_BADGE_PLAYERLIST_LIST:SetMaxLines(count);
		for id,value in ipairs(results) do
			local f = GnomTEC_Badge_Flags[GetRealmName()][value].FRIEND or 0;
			if (f < 0) then
				GNOMTEC_BADGE_PLAYERLIST_LIST:AddMessage("|cffff0000|Hplayer:"..value.."|h"..(GnomTEC_Badge_Flags[GetRealmName()][value].NA or value).."|h|r")
			elseif (f > 0) then
				GNOMTEC_BADGE_PLAYERLIST_LIST:AddMessage("|cff00ff00|Hplayer:"..value.."|h"..(GnomTEC_Badge_Flags[GetRealmName()][value].NA or value).."|h|r")
			else
				GNOMTEC_BADGE_PLAYERLIST_LIST:AddMessage("|cff8080ff|Hplayer:"..value.."|h"..(GnomTEC_Badge_Flags[GetRealmName()][value].NA or value).."|h|r")
			end
		end
	end
	GNOMTEC_BADGE_PLAYERLIST_LIST_SLIDER:SetMinMaxValues(0,count);
	GNOMTEC_BADGE_PLAYERLIST_LIST_SLIDER:SetValue(count);
	GNOMTEC_BADGE_PLAYERLIST_LIST:ScrollToBottom();

end

function GnomTEC_Badge:DisplayNote(display)
	local realm = displayedPlayerRealm;
	local player = displayedPlayerName;

	if (GnomTEC_Badge_Flags[realm][player]) then
		displayedPlayerNote = display
		GnomTEC_Badge:DisplayBadge(realm, player)
	end
end

function GnomTEC_Badge:UpdateNote()
	local realm = displayedPlayerRealm;
	local player = displayedPlayerName;

	if (GnomTEC_Badge_Flags[realm][player]) then
		if (displayedPlayerNote) then
			GnomTEC_Badge_Flags[realm][player].NOTE = emptynil(GNOMTEC_BADGE_FRAME_SCROLL_DE:GetText() or "")
		end
	end
end

function GnomTEC_Badge:FriendFriend()
	local realm = displayedPlayerRealm;
	local player = displayedPlayerName;

	if (GnomTEC_Badge_Flags[realm][player]) then
		GnomTEC_Badge_Flags[realm][player].FRIEND = 255;
			
		if GNOMTEC_BADGE_PLAYERLIST_LIST:IsVisible() then
			GnomTEC_Badge:UpdatePlayerList()
		end
		GnomTEC_Badge:DisplayBadge(realm, player)
	end
end

function GnomTEC_Badge:FriendEnemy()
	local realm = displayedPlayerRealm;
	local player = displayedPlayerName;

	if (GnomTEC_Badge_Flags[realm][player]) then
		GnomTEC_Badge_Flags[realm][player].FRIEND = -255;
			
		if GNOMTEC_BADGE_PLAYERLIST_LIST:IsVisible() then
			GnomTEC_Badge:UpdatePlayerList()
		end
		GnomTEC_Badge:DisplayBadge(realm, player)
	end
end

function GnomTEC_Badge:FriendNeutral()
	local realm = displayedPlayerRealm;
	local player = displayedPlayerName;

	if (GnomTEC_Badge_Flags[realm][player]) then
		GnomTEC_Badge_Flags[realm][player].FRIEND = 0;
			
		if GNOMTEC_BADGE_PLAYERLIST_LIST:IsVisible() then
			GnomTEC_Badge:UpdatePlayerList()
		end
		GnomTEC_Badge:DisplayBadge(realm, player)
	end
end

function GnomTEC_Badge:PLAYER_TARGET_CHANGED(eventName)
    -- process the event
	if (not playerisInCombat) then
	    local player, realm = UnitName("target")
		realm = realm or GetRealmName()

		if UnitIsPlayer("target") and player and realm then
			GnomTEC_Badge:DisplayBadge(realm, player)
			GNOMTEC_BADGE_FRAME:Show();
			GNOMTEC_BADGE_FRAME_PLAYERMODEL:SetUnit("target")
			GNOMTEC_BADGE_FRAME_PLAYERMODEL:SetCamera(0)
		else
			if GnomTEC_Badge_Options["AutoHide"] and (not GNOMTEC_BADGE_PLAYERLIST:IsVisible()) then
				GNOMTEC_BADGE_FRAME:Hide();
			end	
		end
	end
end
    
function GnomTEC_Badge:CURSOR_UPDATE(eventName)
    -- process the event
	if (GnomTEC_Badge_Options["MouseOver"] and (not (GnomTEC_Badge_Options["LockOnTarget"] and UnitExists("target")))) and GnomTEC_Badge_Options["AutoHide"]  and (not GNOMTEC_BADGE_PLAYERLIST:IsVisible()) then
		GNOMTEC_BADGE_FRAME:Hide();
	end	
end
    
function GnomTEC_Badge:UPDATE_MOUSEOVER_UNIT(eventName)
	if (not playerisInCombat) then
	    -- process the event
   		local player, realm = UnitName("mouseover")
	    realm = realm or GetRealmName()

		if UnitIsPlayer("mouseover") and player and realm then
			if not GnomTEC_Badge_Flags[realm] then GnomTEC_Badge_Flags[realm] = {} end
			if not GnomTEC_Badge_Flags[realm][player] then GnomTEC_Badge_Flags[realm][player] = {} end
			GnomTEC_Badge_Flags[realm][player].Guild = emptynil(GetGuildInfo("mouseover"))	
			GnomTEC_Badge_Flags[realm][player].EngineData = "Stufe "..UnitLevel("mouseover").." "..UnitRace("mouseover").." "..UnitClass("mouseover")		

	    	if not UnitIsUnit("mouseover", "player") then
				msp:Request( table.concat( { UnitName("mouseover") }, "-" ), { "TT", "DE" } )
			end
			if (GnomTEC_Badge_Options["MouseOver"] and (not (GnomTEC_Badge_Options["LockOnTarget"] and UnitExists("target")))) then
				GnomTEC_Badge:DisplayBadge(realm, player)
				GNOMTEC_BADGE_FRAME:Show();
				GNOMTEC_BADGE_FRAME_PLAYERMODEL:SetUnit("mouseover")
				GNOMTEC_BADGE_FRAME_PLAYERMODEL:SetCamera(0)
			end
		end
	end
end

function GnomTEC_Badge:CHAT_MSG_CHANNEL(eventName, message, sender, language, channelString, target, flags, worldChannelNumber, channelNumber, channelName)	

	-- process classic flag messages
	if ((not playerisInCombat) and (string.lower(channelName) == "xtensionxtooltip2")) then
		local realm = GetRealmName();
		local player = sender;
		if not GnomTEC_Badge_Flags[realm] then GnomTEC_Badge_Flags[realm] = {} end
		if not GnomTEC_Badge_Flags[realm][player] then GnomTEC_Badge_Flags[realm][player] = {} end
		if not GnomTEC_Badge_Flags[realm][player].AN2 then GnomTEC_Badge_Flags[realm][player].AN2 = player end
					
		if (not GnomTEC_Badge_Flags[realm][player].FlagMSP) then
			GnomTEC_Badge_Flags[realm][player].FlagMSP = false;
			for index,value in ipairs({strsplit("<", message)}) do
				attributeName,attributeValue = strsplit(">", value)
				-- substitute encoded brackets.
				if attributeValue then
					attributeValue = string.gsub(attributeValue, "\\%(", "<");
					attributeValue = string.gsub(attributeValue, "\\%)", ">");
				end
			
				if attributeName == "" then
					-- leeres Element -> ignorieren
				elseif string.sub(attributeName,1,2) == "RP" and string.sub(attributeName,3,3) ~= "T"  then
					local RPStyle = string.sub(attributeName,3,3);
					if RPStyle == "4" then
						GnomTEC_Badge_Flags[realm][player].FR = 4;	
					elseif RPStyle == "3" then
						GnomTEC_Badge_Flags[realm][player].FR = 3;
					elseif RPStyle == "2" then
						GnomTEC_Badge_Flags[realm][player].FR = 2;
					elseif RPStyle == "0" then
						GnomTEC_Badge_Flags[realm][player].FR = nil;
					else
						GnomTEC_Badge_Flags[realm][player].FR = 1;
					end
				elseif (attributeName == "CSTATUS") then
					GnomTEC_Badge_Flags[realm][player].FC = emptynil(attributeValue)
				elseif string.sub(attributeName,1,2) == "CS" then		
					local cStatus = string.sub(attributeName,3,3);
	
					if cStatus == "0" then
						GnomTEC_Badge_Flags[realm][player].FC = nil
					elseif cStatus == "1" then
						GnomTEC_Badge_Flags[realm][player].FC = 1;
					elseif cStatus == "2" then
						GnomTEC_Badge_Flags[realm][player].FC = 2;
					elseif cStatus == "3" then
						GnomTEC_Badge_Flags[realm][player].FC = 3
					elseif cStatus == "4" then
						GnomTEC_Badge_Flags[realm][player].FC = 4 
					else
						GnomTEC_Badge_Flags[realm][player].FC = nil
					end
				elseif (attributeName == "TITEL") then
				GnomTEC_Badge_Flags[realm][player].NT = emptynil(attributeValue)
				elseif (attributeName == "T") then
					GnomTEC_Badge_Flags[realm][player].NT = emptynil(attributeValue)
				elseif (attributeName == "NAME") then
					GnomTEC_Badge_Flags[realm][player].AN3 = emptynil(attributeValue)
					if not GnomTEC_Badge_Flags[realm][player].AN3 then
						GnomTEC_Badge_Flags[realm][player].NA = Player
					else
						GnomTEC_Badge_Flags[realm][player].NA = Player..GnomTEC_Badge_Flags[realm][player].AN3
					end
				elseif (attributeName == "N") then				
					GnomTEC_Badge_Flags[realm][player].AN3 = emptynil(attributeValue)
					if not GnomTEC_Badge_Flags[realm][player].AN3 then
						GnomTEC_Badge_Flags[realm][player].NA = Player
					else
						GnomTEC_Badge_Flags[realm][player].NA = Player..GnomTEC_Badge_Flags[realm][player].AN3
					end
				elseif (attributeName == "AN1") then
					GnomTEC_Badge_Flags[realm][player].AN1 = emptynil(attributeValue)
					if GnomTEC_Badge_Flags[realm][player].AN1 and GnomTEC_Badge_Flags[realm][player].AN2 and GnomTEC_Badge_Flags[realm][player].AN3 then
						GnomTEC_Badge_Flags[realm][player].NA = GnomTEC_Badge_Flags[realm][player].AN1.." "..GnomTEC_Badge_Flags[realm][player].AN2.." "..GnomTEC_Badge_Flags[realm][player].AN3
					elseif GnomTEC_Badge_Flags[realm][player].AN1 and GnomTEC_Badge_Flags[realm][player].AN2 then
						GnomTEC_Badge_Flags[realm][player].NA = GnomTEC_Badge_Flags[realm][player].AN1.." "..GnomTEC_Badge_Flags[realm][player].AN2
					elseif GnomTEC_Badge_Flags[realm][player].AN1 and GnomTEC_Badge_Flags[realm][player].AN3 then
						GnomTEC_Badge_Flags[realm][player].NA = GnomTEC_Badge_Flags[realm][player].AN1.." "..GnomTEC_Badge_Flags[realm][player].AN3
					elseif GnomTEC_Badge_Flags[realm][player].AN2 and GnomTEC_Badge_Flags[realm][player].AN3 then
						GnomTEC_Badge_Flags[realm][player].NA = GnomTEC_Badge_Flags[realm][player].AN2.." "..GnomTEC_Badge_Flags[realm][player].AN3
					elseif GnomTEC_Badge_Flags[realm][player].AN1 then
						GnomTEC_Badge_Flags[realm][player].NA = GnomTEC_Badge_Flags[realm][player].AN1
					elseif GnomTEC_Badge_Flags[realm][player].AN2 then
						GnomTEC_Badge_Flags[realm][player].NA = GnomTEC_Badge_Flags[realm][player].AN2
					elseif GnomTEC_Badge_Flags[realm][player].AN3 then
						GnomTEC_Badge_Flags[realm][player].NA = GnomTEC_Badge_Flags[realm][player].AN3
					else
						GnomTEC_Badge_Flags[realm][player].NA = nil
					end
				elseif (attributeName == "AN2") then
					GnomTEC_Badge_Flags[realm][player].AN2 = emptynil(attributeValue)
					if GnomTEC_Badge_Flags[realm][player].AN1 and GnomTEC_Badge_Flags[realm][player].AN2 and GnomTEC_Badge_Flags[realm][player].AN3 then
						GnomTEC_Badge_Flags[realm][player].NA = GnomTEC_Badge_Flags[realm][player].AN1.." "..GnomTEC_Badge_Flags[realm][player].AN2.." "..GnomTEC_Badge_Flags[realm][player].AN3
					elseif GnomTEC_Badge_Flags[realm][player].AN1 and GnomTEC_Badge_Flags[realm][player].AN2 then
						GnomTEC_Badge_Flags[realm][player].NA = GnomTEC_Badge_Flags[realm][player].AN1.." "..GnomTEC_Badge_Flags[realm][player].AN2
					elseif GnomTEC_Badge_Flags[realm][player].AN1 and GnomTEC_Badge_Flags[realm][player].AN3 then
						GnomTEC_Badge_Flags[realm][player].NA = GnomTEC_Badge_Flags[realm][player].AN1.." "..GnomTEC_Badge_Flags[realm][player].AN3
					elseif GnomTEC_Badge_Flags[realm][player].AN2 and GnomTEC_Badge_Flags[realm][player].AN3 then
						GnomTEC_Badge_Flags[realm][player].NA = GnomTEC_Badge_Flags[realm][player].AN2.." "..GnomTEC_Badge_Flags[realm][player].AN3
					elseif GnomTEC_Badge_Flags[realm][player].AN1 then
						GnomTEC_Badge_Flags[realm][player].NA = GnomTEC_Badge_Flags[realm][player].AN1
					elseif GnomTEC_Badge_Flags[realm][player].AN2 then
						GnomTEC_Badge_Flags[realm][player].NA = GnomTEC_Badge_Flags[realm][player].AN2
					elseif GnomTEC_Badge_Flags[realm][player].AN3 then
						GnomTEC_Badge_Flags[realm][player].NA = GnomTEC_Badge_Flags[realm][player].AN3
					else
						GnomTEC_Badge_Flags[realm][player].NA = nil
					end
				elseif (attributeName == "AN3") then
					GnomTEC_Badge_Flags[realm][player].AN3 = emptynil(attributeValue)
					if GnomTEC_Badge_Flags[realm][player].AN1 and GnomTEC_Badge_Flags[realm][player].AN2 and GnomTEC_Badge_Flags[realm][player].AN3 then
						GnomTEC_Badge_Flags[realm][player].NA = GnomTEC_Badge_Flags[realm][player].AN1.." "..GnomTEC_Badge_Flags[realm][player].AN2.." "..GnomTEC_Badge_Flags[realm][player].AN3
					elseif GnomTEC_Badge_Flags[realm][player].AN1 and GnomTEC_Badge_Flags[realm][player].AN2 then
						GnomTEC_Badge_Flags[realm][player].NA = GnomTEC_Badge_Flags[realm][player].AN1.." "..GnomTEC_Badge_Flags[realm][player].AN2
					elseif GnomTEC_Badge_Flags[realm][player].AN1 and GnomTEC_Badge_Flags[realm][player].AN3 then
						GnomTEC_Badge_Flags[realm][player].NA = GnomTEC_Badge_Flags[realm][player].AN1.." "..GnomTEC_Badge_Flags[realm][player].AN3
					elseif GnomTEC_Badge_Flags[realm][player].AN2 and GnomTEC_Badge_Flags[realm][player].AN3 then
						GnomTEC_Badge_Flags[realm][player].NA = GnomTEC_Badge_Flags[realm][player].AN2.." "..GnomTEC_Badge_Flags[realm][player].AN3
					elseif GnomTEC_Badge_Flags[realm][player].AN1 then
						GnomTEC_Badge_Flags[realm][player].NA = GnomTEC_Badge_Flags[realm][player].AN1
					elseif GnomTEC_Badge_Flags[realm][player].AN2 then
						GnomTEC_Badge_Flags[realm][player].NA = GnomTEC_Badge_Flags[realm][player].AN2
					elseif GnomTEC_Badge_Flags[realm][player].AN3 then
						GnomTEC_Badge_Flags[realm][player].NA = GnomTEC_Badge_Flags[realm][player].AN3
					else
						GnomTEC_Badge_Flags[realm][player].NA = nil
					end
				elseif (attributeName == "DREV") then
					-- we ignore revisions because we are only listening
				elseif (attributeName == "DV") then
					-- we ignore revisions because we are only listening
				elseif (attributeName == "DPULL") then
					-- we ignore description requests because we are only listening
				elseif (attributeName == "DP") then
					-- we ignore description requests because we are only listening
				elseif (attributeName == "DVER") then
					-- we ignore version requests because we are only listening
				elseif (attributeName == "V") then
					-- we ignore version requests because we are only listening
				elseif (string.sub(attributeName,1,1) == "D") or (string.sub(attributeName,1,1) == "P") then
				
					if not GnomTEC_Badge_Flags[realm][player].FlagRSPDesc then GnomTEC_Badge_Flags[realm][player].FlagRSPDesc = {} end
					GnomTEC_Badge_Flags[realm][player].FlagRSPDesc[tonumber(string.sub(attributeName,2,3))] = attributeValue
					
					local i = 1;
					local lastPart;
					GnomTEC_Badge_Flags[realm][player].DE = ""
					while GnomTEC_Badge_Flags[realm][player].FlagRSPDesc[i] ~= nil do
						lastPart = string.sub(GnomTEC_Badge_Flags[realm][player].FlagRSPDesc[i], string.len(GnomTEC_Badge_Flags[realm][player].FlagRSPDesc[i])-3);
						if lastPart ~= "\\eod" then
							GnomTEC_Badge_Flags[realm][player].DE = GnomTEC_Badge_Flags[realm][player].DE..string.sub(GnomTEC_Badge_Flags[realm][player].FlagRSPDesc[i], 1, string.len(GnomTEC_Badge_Flags[realm][player].FlagRSPDesc[i])-4)
							i = -2;
						else
							GnomTEC_Badge_Flags[realm][player].DE = GnomTEC_Badge_Flags[realm][player].DE..GnomTEC_Badge_Flags[realm][player].FlagRSPDesc[i]   
						end
						i = i + 1;
					end
					GnomTEC_Badge_Flags[realm][player].DE = string.gsub(GnomTEC_Badge_Flags[realm][player].DE, "\\l", "\n");
				else
					-- GnomTEC_Badge:Print(sender.." <"..(attributeName or "")..">"..(attributeValue or ""))
				end
			end
								
			-- Refresh Badge if it shows player data
			if ((player == displayedPlayerName) and (realm == displayedPlayerRealm)) then
				GnomTEC_Badge:DisplayBadge(realm, player)
			end
		end
	end
end

function GnomTEC_Badge_MSPcallback(char)
	-- process new flag from char 
	local player, realm = strsplit( "-", char, 2 )
	realm = realm or GetRealmName()
	GnomTEC_Badge:SaveFlag(realm, player)
	GnomTEC_Badge:UpdatePlayerList()
	
	if ((player == displayedPlayerName) and (realm == displayedPlayerRealm)) then
		GnomTEC_Badge:DisplayBadge(realm, player)
	end
	
end