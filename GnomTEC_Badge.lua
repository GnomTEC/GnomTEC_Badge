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

local optionsMain = {
	name = "GnomTEC Badge",
	type = "group",
	args = {
		descriptionTitle = {
			order = 1,
			type = "description",
			name = "Addon zur Anzeige und Verwaltung von Rollenspiel-Charakterbeschreibungen mit Support von Channel- und 'Marry Sue Protocol'-basierten Flagprotokollen.\n\n",
		},
		descriptionAbout = {
			name = "About",
			type = "group",
			guiInline = true,
			order = 2,
			args = {
				descriptionVersion = {
				order = 1,
				type = "description",			
				name = "|cffffd700".."Version"..": ".._G["GREEN_FONT_COLOR_CODE"]..GetAddOnMetadata("GnomTEC_Badge", "Version"),
				},
				descriptionAuthor = {
					order = 2,
					type = "description",
					name = "|cffffd700".."Autor"..": ".."|cffff8c00".."Lugus Sprengfix",
				},
				descriptionEmail = {
					order = 3,
					type = "description",
					name = "|cffffd700".."Email"..": ".._G["HIGHLIGHT_FONT_COLOR_CODE"].."info@gnomtec.de",
				},
				descriptionWebsite = {
					order = 4,
					type = "description",
					name = "|cffffd700".."Website"..": ".._G["HIGHLIGHT_FONT_COLOR_CODE"].."http://www.gnomtec.de/",
				},
				descriptionLicense = {
					order = 5,
					type = "description",
					name = "|cffffd700".."Copyright"..": ".._G["HIGHLIGHT_FONT_COLOR_CODE"].."(c)2011 by GnomTEC",
				},
			}
		},
		descriptionLogo = {
			order = 3,
			type = "description",
			name = "",
			image = "Interface\\AddOns\\GnomTEC_Badge\\Textures\\GnomTEC-Logo",
			imageCoords = {0.0,1.0,0.0,1.0},
			imageWidth = 512,
			imageHeight = 128,
		},
	}
}
			
local optionsProfile = {
	name = "Charakterbeschreibung",
	type = 'group',
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
}

local optionsView = {
	name = "Anzeigeoptionen",
	type = 'group',
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
}

local displayedPlayerName = ""
local displayedPlayerRealm = ""
local displayedPlayerNote = false;


GnomTEC_Badge = LibStub("AceAddon-3.0"):NewAddon("GnomTEC_Badge", "AceConsole-3.0", "AceEvent-3.0")
LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC Badge Main", optionsMain)
LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC Badge Profile", optionsProfile)
LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC Badge View", optionsView)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC Badge Main", "GnomTEC Badge");
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC Badge Profile", "Charakterbeschreibung", "GnomTEC Badge");
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC Badge View", "Anzeigeoptionen", "GnomTEC Badge");

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
		local f = GnomTEC_Badge_Flags[realm][player].FRIEND;
		if (f == nil) then
			GNOMTEC_BADGE_FRAME_NA:SetText("|cffC0C0C0"..(GnomTEC_Badge_Flags[realm][player].NA or player).."|r")		
		elseif (f < 0) then
			GNOMTEC_BADGE_FRAME_NA:SetText("|cffff0000"..(GnomTEC_Badge_Flags[realm][player].NA or player).."|r")
		elseif (f > 0) then
			GNOMTEC_BADGE_FRAME_NA:SetText("|cff00ff00"..(GnomTEC_Badge_Flags[realm][player].NA or player).."|r")
		else
			GNOMTEC_BADGE_FRAME_NA:SetText("|cff8080ff"..(GnomTEC_Badge_Flags[realm][player].NA or player).."|r")
		end
		GNOMTEC_BADGE_FRAME_NT:SetText(GnomTEC_Badge_Flags[realm][player].NT or "")
		GNOMTEC_BADGE_FRAME_GUILD:SetText(GnomTEC_Badge_Flags[realm][player].Guild or "")
		GNOMTEC_BADGE_FRAME_ENGINEDATA:SetText((GnomTEC_Badge_Flags[realm][player].EngineData or "").." ("..player..")")

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
		GNOMTEC_BADGE_FRAME_NA:SetText("|cffC0C0C0"..player.."|r")
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

local playerList = {}
local playerListPosition = 0

