﻿-- **********************************************************************
-- GnomTEC Badge
-- Version: 5.3.0.15
-- Author: GnomTEC
-- Copyright 2011-2013 by GnomTEC
-- http://www.gnomtec.de/
-- **********************************************************************
-- load localization first.
local L = LibStub("AceLocale-3.0"):GetLocale("GnomTEC_Badge")

-- ----------------------------------------------------------------------
-- Legacy global variables and constants (will be deleted in future)
-- ----------------------------------------------------------------------

-- Old saved variables
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
	["GnomcorderIntegration"] = false,
	["Tooltip"] = true,	
}

-- ----------------------------------------------------------------------
-- Addon global Constants (local)
-- ----------------------------------------------------------------------

local str_fr = {L["L_STR_FR0"], L["L_STR_FR1"], L["L_STR_FR2"], L["L_STR_FR3"], L["L_STR_FR4"],}
local str_fc = {L["L_STR_FC0"], L["L_STR_FC1"], L["L_STR_FC2"], L["L_STR_FC3"],}

-- ----------------------------------------------------------------------
-- Addon global variables (local)
-- ----------------------------------------------------------------------

local playerisInCombat = false;

-- Main options menue with general addon information
local optionsMain = {
	name = "GnomTEC Badge",
	type = "group",
	args = {
		descriptionTitle = {
			order = 1,
			type = "description",
			name = L["L_OPTIONS_TITLE"],
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
					name = "|cffffd700".."Autor"..": ".."|cffff8c00".."GnomTEC",
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
					name = "|cffffd700".."Copyright"..": ".._G["HIGHLIGHT_FONT_COLOR_CODE"].."(c)2011-2013 by GnomTEC",
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
	name = L["L_OPTIONS_PROFILE"],
	type = 'group',
	args = {
		badgePlayerNA = {
			type = "input",
			name = L["L_OPTIONS_PROFILE_NA"],
			desc = "",
			set = function(info,val) GnomTEC_Badge_Player["Fields"]["NA"] = val; GnomTEC_Badge:SetMSP() end,
	   	get = function(info) return GnomTEC_Badge_Player["Fields"]["NA"] end,
			multiline = false,
			width = 'full',
			order = 1
		},
		badgePlayerNT = {
			type = "input",
			name = L["L_OPTIONS_PROFILE_NT"],
			desc = "",
			set = function(info,val) GnomTEC_Badge_Player["Fields"]["NT"] = val; GnomTEC_Badge:SetMSP() end,
    		get = function(info) return GnomTEC_Badge_Player["Fields"]["NT"] end,
			multiline = false,
			width = 'full',
			order = 2
		},
		badgePlayerFR = {
			type = "select",
			name = L["L_OPTIONS_PROFILE_FR"],
			desc = "",
			set = function(info,val) GnomTEC_Badge_Player["Fields"]["FR"] = val; GnomTEC_Badge:SetMSP() end,
			get = function(info) return GnomTEC_Badge_Player["Fields"]["FR"] end,
			values = str_fr,
			order = 3
		},
		badgePlayerFC = {
			type = "select",
			name = L["L_OPTIONS_PROFILE_FC"],
			desc = "",
			set = function(info,val) GnomTEC_Badge_Player["Fields"]["FC"] = val; GnomTEC_Badge:SetMSP() end,
			get = function(info) return GnomTEC_Badge_Player["Fields"]["FC"] end,
			values = str_fc,
			order = 3
		},
		badgePlayerCU = {
			type = "input",
			name = L["L_OPTIONS_PROFILE_CU"],
			desc = "",
			set = function(info,val) GnomTEC_Badge_Player["Fields"]["CU"] = val; GnomTEC_Badge:SetMSP() end,
    		get = function(info) return GnomTEC_Badge_Player["Fields"]["CU"] end,
			multiline = 2,
			width = 'full',
			order = 4
		},
		badgePlayerAG = {
			type = "input",
			name = L["L_OPTIONS_PROFILE_AG"],
			desc = "",
			set = function(info,val) GnomTEC_Badge_Player["Fields"]["AG"] = val; GnomTEC_Badge:SetMSP() end,
    		get = function(info) return GnomTEC_Badge_Player["Fields"]["AG"] end,
			multiline = false,
			width = 'half',
			order = 5
		},
		badgePlayerAE = {
			type = "input",
			name = L["L_OPTIONS_PROFILE_AE"],
			desc = "",
			set = function(info,val) GnomTEC_Badge_Player["Fields"]["AE"] = val; GnomTEC_Badge:SetMSP() end,
    		get = function(info) return GnomTEC_Badge_Player["Fields"]["AE"] end,
			multiline = false,
			width = 'half',
			order = 5
		},
		badgePlayerAH = {
			type = "input",
			name = L["L_OPTIONS_PROFILE_AH"],
			desc = "",
			set = function(info,val) GnomTEC_Badge_Player["Fields"]["AH"] = val; GnomTEC_Badge:SetMSP() end,
    		get = function(info) return GnomTEC_Badge_Player["Fields"]["AH"] end,
			multiline = false,
			width = 'half',
			order = 5
		},
		badgePlayerAW = {
			type = "input",
			name = L["L_OPTIONS_PROFILE_AW"],
			desc = "",
			set = function(info,val) GnomTEC_Badge_Player["Fields"]["AW"] = val; GnomTEC_Badge:SetMSP() end,
    		get = function(info) return GnomTEC_Badge_Player["Fields"]["AW"] end,
			multiline = false,
			width = 'half',
			order = 5
		},
		badgePlayerDE = {
			type = "input",
			name = L["L_OPTIONS_PROFILE_DE"],
			desc = "",
			set = function(info,val) GnomTEC_Badge_Player["Fields"]["DE"] = val; GnomTEC_Badge:SetMSP() end,
    		get = function(info) return GnomTEC_Badge_Player["Fields"]["DE"] end,
			multiline = 10,
			width = 'full',
			order = 6
		},
	},
}

local optionsMeta = {
	name = L["L_OPTIONS_META"],
	type = 'group',
	args = {
		badgePlayerNH = {
			type = "input",
			name = L["L_OPTIONS_META_NH"],
			desc = "",
			set = function(info,val) GnomTEC_Badge_Player["Fields"]["NH"] = val; GnomTEC_Badge:SetMSP() end,
	   	get = function(info) return GnomTEC_Badge_Player["Fields"]["NH"] end,
			multiline = false,
			width = 'full',
			order = 1
		},
		badgePlayerMO = {
			type = "input",
			name = L["L_OPTIONS_META_MO"],
			desc = "",
			set = function(info,val) GnomTEC_Badge_Player["Fields"]["MO"] = val; GnomTEC_Badge:SetMSP() end,
    		get = function(info) return GnomTEC_Badge_Player["Fields"]["MO"] end,
			multiline = 2,
			width = 'full',
			order = 4
		},
		badgePlayerHH = {
			type = "input",
			name = L["L_OPTIONS_META_HH"],
			desc = "",
			set = function(info,val) GnomTEC_Badge_Player["Fields"]["HH"] = val; GnomTEC_Badge:SetMSP() end,
    		get = function(info) return GnomTEC_Badge_Player["Fields"]["HH"] end,
			multiline = false,
			width = 'full',
			order = 2
		},
		badgePlayerHB = {
			type = "input",
			name = L["L_OPTIONS_META_HB"],
			desc = "",
			set = function(info,val) GnomTEC_Badge_Player["Fields"]["HB"] = val; GnomTEC_Badge:SetMSP() end,
    		get = function(info) return GnomTEC_Badge_Player["Fields"]["HB"] end,
			multiline = false,
			width = 'full',
			order = 2
		},
		badgePlayerHI = {
			type = "input",
			name = L["L_OPTIONS_META_HI"],
			desc = "",
			set = function(info,val) GnomTEC_Badge_Player["Fields"]["HI"] = val; GnomTEC_Badge:SetMSP() end,
    		get = function(info) return GnomTEC_Badge_Player["Fields"]["HI"] end,
			multiline = 10,
			width = 'full',
			order = 6
		},
	},
}
local optionsView = {
	name = L["L_OPTIONS_VIEW"],
	type = 'group',
	args = {
		badgeOptionMouseOver = {
			type = "toggle",
			name = L["L_OPTIONS_VIEW_MOUSEOVER"],
			desc = "",
			set = function(info,val) GnomTEC_Badge_Options["MouseOver"] = val end,
			get = function(info) return GnomTEC_Badge_Options["MouseOver"] end,
			width = 'full',
			order = 1
		},
		badgeOptionLockOnTarget = {
			type = "toggle",
			name = L["L_OPTIONS_VIEW_LOCKONTARGET"],
			desc = "",
			set = function(info,val) GnomTEC_Badge_Options["LockOnTarget"] = val end,
	   		get = function(info) return GnomTEC_Badge_Options["LockOnTarget"] end,
			width = 'full',
			order = 2
		},
		badgeOptionAutoHide = {
			type = "toggle",
			name = L["L_OPTIONS_VIEW_AUTOHIDE"],
			desc = "",
			set = function(info,val) GnomTEC_Badge_Options["AutoHide"] = val end,
	   		get = function(info) return GnomTEC_Badge_Options["AutoHide"] end,
			width = 'full',
			order = 3
		},
		badgeOptionDisableInCombat = {
			type = "toggle",
			name = L["L_OPTIONS_VIEW_DISABLEINCOMBAT"],
			desc = "",
			set = function(info,val) GnomTEC_Badge_Options["DisableInCombat"] = val end,
	   		get = function(info) return GnomTEC_Badge_Options["DisableInCombat"] end,
			width = 'full',
			order = 4
		},
		badgeOptionGnomcorderIntegration = {
			type = "toggle",
			name = L["L_OPTIONS_VIEW_GNOMCORDERINTEGRATION"],
			desc = "",
			disabled = function(info) return not GnomTEC_Gnomcorder end,
			set = function(info,val) GnomTEC_Badge_Options["GnomcorderIntegration"] = val end,
	   		get = function(info) return GnomTEC_Badge_Options["GnomcorderIntegration"] end,
			width = 'full',
			order = 5
		},
		badgeOptionTooltip = {
			type = "toggle",
			name = L["L_OPTIONS_VIEW_TOOLTIP"],
			desc = "",
			set = function(info,val) GnomTEC_Badge_Options["Tooltip"] = val end,
	   		get = function(info) return GnomTEC_Badge_Options["Tooltip"] end,
			width = 'full',
			order = 6
		},
	},
}

local displayedPlayerName = ""
local displayedPlayerRealm = ""
local displayedTAB = 1

local playerList = {}
local playerListPosition = 0

-- ----------------------------------------------------------------------
-- Startup initialization
-- ----------------------------------------------------------------------

GnomTEC_Badge = LibStub("AceAddon-3.0"):NewAddon("GnomTEC_Badge", "AceConsole-3.0", "AceEvent-3.0")
LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC Badge Main", optionsMain)
LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC Badge Profile", optionsProfile)
LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC Badge Meta", optionsMeta)
LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC Badge View", optionsView)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC Badge Main", "GnomTEC Badge");
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC Badge Profile", L["L_OPTIONS_PROFILE"], "GnomTEC Badge");
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC Badge Meta", L["L_OPTIONS_META"], "GnomTEC Badge");
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC Badge View", L["L_OPTIONS_VIEW"], "GnomTEC Badge");

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


-- ----------------------------------------------------------------------
-- Local functions
-- ----------------------------------------------------------------------

-- function which returns also nil for empty strings
local function emptynil( x ) return x ~= "" and x or nil end

-- function to cleanup control sequences
local function cleanpipe( x )
	x = x or ""
	
	-- Filter coloring
	x = string.gsub( x, "|c%x%x%x%x%x%x%x%x", "" )
	x = string.gsub( x, "|r", "" )
	
	-- Filter links
	x = string.gsub( x, "|H.-|h", "" )
	x = string.gsub( x, "|h", "" )
	
	-- Filter textures
	x = string.gsub( x, "|T.-|t", "" )

	-- Filter battle.net friend's name
	x = string.gsub( x, "|K.-|k", "" )
	x = string.gsub( x, "|k", "" )

	-- Filter newline
	x = string.gsub( x, "|n", "" )
	
	-- at last filter any left escape
	x = string.gsub( x, "|", "/" )	
	
	return strtrim(x)
end

function GnomTEC_Badge:AddToVAString( addon )
	if not select( 4, GetAddOnInfo( addon ) ) then return end
	msp.my['VA'] = strtrim( format( "%s;%s/%s%s", (msp.my['VA'] or ""), addon, 
		( GetAddOnMetadata( addon, "Version" ) or "" ), 
		(	(GetAddOnMetadata( addon, "X-Test" )=="Alpha" and "a") or 
			(GetAddOnMetadata( addon, "X-Test" )=="Beta" and "b") or "" ) ), "; " )
end

function GnomTEC_Badge:DebugPrintFlag(realm, player)
	if not GnomTEC_Badge_Flags[realm] then GnomTEC_Badge_Flags[realm] = {} end
	if not GnomTEC_Badge_Flags[realm][player] then GnomTEC_Badge_Flags[realm][player] = {} end
	local r = GnomTEC_Badge_Flags[realm][player]
	
	 GnomTEC_Badge:Print("============================")
	 GnomTEC_Badge:Print("Player: "..player.."-"..realm)
	 
	 GnomTEC_Badge:Print("VA Addon versions: "..(r.VA or ""))
	 GnomTEC_Badge:Print("NA Name: "..(r.NA or ""))
	 GnomTEC_Badge:Print("NH House Name: "..(r.NH or ""))
	 GnomTEC_Badge:Print("NI Nickname: "..(r.NI or ""))
	 GnomTEC_Badge:Print("NT Title: "..(r.NT or ""))
	 GnomTEC_Badge:Print("RA Race: "..(r.RA or ""))
	 GnomTEC_Badge:Print("FR RP Style: "..(r.FR or ""))
	 GnomTEC_Badge:Print("FC Character Status: "..(r.FC or ""))
	 GnomTEC_Badge:Print("CU Currently: "..(r.CU or ""))
	 GnomTEC_Badge:Print("DE Physical Description: "..(r.DE or ""))
	 GnomTEC_Badge:Print("AG Age: "..(r.AG or ""))
	 GnomTEC_Badge:Print("AE Eye Colour: "..(r.AE or ""))
	 GnomTEC_Badge:Print("AH Height: "..(r.AH or ""))
	 GnomTEC_Badge:Print("AW Weight: "..(r.AW or ""))
	 GnomTEC_Badge:Print("MO Motto: "..(r.MO or ""))
	 GnomTEC_Badge:Print("HI History: "..(r.HI or ""))
	 GnomTEC_Badge:Print("HH Home: "..(r.HH or ""))
	 GnomTEC_Badge:Print("HB Birthplace: "..(r.HB or ""))
	 
end

function GnomTEC_Badge:SaveFlag(realm, player)
	if not GnomTEC_Badge_Flags[realm] then GnomTEC_Badge_Flags[realm] = {} end
	if not GnomTEC_Badge_Flags[realm][player] then GnomTEC_Badge_Flags[realm][player] = {} end
	local r = GnomTEC_Badge_Flags[realm][player]
	
	r.FlagMSP = true
	r.timeStamp = time()
	local p
	if (realm and (realm ~= GetRealmName())) then
		p = msp.char[ player.."-"..realm ]
	else
		p = msp.char[ player ]	
	end

	r.NA = emptynil( cleanpipe( p.field.NA ) )
	if ( tonumber( p.field.FC ) or -1 ) > 0 then
		r.FC = tonumber( p.field.FC )
	elseif p.field.FC == "0" then
		r.FC = nil
	else
		r.FC = emptynil( cleanpipe( p.field.FC ) )
	end
	if ( tonumber( p.field.FR ) or -1 ) > 0 then
		r.FR = tonumber( p.field.FR )
	elseif p.field.FR == "Mature" then
		r.FR = 5
	elseif p.field.FR == "0" then
		r.FR = nil
	else
		r.FR = emptynil( cleanpipe( p.field.FR ) )
	end
	r.NT = emptynil( cleanpipe( p.field.NT ) )
	r.DE = emptynil( cleanpipe( p.field.DE ) )	

	-- newly supported flag parts with v5.3.0.15 which will not displayed yet
	
	-- Additional visible character infos 
	r.CU = emptynil( cleanpipe( p.field.CU ) )
	r.RA = emptynil( cleanpipe( p.field.RA ) )
	r.AG = emptynil( cleanpipe( p.field.AG ) )
	r.AE = emptynil( cleanpipe( p.field.AE ) )
	if ( tonumber( p.field.AH ) or -1 ) > 0 then
		r.AH = tonumber( p.field.AH ).." cm"
	else
		r.AH = emptynil( cleanpipe( p.field.AH ) )
	end
	if ( tonumber( p.field.AW ) or -1 ) > 0 then
		r.AW = tonumber( p.field.AW ).." kg"
	else
		r.AW = emptynil( cleanpipe( p.field.AW ) )
	end
	
	-- Additional meta information
	r.NH = emptynil( cleanpipe( p.field.NH ) )
	r.NI = emptynil( cleanpipe( p.field.NI ) )
	r.MO = emptynil( cleanpipe( p.field.MO ) )
	r.HI = emptynil( cleanpipe( p.field.HI ) )
	r.HH = emptynil( cleanpipe( p.field.HH ) )
	r.HB = emptynil( cleanpipe( p.field.HB ) )

	-- Additional not character relevant informations
	r.VA = emptynil( cleanpipe( p.field.VA ) )
 end

function GnomTEC_Badge:SetMSP(init)
	local playername = UnitName("player")

	wipe( msp.my )
	wipe( msp.char[ playername ].field )

	for field, value in pairs( GnomTEC_Badge_Player.Fields ) do
		msp.my[ field ] = value
	end

	-- Fields not set by the user
	msp.my['VP'] = tostring( msp.protocolversion )
	msp.my['VA'] = ""
	GnomTEC_Badge:AddToVAString( "GnomTEC_Badge" )	

	msp.my['GU'] = UnitGUID("player")
	msp.my['GS'] = tostring( UnitSex("player") )
	msp.my['GC'] = select( 2, UnitClass("player") )
	msp.my['GR'] = select( 2, UnitRace("player") )

	msp:Update()

	for field, ver in pairs( msp.myver ) do
		if (not init) then
			GnomTEC_Badge_Player.Versions[ field ] = ver
		end
		msp.char[ playername ].ver[ field ] = ver
		msp.char[ playername ].field[ field ] = msp.my[ field ]
		msp.char[ playername ].time[ field ] = 999999999
	end

	msp.char[ playername ].supported = true
	
	GnomTEC_Badge:SaveFlag(GetRealmName(), playername)

end


function GnomTEC_Badge:DisplayBadge(realm, player)

	if ((not realm) or (not player)) then 
		return;
	elseif (not GnomTEC_Badge_Flags[realm]) then
		return;
	elseif (not GnomTEC_Badge_Flags[realm][player]) then
		return;
	end
	
	displayedPlayerRealm = realm;
	displayedPlayerName = player;
	
	if (GnomTEC_Badge_Flags[realm][player]) then	
				
		local f = GnomTEC_Badge_Flags[realm][player].FRIEND;
		-- cleanup UI Escape Sequences which ar not yet filtered
		GnomTEC_Badge_Flags[realm][player].NA = emptynil(cleanpipe(GnomTEC_Badge_Flags[realm][player].NA))
		if (f == nil) then
			GNOMTEC_BADGE_FRAME_NA:SetText("|cffC0C0C0"..(GnomTEC_Badge_Flags[realm][player].NA or player).."|r")		
		elseif (f < 0) then
			GNOMTEC_BADGE_FRAME_NA:SetText("|cffff0000"..(GnomTEC_Badge_Flags[realm][player].NA or player).."|r")
		elseif (f > 0) then
			GNOMTEC_BADGE_FRAME_NA:SetText("|cff00ff00"..(GnomTEC_Badge_Flags[realm][player].NA or player).."|r")
		else
			GNOMTEC_BADGE_FRAME_NA:SetText("|cff8080ff"..(GnomTEC_Badge_Flags[realm][player].NA or player).."|r")
		end
		-- cleanup UI Escape Sequences which ar not yet filtered
		GnomTEC_Badge_Flags[realm][player].NT = emptynil(cleanpipe(GnomTEC_Badge_Flags[realm][player].NT))
		GNOMTEC_BADGE_FRAME_NT:SetText(GnomTEC_Badge_Flags[realm][player].NT or "")
		GNOMTEC_BADGE_FRAME_GUILD:SetText(GnomTEC_Badge_Flags[realm][player].Guild or "")
		GNOMTEC_BADGE_FRAME_ENGINEDATA:SetText((GnomTEC_Badge_Flags[realm][player].EngineData or "").." ("..player..")")

		local fr, fc, msp
		
		if type(GnomTEC_Badge_Flags[realm][player].FR) == "number" then
			fr = str_fr[GnomTEC_Badge_Flags[realm][player].FR]
		elseif type(GnomTEC_Badge_Flags[realm][player].FR) == "string" then
			-- cleanup UI Escape Sequences which ar not yet filtered
			GnomTEC_Badge_Flags[realm][player].FR = emptynil(cleanpipe(GnomTEC_Badge_Flags[realm][player].FR))
			fr = GnomTEC_Badge_Flags[realm][player].FR
		end
		if type(GnomTEC_Badge_Flags[realm][player].FC) == "number" then
			fc = str_fc[GnomTEC_Badge_Flags[realm][player].FC]
		elseif type(GnomTEC_Badge_Flags[realm][player].FC) == "string" then
			-- cleanup UI Escape Sequences which ar not yet filtered
			GnomTEC_Badge_Flags[realm][player].FC = emptynil(cleanpipe(GnomTEC_Badge_Flags[realm][player].FC))
			fc = GnomTEC_Badge_Flags[realm][player].FC
		end
		if GnomTEC_Badge_Flags[realm][player].FlagMSP == nil then
			msp = L["L_NORPFLAG"]
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

		-- cleanup UI Escape Sequences which ar not yet filtered
		-- remove when cleanup implemented
		GnomTEC_Badge_Flags[realm][player].DE = emptynil(cleanpipe(GnomTEC_Badge_Flags[realm][player].DE))

		local text = ""
		
		if (1 ==	displayedTAB) then
			-- Description
			if (GnomTEC_Badge_Flags[realm][player].CU) then
				text = text.."|cFFFFFF80--- "..L["L_FIELD_CU"].." ---|r|n"..GnomTEC_Badge_Flags[realm][player].CU.."|n|n"
			end

			local first = true;
			if (GnomTEC_Badge_Flags[realm][player].AG) then
				if (not first) then
					text = text.." / "
				else
					text = text.."|cFFFFFF80--- "
					first = false	
				end
				text = text..L["L_FIELD_AG"]	
			end
			if (GnomTEC_Badge_Flags[realm][player].AE) then
				if (not first) then
					text = text.." / "
				else
					text = text.."|cFFFFFF80--- "
					first = false	
				end
				text = text..L["L_FIELD_AE"]	
			end
			if (GnomTEC_Badge_Flags[realm][player].AH) then
				if (not first) then
					text = text.." / "
				else
					text = text.."|cFFFFFF80--- "
					first = false	
				end
				text = text..L["L_FIELD_AH"]	
			end
			if (GnomTEC_Badge_Flags[realm][player].AW) then
				if (not first) then
					text = text.." / "
				else
					text = text.."|cFFFFFF80--- "
					first = false	
				end
				text = text..L["L_FIELD_AW"]	
			end
			if (not first) then
				text = text.." ---|r|n"
			end

			first = true;
			if (GnomTEC_Badge_Flags[realm][player].AG) then
				if (not first) then
					text = text.." / "
				else
					first = false	
				end
				text = text..GnomTEC_Badge_Flags[realm][player].AG	
			end
			if (GnomTEC_Badge_Flags[realm][player].AE) then
				if (not first) then
					text = text.." / "
				else
					first = false	
				end
				text = text..GnomTEC_Badge_Flags[realm][player].AE	
			end
			if (GnomTEC_Badge_Flags[realm][player].AH) then
				if (not first) then
					text = text.." / "
				else
					first = false	
				end
				text = text..GnomTEC_Badge_Flags[realm][player].AH	
			end
			if (GnomTEC_Badge_Flags[realm][player].AW) then
				if (not first) then
					text = text.." / "
				else
					first = false	
				end
				text = text..GnomTEC_Badge_Flags[realm][player].AW	
			end
			if (not first) then
				text = text.."|n|n"
			end		
		
			if (GnomTEC_Badge_Flags[realm][player].DE) then
				text = text.."|cFFFFFF80--- "..L["L_FIELD_DE"].." ---|r|n"..GnomTEC_Badge_Flags[realm][player].DE.."|n|n"
			end
		
			text = text.."|cFF800000--- EOF ---|r"
		elseif  (2 ==	displayedTAB) then
			-- Meta
			if (GnomTEC_Badge_Flags[realm][player].NH) then
				text = text.."|cFFFFFF80--- "..L["L_FIELD_NH"].." ---|r|n"..GnomTEC_Badge_Flags[realm][player].NH.."|n|n"
			end
			if (GnomTEC_Badge_Flags[realm][player].NI) then
				text = text.."|cFFFFFF80--- "..L["L_FIELD_NI"].." ---|r|n"..GnomTEC_Badge_Flags[realm][player].NI.."|n|n"
			end
			if (GnomTEC_Badge_Flags[realm][player].MO) then
				text = text.."|cFFFFFF80--- "..L["L_FIELD_MO"].." ---|r|n"..GnomTEC_Badge_Flags[realm][player].MO.."|n|n"
			end
			if (GnomTEC_Badge_Flags[realm][player].HH) then
				text = text.."|cFFFFFF80--- "..L["L_FIELD_HH"].." ---|r|n"..GnomTEC_Badge_Flags[realm][player].HH.."|n|n"
			end
			if (GnomTEC_Badge_Flags[realm][player].HB) then
				text = text.."|cFFFFFF80--- "..L["L_FIELD_HB"].." ---|r|n"..GnomTEC_Badge_Flags[realm][player].HB.."|n|n"
			end
			if (GnomTEC_Badge_Flags[realm][player].HI) then
				text = text.."|cFFFFFF80--- "..L["L_FIELD_HI"].." ---|r|n"..GnomTEC_Badge_Flags[realm][player].HI.."|n|n"
			end
			text = text.."|cFF800000--- EOF ---|r"			
		elseif  (3 ==	displayedTAB) then
			-- Notes
			text = text.."|cFFFFFF80>>> coming soon <<<|r|n"
		else
			-- Log
			text = text.."|cFFFFFF80>>> coming soon <<<|r|n"
		end
		GNOMTEC_BADGE_FRAME_SCROLL_TEXT:SetText(text)

-- GnomTEC_Badge:DebugPrintFlag(realm, player)

	else
		GNOMTEC_BADGE_FRAME_NA:SetText("|cffC0C0C0"..player.."|r")
		GNOMTEC_BADGE_FRAME_NT:SetText("")
		GNOMTEC_BADGE_FRAME_GUILD:SetText("")
		GNOMTEC_BADGE_FRAME_ENGINEDATA:SetText("")
		GNOMTEC_BADGE_FRAME_FR_FC:SetText( L["L_NORPFLAG"])
		GNOMTEC_BADGE_FRAME_SCROLL_TEXT:SetText("")
	end
	GNOMTEC_BADGE_FRAME_SCROLL:UpdateScrollChildRect()
	GNOMTEC_BADGE_FRAME_SCROLL_SLIDER:SetMinMaxValues(0, GNOMTEC_BADGE_FRAME_SCROLL:GetVerticalScrollRange())
	GNOMTEC_BADGE_FRAME_SCROLL_SLIDER:SetValue(0) 
end

function GnomTEC_Badge:UpdateTooltip(realm, player)
			
	if (GnomTEC_Badge_Options["Tooltip"] and GnomTEC_Badge_Flags[realm][player]) then
		local i, n

		-- we need two line more then standard tooltip for role play status and titel
		a = 2
		for i=1, a , 1 do
			GameTooltip:AddLine( "-", 1.0, 1.0, 1.0)
		end

		n = GameTooltip:NumLines()
		for i=0, n-a-1 , 1 do
			_G["GameTooltipTextLeft"..(n-i)]:SetText(_G["GameTooltipTextLeft"..(n-a-i)]:GetText())
			_G["GameTooltipTextLeft"..(n-i)]:SetTextColor(_G["GameTooltipTextLeft"..(n-a-i)]:GetTextColor())
			_G["GameTooltipTextRight"..(n-i)]:SetText(_G["GameTooltipTextRight"..(n-a-i)]:GetText())
			_G["GameTooltipTextRight"..(n-i)]:SetTextColor(_G["GameTooltipTextRight"..(n-a-i)]:GetTextColor())
		end
		
		local f = GnomTEC_Badge_Flags[realm][player].FRIEND
		if (f == nil) then
			GameTooltipTextLeft1:SetTextColor(0.75,0.75,0.75)
		elseif (f < 0) then
			GameTooltipTextLeft1:SetTextColor(1.0,0.0,0.0)
		elseif (f > 0) then
			GameTooltipTextLeft1:SetTextColor(0.0,1.0,0.0)
		else
			GameTooltipTextLeft1:SetTextColor(0.5,0.5,1.0)
		end
		GameTooltipTextLeft1:SetText(GnomTEC_Badge_Flags[realm][player].NA or player)	
		GameTooltipTextRight1:SetText("")	
		
		GameTooltipTextLeft2:SetText(GnomTEC_Badge_Flags[realm][player].NT or "")
		GameTooltipTextLeft2:SetTextColor(1.0,1.0,0.0)
		GameTooltipTextRight2:SetText("")
		
		if (GnomTEC_Badge_Flags[realm][player].Guild) then
			GameTooltipTextLeft3:SetText(GnomTEC_Badge_Flags[realm][player].Guild or "")
			GameTooltipTextLeft3:SetTextColor(1.0,1.0,1.0)
			GameTooltipTextRight3:SetText("")
			n = 4
		else
			n = 3
		end
		
		_G["GameTooltipTextLeft"..n]:SetText((GnomTEC_Badge_Flags[realm][player].EngineData or "").." ("..player..")")
		_G["GameTooltipTextLeft"..n]:SetTextColor(1.0,1.0,1.0)
		_G["GameTooltipTextRight"..n]:SetText("")

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
			_G["GameTooltipTextLeft"..(n+1)]:SetText("<"..fr.."><"..fc..">"..msp)
		elseif fr then
			_G["GameTooltipTextLeft"..(n+1)]:SetText("<"..fr..">"..msp)
		elseif fc then
			_G["GameTooltipTextLeft"..(n+1)]:SetText("<"..fc..">"..msp)
		else
			_G["GameTooltipTextLeft"..(n+1)]:SetText(msp)
		end
		_G["GameTooltipTextLeft"..(n+1)]:SetTextColor(1.0,1.0,0.5)
		_G["GameTooltipTextRight"..(n+1)]:SetText("")			

		_G["GameTooltipTextLeft"..(n+2)]:SetText(GnomTEC_Badge_Flags[realm][player].FactionData)
		_G["GameTooltipTextLeft"..(n+2)]:SetTextColor(1.0,1.0,1.0)
		_G["GameTooltipTextRight"..(n+2)]:SetText("")			
		GameTooltip:Show()
	end
end

function GnomTEC_Badge:ClickedTAB(id)

	if (1 == id) then
		-- Description
		GNOMTEC_BADGE_FRAME_TAB_1:LockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_2:UnlockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_3:UnlockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_4:UnlockHighlight();
		displayedTAB = 1
	elseif (2 == id) then
		-- Meta
		GNOMTEC_BADGE_FRAME_TAB_1:UnlockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_2:LockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_3:UnlockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_4:UnlockHighlight();
		displayedTAB = 2
	elseif (3 == id) then
		-- Notes
		GNOMTEC_BADGE_FRAME_TAB_1:UnlockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_2:UnlockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_3:LockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_4:UnlockHighlight();
		displayedTAB = 3
	else
		-- Log
		GNOMTEC_BADGE_FRAME_TAB_1:UnlockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_2:UnlockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_3:UnlockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_4:LockHighlight();
		displayedTAB = 4
	end	
	GnomTEC_Badge:DisplayBadge(displayedPlayerRealm, displayedPlayerName)
end


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
			-- cleanup UI Escape Sequences which ar not yet filtered
			player.NA = emptynil(cleanpipe(player.NA))

			if (player.FRIEND == nil) then
				textNA:SetText("|cffC0C0C0"..(player.NA or playerList[playerListPosition+i]).."|r")		
			elseif (player.FRIEND < 0) then
				textNA:SetText("|cffff0000"..(player.NA or playerList[playerListPosition+i]).."|r")
			elseif (player.FRIEND > 0) then
				textNA:SetText("|cff00ff00"..(player.NA or playerList[playerListPosition+i]).."|r")
			else
				textNA:SetText("|cff8080ff"..(player.NA or playerList[playerListPosition+i]).."|r")
			end	
			-- cleanup UI Escape Sequences which ar not yet filtered
			player.NT = emptynil(cleanpipe(player.NT))
			textNT:SetText(player.NT or "")
			textENGINEDATA:SetText((player.EngineData or  L["L_ENGINEDATA_UNKNOWN"]).." ("..playerList[playerListPosition+i]..")")
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

local function GnomTEC_Badge_MSPcallback(char)
	-- process new flag from char 
	local player, realm = strsplit( "-", char, 2 )
	realm = realm or GetRealmName()
	GnomTEC_Badge:SaveFlag(realm, player)
	GnomTEC_Badge:UpdatePlayerList()
	
	if ((player == displayedPlayerName) and (realm == displayedPlayerRealm)) then
		GnomTEC_Badge:DisplayBadge(realm, player)
	end
	
end
-- ----------------------------------------------------------------------
-- Frame event handler and functions
-- ----------------------------------------------------------------------

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

-- ----------------------------------------------------------------------
-- Hook functions
-- ----------------------------------------------------------------------

-- ----------------------------------------------------------------------
-- Event handler
-- ----------------------------------------------------------------------
function GnomTEC_Badge:PLAYER_REGEN_DISABLED(event)
	playerisInCombat = true;
	if (not GnomTEC_Badge_Options["GnomcorderIntegration"]) then
		GNOMTEC_BADGE_FRAME:Hide();
	end
end

function GnomTEC_Badge:PLAYER_REGEN_ENABLED(event)
	playerisInCombat = false;
end

function GnomTEC_Badge:PLAYER_TARGET_CHANGED(eventName)
    -- process the event
	if (not playerisInCombat) then
	    local player, realm = UnitName("target")
		realm = realm or GetRealmName()

		if UnitIsPlayer("target") and player and realm then
			GnomTEC_Badge:DisplayBadge(realm, player)
			if (not GnomTEC_Badge_Options["GnomcorderIntegration"]) then
				GNOMTEC_BADGE_FRAME:Show();
			end
			GNOMTEC_BADGE_FRAME_PLAYERMODEL:SetUnit("target")
			GNOMTEC_BADGE_FRAME_PLAYERMODEL:SetCamera(0)
		else
			if GnomTEC_Badge_Options["AutoHide"] and (not GNOMTEC_BADGE_PLAYERLIST:IsVisible()) then
				if (not GnomTEC_Badge_Options["GnomcorderIntegration"]) then
					GNOMTEC_BADGE_FRAME:Hide();
				end
			end	
		end
	end
end
    
function GnomTEC_Badge:CURSOR_UPDATE(eventName)
    -- process the event
	if (GnomTEC_Badge_Options["MouseOver"] and (not (GnomTEC_Badge_Options["LockOnTarget"] and UnitExists("target")))) and GnomTEC_Badge_Options["AutoHide"]  and (not GNOMTEC_BADGE_PLAYERLIST:IsVisible()) then
		if (not GnomTEC_Badge_Options["GnomcorderIntegration"]) then
			GNOMTEC_BADGE_FRAME:Hide();
		end
	end	
end
    
function GnomTEC_Badge:UPDATE_MOUSEOVER_UNIT(eventName)
	local player, realm = UnitName("mouseover")
	realm = realm or GetRealmName()

 	if UnitIsPlayer("mouseover") and player and realm then
		if not GnomTEC_Badge_Flags[realm] then GnomTEC_Badge_Flags[realm] = {} end
		if not GnomTEC_Badge_Flags[realm][player] then GnomTEC_Badge_Flags[realm][player] = {} end

		-- Update date from engine
		GnomTEC_Badge_Flags[realm][player].Guild = emptynil(GetGuildInfo("mouseover"))
		local unitLevel = UnitLevel("mouseover")
		if (unitLevel < 0) then
			unitLevel = "??"
		end
		GnomTEC_Badge_Flags[realm][player].EngineData =  L["L_ENGINEDATA_LEVEL"].." "..unitLevel.." "..UnitRace("mouseover").." "..UnitClass("mouseover")	
		local factionE, factionL = UnitFactionGroup("mouseover")
		if (factionE == "Alliance") then		
			GnomTEC_Badge_Flags[realm][player].FactionData = "|TInterface\\PvPRankBadges\\PvPRankAlliance:0|t"..factionL
		else
			GnomTEC_Badge_Flags[realm][player].FactionData = "|TInterface\\PvPRankBadges\\PvPRankHorde:0|t"..factionL
		end
		if (realm ~= GetRealmName()) then
			GnomTEC_Badge_Flags[realm][player].FactionData = GnomTEC_Badge_Flags[realm][player].FactionData.." - "..realm
		end			
	
		-- msp request and badge display only out of combat
		if (not playerisInCombat) then

	    	if not UnitIsUnit("mouseover", "player") then
				msp:Request( table.concat( { UnitName("mouseover") }, "-" ), { "TT", "DE", "AG", "AE", "AH", "AW", "MO", "HI", "HH", "HB" } )
			end
			if (GnomTEC_Badge_Options["MouseOver"] and (not (GnomTEC_Badge_Options["LockOnTarget"] and UnitExists("target")))) then
				GnomTEC_Badge:DisplayBadge(realm, player)
				if (not GnomTEC_Badge_Options["GnomcorderIntegration"]) then
					GNOMTEC_BADGE_FRAME:Show();
				end
				GNOMTEC_BADGE_FRAME_PLAYERMODEL:SetUnit("mouseover")
				GNOMTEC_BADGE_FRAME_PLAYERMODEL:SetCamera(0)
			end
		end

		-- tooltip handling
		GnomTEC_Badge:UpdateTooltip(realm, player)
	end
end

-- function GnomTEC_Badge:CHAT_MSG_CHANNEL(eventName, message, sender, language, channelString, target, flags, worldChannelNumber, channelNumber, channelName)	
--
--	-- process messages in xtensionxtooltip2 from other addons
--	if ((not playerisInCombat) and (string.lower(channelName) == "xtensionxtooltip2")) then
--		local realm = GetRealmName();
--		local player = sender;
--		if not GnomTEC_Badge_Flags[realm] then GnomTEC_Badge_Flags[realm] = {} end
--		if not GnomTEC_Badge_Flags[realm][player] then GnomTEC_Badge_Flags[realm][player] = {} end
--		if not GnomTEC_Badge_Flags[realm][player].AN2 then GnomTEC_Badge_Flags[realm][player].AN2 = player end
--		
--		--
--		-- here could be some code if we sometimes support special things from others
--		--	
--						
--		-- Refresh Badge if it shows player data
--		if ((player == displayedPlayerName) and (realm == displayedPlayerRealm)) then
--			GnomTEC_Badge:DisplayBadge(realm, player)
--		end
--	end
-- end

-- ----------------------------------------------------------------------
-- Addon OnInitialize, OnEnable and OnDisable
-- ----------------------------------------------------------------------
function GnomTEC_Badge:OnInitialize()
 	-- Code that you want to run when the addon is first loaded goes here.
	self.db = LibStub("AceDB-3.0"):New("GnomTEC_BadgeDB")

  
  	GnomTEC_Badge:Print("Willkommen bei GnomTEC_Badge")

end

function GnomTEC_Badge:OnEnable()
    -- Called when the addon is enabled

	-- Initialize options which are propably not valid because they are new added in new versions of addon
	if (nil == GnomTEC_Badge_Options["GnomcorderIntegration"]) then
		GnomTEC_Badge_Options["GnomcorderIntegration"] = false
	end
	if (nil == GnomTEC_Badge_Options["Tooltip"]) then
		GnomTEC_Badge_Options["Tooltip"] = true
	end
	
	-- Initialize localized strings in GUI
	GNOMTEC_BADGE_FRAME_TAB_1_TEXT:SetText(L["L_TAB_DESCR"])
	GNOMTEC_BADGE_FRAME_TAB_2_TEXT:SetText(L["L_TAB_META"])
	GNOMTEC_BADGE_FRAME_TAB_3_TEXT:SetText(L["L_TAB_NOTE"])
	GNOMTEC_BADGE_FRAME_TAB_4_TEXT:SetText(L["L_TAB_LOG"])
	GnomTEC_Badge:ClickedTAB(1)
	
	GnomTEC_Badge:Print("GnomTEC_Badge Enabled")
	GnomTEC_Badge:RegisterEvent("CURSOR_UPDATE");
	GnomTEC_Badge:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
	GnomTEC_Badge:RegisterEvent("PLAYER_TARGET_CHANGED");
--	GnomTEC_Badge:RegisterEvent("CHAT_MSG_CHANNEL");
	GnomTEC_Badge:RegisterEvent("PLAYER_REGEN_DISABLED");
	GnomTEC_Badge:RegisterEvent("PLAYER_REGEN_ENABLED");
	
	table.insert( msp.callback.received, GnomTEC_Badge_MSPcallback )

	-- Restore saved versions
	for field, ver in pairs( GnomTEC_Badge_Player.Versions ) do
		msp.myver[ field ] = ver
	end
	GnomTEC_Badge:SetMSP(true)
	
	-- GnomTEC Gnomcorder support
	if (GnomTEC_Gnomcorder) and GnomTEC_Badge_Options["GnomcorderIntegration"] then
		GNOMTEC_BADGE_FRAME:SetWidth(400);
		GNOMTEC_BADGE_FRAME:SetHeight(300);
		GNOMTEC_BADGE_FRAME:SetMovable(false);
		GNOMTEC_BADGE_FRAME:SetResizable(false);
		GNOMTEC_BADGE_FRAME:SetBackdrop(nil);
		GNOMTEC_BADGE_FRAME_CloseButton:Hide();
		GnomTEC_Gnomcorder:AddButton("GnomTEC_Badge", "Badge", "Badge anzeigen", GNOMTEC_BADGE_FRAME, "Interface\\ICONS\\INV_Misc_GroupLooking", "Interface\\ICONS\\INV_Misc_GroupLooking", false, nil)
	else
		GnomTEC_Badge_Options["GnomcorderIntegration"] = false
	end
	
	local player, realm = UnitName("player")
    realm = realm or GetRealmName()
	if not GnomTEC_Badge_Flags[realm] then GnomTEC_Badge_Flags[realm] = {} end
    if not GnomTEC_Badge_Flags[realm][player] then GnomTEC_Badge_Flags[realm][player] = {} end
	GnomTEC_Badge_Flags[realm][player].Guild = emptynil(GetGuildInfo("player"))	
	GnomTEC_Badge_Flags[realm][player].EngineData = L["L_ENGINEDATA_LEVEL"].." "..UnitLevel("player").." "..UnitRace("player").." "..UnitClass("player")	
	GNOMTEC_BADGE_FRAME_PLAYERMODEL:SetUnit("player")
	GNOMTEC_BADGE_FRAME_PLAYERMODEL:SetCamera(0)
	GnomTEC_Badge:DisplayBadge(realm, player)
	
end

function GnomTEC_Badge:OnDisable()
    -- Called when the addon is disabled
    
    GnomTEC_Badge:UnregisterAllEvents();
    table.vanish( msp.callback.received, GnomTEC_Badge_MSPcallback )
end

-- ----------------------------------------------------------------------
-- External API
-- ----------------------------------------------------------------------