function GnomTEC_Badge:ClickedPlayerList(id)
	if (playerListPosition + id <= #playerList) then
		GNOMTEC_BADGE_FRAME_PLAYERMODEL:ClearModel();
		GnomTEC_Badge:DisplayBadge(GetRealmName(),playerList[playerListPosition+id]);
	end
end

function GnomTEC_Badge:RedrawPlayerList()
	local i

	playerListPosition = floor(GNOMTEC_BADGE_PLAYERLIST_LIST_SLIDER:GetValue())


	for i=1, 8, 1 do
		local button = getglobal("GNOMTEC_BADGE_PLAYERLIST_LIST_PLAYER"..i);
		local textNA = getglobal("GNOMTEC_BADGE_PLAYERLIST_LIST_PLAYER"..i.."_TEXT_NA");
		local textNT = getglobal("GNOMTEC_BADGE_PLAYERLIST_LIST_PLAYER"..i.."_TEXT_NT");
		local textENGINEDATA = getglobal("GNOMTEC_BADGE_PLAYERLIST_LIST_PLAYER"..i.."_TEXT_ENGINEDATA");
		if (playerListPosition + i > #playerList) then
			button:Hide();
		else
			local player = GnomTEC_Badge_Flags[GetRealmName()][playerList[playerListPosition+i]];
			if (player.FRIEND == nil) then
				textNA:SetText("|cffC0C0C0"..(player.NA or playerList[playerListPosition+i]).."|r")		
			elseif (player.FRIEND < 0) then
				textNA:SetText("|cffff0000"..(player.NA or playerList[playerListPosition+i]).."|r")
			elseif (player.FRIEND > 0) then
				textNA:SetText("|cff00ff00"..(player.NA or playerList[playerListPosition+i]).."|r")
			else
				textNA:SetText("|cff8080ff"..(player.NA or playerList[playerListPosition+i]).."|r")
			end	
			textNT:SetText(player.NT or "")
			textENGINEDATA:SetText((player.EngineData or "Stufe -- Unbekannt Unbekannt").." ("..playerList[playerListPosition+i]..")")
			button:Show();
		end
	end
end

function GnomTEC_Badge:UpdatePlayerList()

	local key,value,rkey,rvalue,id,count,rcount, acount
	local filter = string.lower(GNOMTEC_BADGE_PLAYERLIST_FILTER:GetText());
	local showFriend = GNOMTEC_BADGE_PLAYERLIST_SHOWFRIEND:GetChecked();
	local showNeutral = GNOMTEC_BADGE_PLAYERLIST_SHOWNEUTRAL:GetChecked();
	local showEnemy = GNOMTEC_BADGE_PLAYERLIST_SHOWENEMY:GetChecked();
	local showUnknown = GNOMTEC_BADGE_PLAYERLIST_SHOWUNKNOWN:GetChecked();
	
	acount = 0;
	for rkey,rvalue in pairs(GnomTEC_Badge_Flags) do
		for key,value in pairs(rvalue) do	
			acount = acount+1;
		end
	end

	rcount = 0;
	for rkey,rvalue in pairs(GnomTEC_Badge_Flags[GetRealmName()]) do
		rcount = rcount+1;
	end

	count = 0;
	playerList = {}
	for key,value in pairs(GnomTEC_Badge_Flags[GetRealmName()]) do
	 	if (filter == "") or (string.match(string.lower(key),filter) ~= nil) or (string.match(string.lower(value.NA or ""),filter) ~= nil ) then
			if (value.FRIEND == nil) then
				if showUnknown then
					count = count + 1;
					playerList[count] = key;				
				end
			elseif ((value.FRIEND < 0) and showEnemy) or ((value.FRIEND > 0) and showFriend) or ((value.FRIEND == 0) and showNeutral) then
				count = count + 1;
				playerList[count] = key;
			end
		end
	end
	
	table.sort(playerList)
	
	if (count > 8) then
		GNOMTEC_BADGE_PLAYERLIST_LIST_SLIDER:SetMinMaxValues(0,count-8);
	else
		GNOMTEC_BADGE_PLAYERLIST_LIST_SLIDER:SetMinMaxValues(0,0);		
	end
	playerListPosition = 0;
	GNOMTEC_BADGE_PLAYERLIST_LIST_SLIDER:SetValue(playerListPosition);
	GnomTEC_Badge:RedrawPlayerList();
	GNOMTEC_BADGE_PLAYERLIST_FOOTER_TEXT:SetText("Filter: "..count.." / "..GetRealmName()..": "..rcount.." / Gesamt: "..acount);
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

function GnomTEC_Badge:FriendUnknown()
	local realm = displayedPlayerRealm;
	local player = displayedPlayerName;

	if (GnomTEC_Badge_Flags[realm][player]) then
		GnomTEC_Badge_Flags[realm][player].FRIEND = nil;
			
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
						if lastPart == "\\eod" then
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