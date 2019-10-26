-- **********************************************************************
-- GnomTEC Badge
-- Version: 8.2.5.61
-- Author: GnomTEC
-- Copyright 2011-2019 by GnomTEC
-- http://www.gnomtec.de/
-- **********************************************************************
-- load localization first.
local L = LibStub("AceLocale-3.0"):GetLocale("GnomTEC_Badge")

-- ----------------------------------------------------------------------
-- Legacy global variables and constants (will be deleted in future)
-- ----------------------------------------------------------------------

GnomTEC_Badge_Flags = nil

-- ----------------------------------------------------------------------
-- Addon global Constants (local)
-- ----------------------------------------------------------------------

-- internal used version number since WoW only updates from TOC on game start
local addonVersion = "8.2.5.61"

-- addonInfo for addon registration to GnomTEC API
local addonInfo = {
	["Name"] = "GnomTEC Badge",
	["Version"] = addonVersion,
	["Date"] = "2019-10-27",
	["Author"] = "GnomTEC",
	["Email"] = "info@gnomtec.de",
	["Website"] = "http://www.gnomtec.de/",
	["Copyright"] = "(c)2011-2019 by GnomTEC",
}

-- GnomTEC API revision
local GNOMTEC_REVISION = 0

-- Log levels
local LOG_FATAL 	= 0
local LOG_ERROR		= 1
local LOG_WARN		= 2
local LOG_INFO 		= 3
local LOG_DEBUG 	= 4
	
-- default data for database
local defaultsDb = {
	profile = {
		["ViewFlag"] = {
			["ShowOnlyFlagUser"] = false,
			["MouseOver"] = false,
			["LockOnTarget"] = true,
			["AutoHide"] = true,	
			["DisabledFlagDisplay"] = false;
			["DisableAutomatic"] = true,	
			["DisableInCombat"] = true,
			["DisableInInstance"] = true,
			["GnomcorderIntegration"] = false,
			["ColorBackground"] = {0.25,0.25,0.25,1.0}, 
			["ColorBorder"] = {1.0,1.0,1.0,1.0}, 
			["ColorText"] = {1.0,1.0,1.0,1.0}, 
			["ColorTitle"] = {1.0,1.0,0.5,1.0}, 
			["Locked"] = false,
		},
		["ViewTooltip"] = {
			["Enabled"] = true,
		},	
		["ViewChatFrame"] = {
			["Enabled"] = false,
		},
		["ViewToolbar"] = {
			["Enabled"] = true,
		},
		["ViewNameplates"] = {
			["Enabled"] = false,
			["ShowOnlyName"] = true,
		},
		["Flag"] = {
			["Versions"] = {},
			["Fields"] = {
				["NA"] = UnitName("player"),
				["NT"] = "",
				["FR"] = nil,
				["FC"] = nil,
				["DE"] = "",
			},
		},
	},
	global = {
		["ViewFlag"] = {
			["ShowOnlyFlagUser"] = false,
			["MouseOver"] = false,
			["LockOnTarget"] = true,
			["AutoHide"] = true,	
			["DisabledFlagDisplay"] = false;
			["DisableAutomatic"] = true,	
			["DisableInCombat"] = true,
			["DisableInInstance"] = true,
			["GnomcorderIntegration"] = false,
			["ColorBackground"] = {0.25,0.25,0.25,1.0}, 
			["ColorBorder"] = {1.0,1.0,1.0,1.0}, 
			["ColorText"] = {1.0,1.0,1.0,1.0}, 
			["ColorTitle"] = {1.0,1.0,0.5,1.0}, 
			["Locked"] = false,
		},
		["ViewTooltip"] = {
			["Enabled"] = true,
		},	
		["ViewChatFrame"] = {
			["Enabled"] = false,
		},
		["ViewToolbar"] = {
			["Enabled"] = true,
		},
		["ViewNameplates"] = {
			["Enabled"] = false,
			["ShowOnlyName"] = true,
		},
	},
	char = {
		["ConfigurationSource"] = {
			["Flag"] = "CHAR",
			["ViewFlag"] = "PROFILE",
			["ViewTooltip"] = "PROFILE",
			["ViewChatFrame"] = "PROFILE",
			["ViewToolbar"] = "PROFILE",
			["ViewNameplates"] = "PROFILE",
		},		
		["ViewFlag"] = {
			["ShowOnlyFlagUser"] = false,
			["MouseOver"] = false,
			["LockOnTarget"] = true,
			["AutoHide"] = true,	
			["DisabledFlagDisplay"] = false;
			["DisableAutomatic"] = true,	
			["DisableInCombat"] = true,
			["DisableInInstance"] = true,
			["GnomcorderIntegration"] = false,
			["ColorBackground"] = {0.25,0.25,0.25,1.0}, 
			["ColorBorder"] = {1.0,1.0,1.0,1.0}, 
			["ColorText"] = {1.0,1.0,1.0,1.0}, 
			["ColorTitle"] = {1.0,1.0,0.5,1.0}, 
			["Locked"] = false,
		},
		["ViewTooltip"] = {
			["Enabled"] = true,
		},	
		["ViewChatFrame"] = {
			["Enabled"] = false,
		},
		["ViewToolbar"] = {
			["Enabled"] = true,
		},
		["ViewNameplates"] = {
			["Enabled"] = false,
			["ShowOnlyName"] = true,
		},
		["Flag"] = {
			["Versions"] = {},
			["Fields"] = {
				["NA"] = UnitName("player"),
				["NT"] = "",
				["FR"] = nil,
				["FC"] = nil,
				["DE"] = "",
			},
		},
	},
}

local str_fr = {[0]=L["L_STR_FR0"], L["L_STR_FR1"], L["L_STR_FR2"], L["L_STR_FR3"], L["L_STR_FR4"], L["L_STR_FR5"]}
local str_fc = {[0]=L["L_STR_FC0"], L["L_STR_FC1"], L["L_STR_FC2"], L["L_STR_FC3"], L["L_STR_FC4"]}

-- player states
local playerStatesAFK = {
	["Online"] = {
		text = "|TInterface\\FriendsFrame\\StatusIcon-Online:0|tOnline",
		notCheckable = 1,
		func = function () if (UnitIsAFK("player")) then SendChatMessage("","AFK"); end; if (UnitIsDND("player")) then SendChatMessage("","DND"); end; GNOMTEC_BADGE_TOOLBAR_SELECTAFK_BUTTON:SetText("|TInterface\\FriendsFrame\\StatusIcon-Online:0|tOnline"); end,	
	},	
	["AFK"] = {
		text = "|TInterface\\FriendsFrame\\StatusIcon-Away:0|tAFK",
		notCheckable = 1,
		func = function () if (not UnitIsAFK("player")) then SendChatMessage("","AFK"); end; GNOMTEC_BADGE_TOOLBAR_SELECTAFK_BUTTON:SetText("|TInterface\\FriendsFrame\\StatusIcon-Away:0|tAFK")end,	
	},
	["DND"] = {
		text = "|TInterface\\FriendsFrame\\StatusIcon-DND:0|tDND",
		notCheckable = 1,
		func = function () if (not UnitIsDND("player")) then SendChatMessage("","DND"); end; GNOMTEC_BADGE_TOOLBAR_SELECTAFK_BUTTON:SetText("|TInterface\\FriendsFrame\\StatusIcon-DND:0|tDND")end,	
	},
}

local playerStatesOOC = {
	["NIL"] = {
		text = "|TInterface\\FriendsFrame\\StatusIcon-Away:0|tNIL",
		notCheckable = 1,
		func = function () GNOMTEC_BADGE_TOOLBAR_SELECTOOC_BUTTON:SetText("|TInterface\\FriendsFrame\\StatusIcon-Away:0|tNIL"); GnomTEC_Badge.db.char["Flag"]["Fields"]["FC"] = 0; GnomTEC_Badge:SetMSP(); end,	
	},
	["OOC"] = {
		text = "|TInterface\\FriendsFrame\\StatusIcon-DND:0|tOOC",
		notCheckable = 1,
		func = function () GNOMTEC_BADGE_TOOLBAR_SELECTOOC_BUTTON:SetText("|TInterface\\FriendsFrame\\StatusIcon-DND:0|tOOC"); GnomTEC_Badge.db.char["Flag"]["Fields"]["FC"] = 1; GnomTEC_Badge:SetMSP(); end,	
	},
	["IC"] = {
		text = "|TInterface\\FriendsFrame\\StatusIcon-Online:0|tIC",
		notCheckable = 1,
		func = function () GNOMTEC_BADGE_TOOLBAR_SELECTOOC_BUTTON:SetText("|TInterface\\FriendsFrame\\StatusIcon-Online:0|tIC"); GnomTEC_Badge.db.char["Flag"]["Fields"]["FC"] = 2; GnomTEC_Badge:SetMSP();  end,	
	},	
	["LFC"] = {
		text = "|TInterface\\FriendsFrame\\StatusIcon-Online:0|tLFC",
		notCheckable = 1,
		func = function () GNOMTEC_BADGE_TOOLBAR_SELECTOOC_BUTTON:SetText("|TInterface\\FriendsFrame\\StatusIcon-Online:0|tLFC"); GnomTEC_Badge.db.char["Flag"]["Fields"]["FC"] = 3; GnomTEC_Badge:SetMSP();  end,	
	},	
	["SL"] = {
		text = "|TInterface\\FriendsFrame\\StatusIcon-Online:0|tSL",
		notCheckable = 1,
		func = function () GNOMTEC_BADGE_TOOLBAR_SELECTOOC_BUTTON:SetText("|TInterface\\FriendsFrame\\StatusIcon-Online:0|tSL"); GnomTEC_Badge.db.char["Flag"]["Fields"]["FC"] = 4; GnomTEC_Badge:SetMSP();  end,	
	},	
}

local playerStatesFriendA = {
	["Friend"] = {
		text = "A: |TInterface\\AddOns\\GnomTEC_Badge\\Icons\\dummy-friend:0|t",
		notCheckable = 1,
		func = function () GNOMTEC_BADGE_FRAME_PLAYER_SELECTFRIENDA_BUTTON:SetText("A: |TInterface\\AddOns\\GnomTEC_Badge\\Icons\\dummy-friend:0|t"); GnomTEC_Badge:FriendAFriend(); end,	
	},
	["Neutral"] = {
		text = "A: |TInterface\\AddOns\\GnomTEC_Badge\\Icons\\dummy-neutral:0|t",
		notCheckable = 1,
		func = function () GNOMTEC_BADGE_FRAME_PLAYER_SELECTFRIENDA_BUTTON:SetText("A: |TInterface\\AddOns\\GnomTEC_Badge\\Icons\\dummy-neutral:0|t"); GnomTEC_Badge:FriendANeutral(); end,	
	},	
	["Enemy"] = {
		text = "A: |TInterface\\AddOns\\GnomTEC_Badge\\Icons\\dummy-enemy:0|t",
		notCheckable = 1,
		func = function () GNOMTEC_BADGE_FRAME_PLAYER_SELECTFRIENDA_BUTTON:SetText("A: |TInterface\\AddOns\\GnomTEC_Badge\\Icons\\dummy-enemy:0|t"); GnomTEC_Badge:FriendAEnemy(); end,	
	},	
	["Unknown"] = {
		text = "A: |TInterface\\AddOns\\GnomTEC_Badge\\Icons\\dummy-unknown:0|t",
		notCheckable = 1,
		func = function () GNOMTEC_BADGE_FRAME_PLAYER_SELECTFRIENDA_BUTTON:SetText("A: |TInterface\\AddOns\\GnomTEC_Badge\\Icons\\dummy-unknown:0|t"); GnomTEC_Badge:FriendAUnknown(); end,	
	},	
}

local playerStatesFriendC = {
	["Friend"] = {
		text = "C: |TInterface\\AddOns\\GnomTEC_Badge\\Icons\\dummy-friend:0|t",
		notCheckable = 1,
		func = function () GNOMTEC_BADGE_FRAME_PLAYER_SELECTFRIENDA_BUTTON:SetText("C: |TInterface\\AddOns\\GnomTEC_Badge\\Icons\\dummy-friend:0|t"); GnomTEC_Badge:FriendCFriend(); end,	
	},
	["Neutral"] = {
		text = "C: |TInterface\\AddOns\\GnomTEC_Badge\\Icons\\dummy-neutral:0|t",
		notCheckable = 1,
		func = function () GNOMTEC_BADGE_FRAME_PLAYER_SELECTFRIENDA_BUTTON:SetText("C: |TInterface\\AddOns\\GnomTEC_Badge\\Icons\\dummy-neutral:0|t"); GnomTEC_Badge:FriendCNeutral(); end,	
	},	
	["Enemy"] = {
		text = "C: |TInterface\\AddOns\\GnomTEC_Badge\\Icons\\dummy-enemy:0|t",
		notCheckable = 1,
		func = function () GNOMTEC_BADGE_FRAME_PLAYER_SELECTFRIENDA_BUTTON:SetText("C: |TInterface\\AddOns\\GnomTEC_Badge\\Icons\\dummy-enemy:0|t"); GnomTEC_Badge:FriendCEnemy(); end,	
	},	
	["Unknown"] = {
		text = "C: |TInterface\\AddOns\\GnomTEC_Badge\\Icons\\dummy-unknown:0|t",
		notCheckable = 1,
		func = function () GNOMTEC_BADGE_FRAME_PLAYER_SELECTFRIENDA_BUTTON:SetText("C: |TInterface\\AddOns\\GnomTEC_Badge\\Icons\\dummy-unknown:0|t"); GnomTEC_Badge:FriendCUnknown(); end,	
	},	
}

local flagDisplayStates = {
	["On"] = {
		text = "|TInterface\\LFGFrame\\BattlenetWorking0:0|t On",
		notCheckable = 1,
		func = function () GNOMTEC_BADGE_TOOLBAR_SELECTFLAGDISPLAY_BUTTON:SetNormalTexture("Interface\\LFGFrame\\BattlenetWorking0");GnomTEC_Badge.db.profile["ViewFlag"]["DisableAutomatic"] = false; GnomTEC_Badge:DisableFlagDisplay(false); end,	
	},
	["Auto"] = {
		text = "|TInterface\\LFGFrame\\BattlenetWorking2:0|t Auto",
		notCheckable = 1,
		func = function () GNOMTEC_BADGE_TOOLBAR_SELECTFLAGDISPLAY_BUTTON:SetNormalTexture("Interface\\LFGFrame\\BattlenetWorking2");GnomTEC_Badge.db.profile["ViewFlag"]["DisableAutomatic"] = true; GnomTEC_Badge:DisableFlagDisplay(GnomTEC_Badge:GetAutomaticState()); end,	
	},
	["Off"] = {
		text = "|TInterface\\LFGFrame\\BattlenetWorking4:0|t Off",
		notCheckable = 1,
		func = function () GNOMTEC_BADGE_TOOLBAR_SELECTFLAGDISPLAY_BUTTON:SetNormalTexture("Interface\\LFGFrame\\BattlenetWorking4");GnomTEC_Badge.db.profile["ViewFlag"]["DisableAutomatic"] = false; GnomTEC_Badge:DisableFlagDisplay(true); end,	
	},
}

-- ----------------------------------------------------------------------
-- Addon global variables (local)
-- ----------------------------------------------------------------------

local playerIsInCombat = false;
local playerIsInInstance = false;
local disabledFlagDisplay = false;

local panelConfiguration = nil

local displayedPlayerName = ""
local displayedPlayerRealm = ""
local displayedTAB = 1

local playerList = {}
local playerListPosition = 0

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
				name = "|cffffd700".."Version"..": ".._G["GREEN_FONT_COLOR_CODE"]..addonInfo["Version"],
				},
				descriptionAuthor = {
					order = 2,
					type = "description",
					name = "|cffffd700".."Author"..": ".."|cffff8c00"..addonInfo["Author"],
				},
				descriptionEmail = {
					order = 3,
					type = "description",
					name = "|cffffd700".."Email"..": ".._G["HIGHLIGHT_FONT_COLOR_CODE"]..addonInfo["Email"],
				},
				descriptionWebsite = {
					order = 4,
					type = "description",
					name = "|cffffd700".."Website"..": ".._G["HIGHLIGHT_FONT_COLOR_CODE"]..addonInfo["Website"],
				},
				descriptionLicense = {
					order = 5,
					type = "description",
					name = "|cffffd700".."Copyright"..": ".._G["HIGHLIGHT_FONT_COLOR_CODE"]..addonInfo["Copyright"],
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
			set = function(info,val) GnomTEC_Badge.db.char["Flag"]["Fields"]["NA"] = val; GnomTEC_Badge:SetMSP() end,
	   	get = function(info) return GnomTEC_Badge.db.char["Flag"]["Fields"]["NA"] end,
			multiline = false,
			width = 'full',
			order = 1
		},
		badgePlayerNT = {
			type = "input",
			name = L["L_OPTIONS_PROFILE_NT"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.char["Flag"]["Fields"]["NT"] = val; GnomTEC_Badge:SetMSP() end,
    		get = function(info) return GnomTEC_Badge.db.char["Flag"]["Fields"]["NT"] end,
			multiline = false,
			width = 'full',
			order = 2
		},
		badgePlayerFR = {
			type = "select",
			name = L["L_OPTIONS_PROFILE_FR"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.char["Flag"]["Fields"]["FR"] = val; GnomTEC_Badge:SetMSP() end,
			get = function(info) return GnomTEC_Badge.db.char["Flag"]["Fields"]["FR"] end,
			values = str_fr,
			order = 3
		},
		badgePlayerFC = {
			type = "select",
			name = L["L_OPTIONS_PROFILE_FC"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.char["Flag"]["Fields"]["FC"] = val; GnomTEC_Badge:SetMSP() end,
			get = function(info) return GnomTEC_Badge.db.char["Flag"]["Fields"]["FC"] end,
			values = str_fc,
			order = 3
		},
		badgePlayerCU = {
			type = "input",
			name = L["L_OPTIONS_PROFILE_CU"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.char["Flag"]["Fields"]["CU"] = val; GnomTEC_Badge:SetMSP() end,
    		get = function(info) return GnomTEC_Badge.db.char["Flag"]["Fields"]["CU"] end,
			multiline = 2,
			width = 'full',
			order = 4
		},
		badgePlayerRA = {
			type = "input",
			name = L["L_OPTIONS_PROFILE_RA"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.char["Flag"]["Fields"]["RA"] = val; GnomTEC_Badge:SetMSP() end,
    		get = function(info) return GnomTEC_Badge.db.char["Flag"]["Fields"]["RA"] end,
			multiline = false,
			width = 'half',
			order = 5
		},
		badgePlayerAG = {
			type = "input",
			name = L["L_OPTIONS_PROFILE_AG"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.char["Flag"]["Fields"]["AG"] = val; GnomTEC_Badge:SetMSP() end,
    		get = function(info) return GnomTEC_Badge.db.char["Flag"]["Fields"]["AG"] end,
			multiline = false,
			width = 'half',
			order = 5
		},
		badgePlayerAE = {
			type = "input",
			name = L["L_OPTIONS_PROFILE_AE"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.char["Flag"]["Fields"]["AE"] = val; GnomTEC_Badge:SetMSP() end,
    		get = function(info) return GnomTEC_Badge.db.char["Flag"]["Fields"]["AE"] end,
			multiline = false,
			width = 'half',
			order = 5
		},
		badgePlayerAH = {
			type = "input",
			name = L["L_OPTIONS_PROFILE_AH"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.char["Flag"]["Fields"]["AH"] = val; GnomTEC_Badge:SetMSP() end,
    		get = function(info) return GnomTEC_Badge.db.char["Flag"]["Fields"]["AH"] end,
			multiline = false,
			width = 'half',
			order = 5
		},
		badgePlayerAW = {
			type = "input",
			name = L["L_OPTIONS_PROFILE_AW"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.char["Flag"]["Fields"]["AW"] = val; GnomTEC_Badge:SetMSP() end,
    		get = function(info) return GnomTEC_Badge.db.char["Flag"]["Fields"]["AW"] end,
			multiline = false,
			width = 'half',
			order = 5
		},
		badgePlayerDE = {
			type = "input",
			name = L["L_OPTIONS_PROFILE_DE"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.char["Flag"]["Fields"]["DE"] = val; GnomTEC_Badge:SetMSP() end,
    		get = function(info) return GnomTEC_Badge.db.char["Flag"]["Fields"]["DE"] end,
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
			set = function(info,val) GnomTEC_Badge.db.char["Flag"]["Fields"]["NH"] = val; GnomTEC_Badge:SetMSP() end,
	   	get = function(info) return GnomTEC_Badge.db.char["Flag"]["Fields"]["NH"] end,
			multiline = false,
			width = 'full',
			order = 1
		},
		badgePlayerHB = {
			type = "input",
			name = L["L_OPTIONS_META_HB"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.char["Flag"]["Fields"]["HB"] = val; GnomTEC_Badge:SetMSP() end,
    		get = function(info) return GnomTEC_Badge.db.char["Flag"]["Fields"]["HB"] end,
			multiline = false,
			width = 'full',
			order = 2
		},
		badgePlayerHH = {
			type = "input",
			name = L["L_OPTIONS_META_HH"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.char["Flag"]["Fields"]["HH"] = val; GnomTEC_Badge:SetMSP() end,
    		get = function(info) return GnomTEC_Badge.db.char["Flag"]["Fields"]["HH"] end,
			multiline = false,
			width = 'full',
			order = 3
		},
		badgePlayerMO = {
			type = "input",
			name = L["L_OPTIONS_META_MO"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.char["Flag"]["Fields"]["MO"] = val; GnomTEC_Badge:SetMSP() end,
    		get = function(info) return GnomTEC_Badge.db.char["Flag"]["Fields"]["MO"] end,
			multiline = 2,
			width = 'full',
			order = 4
		},
		badgePlayerHI = {
			type = "input",
			name = L["L_OPTIONS_META_HI"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.char["Flag"]["Fields"]["HI"] = val; GnomTEC_Badge:SetMSP() end,
    		get = function(info) return GnomTEC_Badge.db.char["Flag"]["Fields"]["HI"] end,
			multiline = 10,
			width = 'full',
			order = 5
		},
	},
}

local optionsViewFlag = {
	name = L["L_OPTIONS_VIEW_FLAG"],
	type = 'group',
	args = {
		badgeOptionShowOnlyFlagUser = {
			type = "toggle",
			name = L["L_OPTIONS_VIEW_FLAG_SHOWONLYFLAGUSER"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.profile["ViewFlag"]["ShowOnlyFlagUser"] = val end,
			get = function(info) return GnomTEC_Badge.db.profile["ViewFlag"]["ShowOnlyFlagUser"] end,
			width = 'full',
			order = 1
		},
		badgeOptionMouseOver = {
			type = "toggle",
			name = L["L_OPTIONS_VIEW_FLAG_MOUSEOVER"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.profile["ViewFlag"]["MouseOver"] = val end,
			get = function(info) return GnomTEC_Badge.db.profile["ViewFlag"]["MouseOver"] end,
			width = 'full',
			order = 2
		},
		badgeOptionLockOnTarget = {
			type = "toggle",
			name = L["L_OPTIONS_VIEW_FLAG_LOCKONTARGET"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.profile["ViewFlag"]["LockOnTarget"] = val end,
	   	get = function(info) return GnomTEC_Badge.db.profile["ViewFlag"]["LockOnTarget"] end,
			width = 'full',
			order = 3
		},
		badgeOptionAutoHide = {
			type = "toggle",
			name = L["L_OPTIONS_VIEW_FLAG_AUTOHIDE"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.profile["ViewFlag"]["AutoHide"] = val end,
	   	get = function(info) return GnomTEC_Badge.db.profile["ViewFlag"]["AutoHide"] end,
			width = 'full',
			order = 4
		},
		badgeOptionDisableInCombat = {
			type = "toggle",
			name = L["L_OPTIONS_VIEW_FLAG_DISABLEINCOMBAT"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.profile["ViewFlag"]["DisableInCombat"] = val; GnomTEC_Badge:PLAYER_ENTERING_WORLD(nil) end,
	   	get = function(info) return GnomTEC_Badge.db.profile["ViewFlag"]["DisableInCombat"] end,
			width = 'full',
			order = 5
		},
		badgeOptionDisableInInstance = {
			type = "toggle",
			name = L["L_OPTIONS_VIEW_FLAG_DISABLEININSTANCE"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.profile["ViewFlag"]["DisableInInstance"] = val; GnomTEC_Badge:PLAYER_ENTERING_WORLD(nil) end,
	   	get = function(info) return GnomTEC_Badge.db.profile["ViewFlag"]["DisableInInstance"] end,
			width = 'full',
			order = 6
		},
		badgeOptionGnomcorderIntegration = {
			type = "toggle",
			name = L["L_OPTIONS_VIEW_FLAG_GNOMCORDERINTEGRATION"],
			desc = "",
			disabled = function(info) return not GnomTEC_Gnomcorder end,
			set = function(info,val) GnomTEC_Badge.db.profile["ViewFlag"]["GnomcorderIntegration"] = val end,
	   	get = function(info) return GnomTEC_Badge.db.profile["ViewFlag"]["GnomcorderIntegration"] end,
			width = 'full',
			order = 7
		},
		badgeOptionColor = {
			type = 'group',
			name = L["L_OPTIONS_VIEW_FLAG_COLOR"],
			inline = true,
			width = 'full',
			order = 8,
			args = {
				badgeOptionColorBackground = {
					type = "color",
					name = L["L_OPTIONS_VIEW_FLAG_COLOR_BACKGROUND"],
					desc = "",
					set = function(info,r,g,b,a) GnomTEC_Badge.db.profile["ViewFlag"]["ColorBackground"] = {r,g,b,a}, GNOMTEC_BADGE_FRAME:SetBackdropColor(r,g,b,a) end,
	   			get = function(info) return unpack(GnomTEC_Badge.db.profile["ViewFlag"]["ColorBackground"]) end,
	 			  	hasAlpha = true,
					order = 1
				},
				badgeOptionColorBorder = {
					type = "color",
					name = L["L_OPTIONS_VIEW_FLAG_COLOR_BORDER"],
					desc = "",
					set = function(info,r,g,b,a) GnomTEC_Badge.db.profile["ViewFlag"]["ColorBorder"] = {r,g,b,a}, GNOMTEC_BADGE_FRAME:SetBackdropBorderColor(r,g,b,a) end,
			   	get = function(info) return  unpack(GnomTEC_Badge.db.profile["ViewFlag"]["ColorBorder"]) end,
	 			  	hasAlpha = true,
					order = 2
				},
				badgeOptionColorText = {
					type = "color",
					name = L["L_OPTIONS_VIEW_FLAG_COLOR_TEXT"],
					desc = "",
					disabled = true,
					set = function(info,r,g,b,a) GnomTEC_Badge.db.profile["ViewFlag"]["ColorText"] = {r,g,b,a}, GnomTEC_Badge:DisplayBadge(displayedPlayerRealm, displayedPlayerName) end,
			   	get = function(info) return  unpack(GnomTEC_Badge.db.profile["ViewFlag"]["ColorText"]) end,
	 			  	hasAlpha = true,
					order = 3
				},
				badgeOptionColorTitle = {
					type = "color",
					name = L["L_OPTIONS_VIEW_FLAG_COLOR_TITLE"],
					desc = "",
					disabled = true,
					set = function(info,r,g,b,a) GnomTEC_Badge.db.profile["ViewFlag"]["ColorTitle"] = {r,g,b,a}, GnomTEC_Badge:DisplayBadge(displayedPlayerRealm, displayedPlayerName) end,
			   	get = function(info) return  unpack(GnomTEC_Badge.db.profile["ViewFlag"]["ColorTitle"]) end,
	 			  	hasAlpha = true,
					order = 4
				},
				badgeOptionColorReset = {
					type = "execute",
					name = L["L_OPTIONS_VIEW_FLAG_COLOR_RESET"],
					desc = "",
					func = function(info)
						GnomTEC_Badge.db.profile["ViewFlag"]["ColorBackground"] = {unpack(defaultsDb.profile["ViewFlag"]["ColorBackground"])}
						GNOMTEC_BADGE_FRAME:SetBackdropColor(unpack(GnomTEC_Badge.db.profile["ViewFlag"]["ColorBackground"]))
						GnomTEC_Badge.db.profile["ViewFlag"]["ColorBorder"] = {unpack(defaultsDb.profile["ViewFlag"]["ColorBorder"])}
						GNOMTEC_BADGE_FRAME:SetBackdropBorderColor(unpack(GnomTEC_Badge.db.profile["ViewFlag"]["ColorBorder"]))
						GnomTEC_Badge.db.profile["ViewFlag"]["ColorText"] = {unpack(defaultsDb.profile["ViewFlag"]["ColorText"])}
						GnomTEC_Badge.db.profile["ViewFlag"]["ColorTitle"] = {unpack(defaultsDb.profile["ViewFlag"]["ColorTitle"])}
						GnomTEC_Badge:DisplayBadge(displayedPlayerRealm, displayedPlayerName)
					end,
					width = 'full',
					order = 5
				},
			},
		},
		badgeOptionViewFlagLocked = {
			type = "toggle",
			name = L["L_OPTIONS_VIEW_FLAG_LOCKED"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.profile["ViewFlag"]["Locked"] = val end,
			get = function(info) return GnomTEC_Badge.db.profile["ViewFlag"]["Locked"] end,
			width = 'full',
			order = 9
		},
	},
}

local optionsViewTooltip = {
	name = L["L_OPTIONS_VIEW_TOOLTIP"],
	type = 'group',
	args = {
		badgeOptionTooltip = {
			type = "toggle",
			name = L["L_OPTIONS_VIEW_TOOLTIP_ENABLED"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.profile["ViewTooltip"]["Enabled"] = val end,
	   	get = function(info) return GnomTEC_Badge.db.profile["ViewTooltip"]["Enabled"] end,
			width = 'full',
			order = 1
		},
	},
}

local optionsViewToolbar = {
	name = L["L_OPTIONS_VIEW_TOOLBAR"],
	type = 'group',
	args = {
		badgeOptionToolbar = {
			type = "toggle",
			name = L["L_OPTIONS_VIEW_TOOLBAR_ENABLED"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.profile["ViewToolbar"]["Enabled"] = val; if (GnomTEC_Badge.db.profile["ViewToolbar"]["Enabled"]) then GNOMTEC_BADGE_TOOLBAR:Show(); else GNOMTEC_BADGE_TOOLBAR:Hide(); end; end,
	   	get = function(info) return GnomTEC_Badge.db.profile["ViewToolbar"]["Enabled"] end,
			width = 'full',
			order = 1
		},
		badgeOptionViewToolbarLocked = {
			type = "toggle",
			name = L["L_OPTIONS_VIEW_TOOLBAR_LOCKED"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.profile["ViewToolbar"]["Locked"] = val end,
			get = function(info) return GnomTEC_Badge.db.profile["ViewToolbar"]["Locked"] end,
			width = 'full',
			order = 2
		},

	},
}

local optionsViewNameplates = {
	name = L["L_OPTIONS_VIEW_NAMEPLATES"],
	type = 'group',
	args = {
		badgeOptionNameplates = {
			type = "toggle",
			name = L["L_OPTIONS_VIEW_NAMEPLATES_ENABLED"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.profile["ViewNameplates"]["Enabled"] = val end,
	   	get = function(info) return GnomTEC_Badge.db.profile["ViewNameplates"]["Enabled"] end,
			width = 'full',
			order = 1
		},
		badgeOptionNameplatesShowOnlyName = {
			type = "toggle",
			name = L["L_OPTIONS_VIEW_NAMEPLATES_SHOWONLYNAME"],
			desc = "",
			disabled = function(info) return not GnomTEC_Badge.db.profile["ViewNameplates"]["Enabled"] end,
			set = function(info,val) GnomTEC_Badge.db.profile["ViewNameplates"]["ShowOnlyName"] = val end,
	   	get = function(info) return GnomTEC_Badge.db.profile["ViewNameplates"]["ShowOnlyName"] end,
			width = 'full',
			order = 2
		},
	},
}

local optionsViewChat = {
	name = L["L_OPTIONS_VIEW_CHATFRAME"],
	type = 'group',
	args = {
		badgeOptionChatFrame = {
			type = "toggle",
			name = L["L_OPTIONS_VIEW_CHATFRAME_ENABLED"],
			desc = "",
			set = function(info,val) GnomTEC_Badge.db.profile["ViewChatFrame"]["Enabled"] = val end,
	   	get = function(info) return GnomTEC_Badge.db.profile["ViewChatFrame"]["Enabled"] end,
			width = 'full',
			order = 1
		},
	},
}

local profilesConfigurationValues = {["CHAR"]="Charakter DB",["GLOBAL"]="Gobale DB",["PROFILE"]="Profil DB"}
local profilesConfigurationValuesFlag = {["CHAR"]="Charakter DB",["PROFILE"]="Profil DB"}

local badgeProfilesConfigurationValues = {"|cFF00FF00Änderungen an den Speicherorten sperren|r", "|cFFFF0000Ändern der Speicherorte ohne Einstellungen zu kopieren|r", "|cFFFF0000Ändern der Speicherorte und Einstellungen kopieren|r"}
local badgeProfilesConfigurationValue = 1
				
local optionsProfilesConfiguration = {
	name = L["L_OPTIONS_PROFILES_CONFIGURATION"],
	type = 'group',
	args = {
		badgeProfilesConfiguration = {
			type = "select",
			name = "Konfiguration der Speicherorte für die Einstellungen dieses Charakter",
			confirm = function(info, val)
				if ((1 == val) or (badgeProfilesConfigurationValue > 1)) then
					return false
				else
					return "Sind Sie sicher was sie jetzt vorhaben?"
				end
			end,
			disabled = true,
			desc = "",
			set = function(info,val) badgeProfilesConfigurationValue = val end,
			get = function(info) return badgeProfilesConfigurationValue end,
			values = badgeProfilesConfigurationValues,
			width = "full",
			order = 1
		},
		badgeProfilesFlag = {
			type = "select",
			style = "radio",
			disabled = function(info) return (1 == badgeProfilesConfigurationValue) end,
			confirm = function(info, val)
				if (GnomTEC_Badge.db.char["ConfigurationSource"]["Flag"] == val) then
					return false
				else
					return "Sind Sie sicher?"
				end
			end,
			name = L["L_OPTIONS_PROFILE"].." & "..L["L_OPTIONS_META"],
			desc = "",
			set = function(info,val) end,
			get = function(info) return GnomTEC_Badge.db.char["ConfigurationSource"]["Flag"] end,
			values = profilesConfigurationValuesFlag,
			order = 2
		},
		badgeProfilesViewFlag = {
			type = "select",
			style = "radio",
			disabled = function(info) return (1 == badgeProfilesConfigurationValue) end,
			confirm = function(info, val)
				if (GnomTEC_Badge.db.char["ConfigurationSource"]["ViewFlag"] == val) then
					return false
				else
					return "Sind Sie sicher?"
				end
			end,
			name = L["L_OPTIONS_VIEW_FLAG"],
			desc = "",
			set = function(info,val) end,
			get = function(info) return GnomTEC_Badge.db.char["ConfigurationSource"]["ViewFlag"] end,
			values = profilesConfigurationValues,
			order = 3
		},
		badgeProfilesViewTooltip = {
			type = "select",
			style = "radio",
			disabled = function(info) return (1 == badgeProfilesConfigurationValue) end,
			confirm = function(info, val)
				if (GnomTEC_Badge.db.char["ConfigurationSource"]["ViewTooltip"] == val) then
					return false
				else
					return "Sind Sie sicher?"
				end
			end,
			name = L["L_OPTIONS_VIEW_TOOLTIP"],
			desc = "",
			set = function(info,val) end,
			get = function(info) return GnomTEC_Badge.db.char["ConfigurationSource"]["ViewTooltip"] end,
			values = profilesConfigurationValues,
			order = 4
		},
		badgeProfilesViewToolbar = {
			type = "select",
			style = "radio",
			disabled = function(info) return (1 == badgeProfilesConfigurationValue) end,
			confirm = function(info, val)
				if (GnomTEC_Badge.db.char["ConfigurationSource"]["ViewToolbar"] == val) then
					return false
				else
					return "Sind Sie sicher?"
				end
			end,
			name = L["L_OPTIONS_VIEW_TOOLBAR"],
			desc = "",
			set = function(info,val) end,
			get = function(info) return GnomTEC_Badge.db.char["ConfigurationSource"]["ViewToolbar"] end,
			values = profilesConfigurationValues,
			order = 5
		},
		badgeProfilesViewNameplates = {
			type = "select",
			style = "radio",
			disabled = function(info) return (1 == badgeProfilesConfigurationValue) end,
			confirm = function(info, val)
				if (GnomTEC_Badge.db.char["ConfigurationSource"]["ViewNameplates"] == val) then
					return false
				else
					return "Sind Sie sicher?"
				end
			end,
			name = L["L_OPTIONS_VIEW_NAMEPLATES"],
			desc = "",
			set = function(info,val) end,
			get = function(info) return GnomTEC_Badge.db.char["ConfigurationSource"]["ViewNameplates"] end,
			values = profilesConfigurationValues,
			order = 6
		},
		badgeProfilesViewChatframe = {
			type = "select",
			style = "radio",
			disabled = function(info) return (1 == badgeProfilesConfigurationValue) end,
			confirm = function(info, val)
				if (GnomTEC_Badge.db.char["ConfigurationSource"]["ViewChatFrame"] == val) then
					return false
				else
					return "Sind Sie sicher?"
				end
			end,
			name = L["L_OPTIONS_VIEW_CHATFRAME"],
			desc = "",
			set = function(info,val) end,
			get = function(info) return GnomTEC_Badge.db.char["ConfigurationSource"]["ViewChatFrame"] end,
			values = profilesConfigurationValues,
			order = 7
		},
	},
}

local optionsExport = {
	name = L["L_OPTIONS_EXPORT"],
	type = 'group',
	args = {
		badgeOptionExport = {
			type = "input",
			name = GetRealmName(),
			desc = "",
			set = function(info,val) end,
    		get = function(info) return GnomTEC_Badge:Export(GetRealmName()) end,
			multiline = 25,
			width = 'full',
			order = 1
		},
	},
}

-- ----------------------------------------------------------------------
-- Startup initialization
-- ----------------------------------------------------------------------

GnomTEC_Badge = LibStub("AceAddon-3.0"):NewAddon("GnomTEC_Badge", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "LibNameplateRegistry-1.0")

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
-- Local stubs for the GnomTEC API
-- ----------------------------------------------------------------------

local function GnomTEC_LogMessage(level, message)
	if (level < LOG_DEBUG) then
		GnomTEC_Badge:Print(message)
	end
end

local function GnomTEC_RegisterAddon()
end

-- ----------------------------------------------------------------------
-- Local functions
-- ----------------------------------------------------------------------

-- function which returns also nil for empty strings
local function emptynil( x ) return x ~= "" and x or nil end

-- function to cleanup control sequences
local function cleanpipe( x )
	x = x or ""
	
	-- Filter TRP2 {} color codes
	x = string.gsub( x, "{%x%x%x%x%x%x}", "" )
	
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

-- function to detect that unit is a player from whom we could get a flag
-- Fix issue for NPC units for which the API function Fixed_UnitIsPlayer() don't return nil
-- (such as Wrathion quest line and Proving Grounds)
local function Fixed_UnitIsPlayer(unitId) 
	if (UnitIsPlayer(unitId)) then
		-- NPCs have no race (at least at the moment)
	   if (UnitRace(unitId)) then
	   	return true
	   else
	   	return false
	   end
	else
 	  return false
	end
end

local function Safeguard_FlagEntry(realm, player)
	if not GnomTEC_Badge_FlagCache[realm] then GnomTEC_Badge_FlagCache[realm] = {} end
	if not GnomTEC_Badge_FlagCache[realm][player] then GnomTEC_Badge_FlagCache[realm][player] = {} end
	if not GnomTEC_Badge_FriendStates[realm] then GnomTEC_Badge_FriendStates[realm] = {} end
	if not GnomTEC_Badge_FriendStates[realm][player] then GnomTEC_Badge_FriendStates[realm][player] = {} end
	if not GnomTEC_Badge_Notes[realm] then GnomTEC_Badge_Notes[realm] = {} end
	if not GnomTEC_Badge_Notes[realm][player] then GnomTEC_Badge_Notes[realm][player] = {} end
end

function GnomTEC_Badge:AddToVAString( addon )
	if not select( 4, GetAddOnInfo( addon ) ) then return end
	msp.my['VA'] = strtrim( format( "%s;%s/%s%s", (msp.my['VA'] or ""), addon, 
		( GetAddOnMetadata( addon, "Version" ) or "" ), 
		(	(GetAddOnMetadata( addon, "X-Test" )=="Alpha" and "a") or 
			(GetAddOnMetadata( addon, "X-Test" )=="Beta" and "b") or "" ) ), "; " )
end

function GnomTEC_Badge:DebugPrintFlag(realm, player)
	Safeguard_FlagEntry(realm, player)
	local r = GnomTEC_Badge_FlagCache[realm][player]
	
	 GnomTEC_LogMessage(LOG_DEBUG, "============================")
	 GnomTEC_LogMessage(LOG_DEBUG, "Player: "..player.."-"..realm)
	 GnomTEC_LogMessage(LOG_DEBUG, "VA Addon versions: "..(r.VA or ""))
	 GnomTEC_LogMessage(LOG_DEBUG, "NA Name: "..(r.NA or ""))
	 GnomTEC_LogMessage(LOG_DEBUG, "NH House Name: "..(r.NH or ""))
	 GnomTEC_LogMessage(LOG_DEBUG, "NI Nickname: "..(r.NI or ""))
	 GnomTEC_LogMessage(LOG_DEBUG, "NT Title: "..(r.NT or ""))
	 GnomTEC_LogMessage(LOG_DEBUG, "RA Race: "..(r.RA or ""))
	 GnomTEC_LogMessage(LOG_DEBUG, "FR RP Style: "..(r.FR or ""))
	 GnomTEC_LogMessage(LOG_DEBUG, "FC Character Status: "..(r.FC or ""))
	 GnomTEC_LogMessage(LOG_DEBUG, "CU Currently: "..(r.CU or ""))
	 GnomTEC_LogMessage(LOG_DEBUG, "DE Physical Description: "..(r.DE or ""))
	 GnomTEC_LogMessage(LOG_DEBUG, "AG Age: "..(r.AG or ""))
	 GnomTEC_LogMessage(LOG_DEBUG, "AE Eye Colour: "..(r.AE or ""))
	 GnomTEC_LogMessage(LOG_DEBUG, "AH Height: "..(r.AH or ""))
	 GnomTEC_LogMessage(LOG_DEBUG, "AW Weight: "..(r.AW or ""))
	 GnomTEC_LogMessage(LOG_DEBUG, "MO Motto: "..(r.MO or ""))
	 GnomTEC_LogMessage(LOG_DEBUG, "HI History: "..(r.HI or ""))
	 GnomTEC_LogMessage(LOG_DEBUG, "HH Home: "..(r.HH or ""))
	 GnomTEC_LogMessage(LOG_DEBUG, "HB Birthplace: "..(r.HB or ""))
	 
end

function GnomTEC_Badge:SaveFlag(realm, player)
	Safeguard_FlagEntry(realm, player)
	local r = GnomTEC_Badge_FlagCache[realm][player]

	r.FlagMSP = true
	r.timeStamp = time()
	local p = msp.char[ player.."-"..realm ]
	
	if (p) then
	
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
 end

function GnomTEC_Badge:SetMSP(init)
	local field, value
	local player, realm = UnitName("player")
	realm = string.gsub(realm or GetRealmName(), "%s+", "")

	local p = msp.char[ player.."-"..realm ]
	
	-- Don't mess with msp.my['TT'], that's used internally
	local tt = msp.my['TT']

	wipe( msp.my )
	msp.my['TT'] = tt
	
	wipe( p.field )
	p.supported = true
	
	for field, value in pairs( GnomTEC_Badge.db.char["Flag"]["Fields"] ) do
		-- we also don't want to send ui escape sequences to others
		value = cleanpipe(value)
		msp.my[ field ] = value
		p.field[ field ] = value
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

	GnomTEC_Badge:SaveFlag(realm, player)
	
	if ( 1 == GnomTEC_Badge.db.char["Flag"]["Fields"]["FC"] ) then
		GNOMTEC_BADGE_TOOLBAR_SELECTOOC_BUTTON:SetText(playerStatesOOC["OOC"].text) 	
	elseif  ( 2 == GnomTEC_Badge.db.char["Flag"]["Fields"]["FC"] ) then
		GNOMTEC_BADGE_TOOLBAR_SELECTOOC_BUTTON:SetText(playerStatesOOC["IC"].text) 
	elseif  ( 3 == GnomTEC_Badge.db.char["Flag"]["Fields"]["FC"] ) then
		GNOMTEC_BADGE_TOOLBAR_SELECTOOC_BUTTON:SetText(playerStatesOOC["LFC"].text) 
	elseif  ( 4 == GnomTEC_Badge.db.char["Flag"]["Fields"]["FC"] ) then
		GNOMTEC_BADGE_TOOLBAR_SELECTOOC_BUTTON:SetText(playerStatesOOC["SL"].text) 
	else
		GNOMTEC_BADGE_TOOLBAR_SELECTOOC_BUTTON:SetText(playerStatesOOC["NIL"].text) 	
	end	

end


function GnomTEC_Badge:DisplayBadge(realm, player)

	if ((not realm) or (not player)) then 
		return;
	elseif (not GnomTEC_Badge_FlagCache[realm]) then
		return;
	elseif (not GnomTEC_Badge_FlagCache[realm][player]) then
		return;
	elseif ((GnomTEC_Badge.db.profile["ViewFlag"]["ShowOnlyFlagUser"]) and (not GnomTEC_Badge_FlagCache[realm][player].VA) and (not GnomTEC_Badge.db.profile["ViewFlag"]["GnomcorderIntegration"])) then
		return;
	end
	
	Safeguard_FlagEntry(realm, player)

	local sliderValue = 0
	if (displayedPlayerRealm == realm) and (displayedPlayerName == player) then
		sliderValue = GNOMTEC_BADGE_FRAME_SCROLL_SLIDER:GetValue()
	end
	
	displayedPlayerRealm = realm;
	displayedPlayerName = player;
	
	GNOMTEC_BADGE_FRAME_SCROLL_TEXT:EnableKeyboard(false);
	GNOMTEC_BADGE_FRAME_SCROLL_TEXT:EnableMouse(false);
	GNOMTEC_BADGE_FRAME_SCROLL_TEXT:ClearFocus();
	
	if (GnomTEC_Badge_FlagCache[realm][player]) then	
			
		local f;
			
		if (GnomTEC_Badge_FriendStates[realm][player].FRIEND_C) then
			f = GnomTEC_Badge_FriendStates[realm][player].FRIEND_C[UnitName("player")];
		else
			f = nil;
		end
		if (f == nil) then
			color = GNOMTEC_BADGE_FRAME_NA:SetText("|cffC0C0C0"..(GnomTEC_Badge_FlagCache[realm][player].NA or player).."|r")
			GNOMTEC_BADGE_FRAME_PLAYER_SELECTFRIENDC_BUTTON:SetText(playerStatesFriendC["Unknown"].text)		
		elseif (f < 0) then
			GNOMTEC_BADGE_FRAME_NA:SetText("|cffff0000"..(GnomTEC_Badge_FlagCache[realm][player].NA or player).."|r")
			GNOMTEC_BADGE_FRAME_PLAYER_SELECTFRIENDC_BUTTON:SetText(playerStatesFriendC["Enemy"].text)		
		elseif (f > 0) then
			GNOMTEC_BADGE_FRAME_NA:SetText("|cff00ff00"..(GnomTEC_Badge_FlagCache[realm][player].NA or player).."|r")
			GNOMTEC_BADGE_FRAME_PLAYER_SELECTFRIENDC_BUTTON:SetText(playerStatesFriendC["Friend"].text)		
		else
			GNOMTEC_BADGE_FRAME_NA:SetText("|cff8080ff"..(GnomTEC_Badge_FlagCache[realm][player].NA or player).."|r")
			GNOMTEC_BADGE_FRAME_PLAYER_SELECTFRIENDC_BUTTON:SetText(playerStatesFriendC["Neutral"].text)		
		end
				
		GNOMTEC_BADGE_FRAME_NT:SetText(GnomTEC_Badge_FlagCache[realm][player].NT or "")
		GNOMTEC_BADGE_FRAME_GUILD:SetText(GnomTEC_Badge_FlagCache[realm][player].Guild or "")
		GNOMTEC_BADGE_FRAME_ENGINEDATA:SetText((GnomTEC_Badge_FlagCache[realm][player].EngineData or "").." ("..player..")")

		local fr, fc, msp, color

		f = GnomTEC_Badge_FriendStates[realm][player].FRIEND;
		if (f == nil) then
			color = "|cffC0C0C0"
			GNOMTEC_BADGE_FRAME_PLAYER_SELECTFRIENDA_BUTTON:SetText(playerStatesFriendA["Unknown"].text)		
		elseif (f < 0) then
			color = "|cffff0000"
			GNOMTEC_BADGE_FRAME_PLAYER_SELECTFRIENDA_BUTTON:SetText(playerStatesFriendA["Enemy"].text)		
		elseif (f > 0) then
			color = "|cff00ff00"
			GNOMTEC_BADGE_FRAME_PLAYER_SELECTFRIENDA_BUTTON:SetText(playerStatesFriendA["Friend"].text)		
		else
			color = "|cff8080ff"
			GNOMTEC_BADGE_FRAME_PLAYER_SELECTFRIENDA_BUTTON:SetText(playerStatesFriendA["Neutral"].text)		
		end

		
		if type(GnomTEC_Badge_FlagCache[realm][player].FR) == "number" then
			fr = str_fr[GnomTEC_Badge_FlagCache[realm][player].FR]
		elseif type(GnomTEC_Badge_FlagCache[realm][player].FR) == "string" then
			fr = GnomTEC_Badge_FlagCache[realm][player].FR
		end
		if type(GnomTEC_Badge_FlagCache[realm][player].FC) == "number" then
			fc = str_fc[GnomTEC_Badge_FlagCache[realm][player].FC]
		elseif type(GnomTEC_Badge_FlagCache[realm][player].FC) == "string" then
			fc = GnomTEC_Badge_FlagCache[realm][player].FC
		end
		if GnomTEC_Badge_FlagCache[realm][player].FlagMSP == nil then
			msp = L["L_NORPFLAG"]
		elseif GnomTEC_Badge_FlagCache[realm][player].FlagMSP then
			if (fr or fc) then
				msp= ""
			else
				msp = L["L_HIDDENRPFLAG"]
			end
		else
			msp= "<RSP>"		
		end
			
		if fr and fc then
			GNOMTEC_BADGE_FRAME_FR_FC:SetText(color.."<"..fr.."><"..fc..">"..msp.."|r")
		elseif fr then
			GNOMTEC_BADGE_FRAME_FR_FC:SetText(color.."<"..fr..">"..msp.."|r")
		elseif fc then
			GNOMTEC_BADGE_FRAME_FR_FC:SetText(color.."<"..fc..">"..msp.."|r")
		else
			GNOMTEC_BADGE_FRAME_FR_FC:SetText(color..msp.."|r")
		end

		local text = ""
		
		if (1 ==	displayedTAB) then
			-- Description
			if (GnomTEC_Badge_FlagCache[realm][player].CU) then
				text = text.."|cFFFFFF80--- "..L["L_FIELD_CU"].." ---|r|n"..GnomTEC_Badge_FlagCache[realm][player].CU.."|n|n"
			end

			local first = true;
			if (GnomTEC_Badge_FlagCache[realm][player].AG) then
				if (not first) then
					text = text.." / "
				else
					text = text.."|cFFFFFF80--- "
					first = false	
				end
				text = text..L["L_FIELD_AG"]	
			end
			if (GnomTEC_Badge_FlagCache[realm][player].AE) then
				if (not first) then
					text = text.." / "
				else
					text = text.."|cFFFFFF80--- "
					first = false	
				end
				text = text..L["L_FIELD_AE"]	
			end
			if (GnomTEC_Badge_FlagCache[realm][player].AH) then
				if (not first) then
					text = text.." / "
				else
					text = text.."|cFFFFFF80--- "
					first = false	
				end
				text = text..L["L_FIELD_AH"]	
			end
			if (GnomTEC_Badge_FlagCache[realm][player].AW) then
				if (not first) then
					text = text.." / "
				else
					text = text.."|cFFFFFF80--- "
					first = false	
				end
				text = text..L["L_FIELD_AW"]	
			end
			if (GnomTEC_Badge_FlagCache[realm][player].RA) then
				if (not first) then
					text = text.." / "
				else
					text = text.."|cFFFFFF80--- "
					first = false	
				end
				text = text..L["L_FIELD_RA"]	
			end
			if (not first) then
				text = text.." ---|r|n"
			end

			first = true;
			if (GnomTEC_Badge_FlagCache[realm][player].AG) then
				if (not first) then
					text = text.." / "
				else
					first = false	
				end
				text = text..GnomTEC_Badge_FlagCache[realm][player].AG	
			end
			if (GnomTEC_Badge_FlagCache[realm][player].AE) then
				if (not first) then
					text = text.." / "
				else
					first = false	
				end
				text = text..GnomTEC_Badge_FlagCache[realm][player].AE	
			end
			if (GnomTEC_Badge_FlagCache[realm][player].AH) then
				if (not first) then
					text = text.." / "
				else
					first = false	
				end
				text = text..GnomTEC_Badge_FlagCache[realm][player].AH	
			end
			if (GnomTEC_Badge_FlagCache[realm][player].AW) then
				if (not first) then
					text = text.." / "
				else
					first = false	
				end
				text = text..GnomTEC_Badge_FlagCache[realm][player].AW	
			end
			if (GnomTEC_Badge_FlagCache[realm][player].RA) then
				if (not first) then
					text = text.." / "
				else
					first = false	
				end
				text = text..GnomTEC_Badge_FlagCache[realm][player].RA	
			end
			if (not first) then
				text = text.."|n|n"
			end		
		
			if (GnomTEC_Badge_FlagCache[realm][player].DE) then
				text = text.."|cFFFFFF80--- "..L["L_FIELD_DE"].." ---|r|n"..GnomTEC_Badge_FlagCache[realm][player].DE.."|n|n"
			end
		
			text = text.."|cFF800000--- EOF ---|r"
		elseif  (2 ==	displayedTAB) then
			-- Meta
			if (GnomTEC_Badge_FlagCache[realm][player].NH) then
				text = text.."|cFFFFFF80--- "..L["L_FIELD_NH"].." ---|r|n"..GnomTEC_Badge_FlagCache[realm][player].NH.."|n|n"
			end
			if (GnomTEC_Badge_FlagCache[realm][player].NI) then
				text = text.."|cFFFFFF80--- "..L["L_FIELD_NI"].." ---|r|n"..GnomTEC_Badge_FlagCache[realm][player].NI.."|n|n"
			end
			if (GnomTEC_Badge_FlagCache[realm][player].MO) then
				text = text.."|cFFFFFF80--- "..L["L_FIELD_MO"].." ---|r|n"..GnomTEC_Badge_FlagCache[realm][player].MO.."|n|n"
			end
			if (GnomTEC_Badge_FlagCache[realm][player].HH) then
				text = text.."|cFFFFFF80--- "..L["L_FIELD_HH"].." ---|r|n"..GnomTEC_Badge_FlagCache[realm][player].HH.."|n|n"
			end
			if (GnomTEC_Badge_FlagCache[realm][player].HB) then
				text = text.."|cFFFFFF80--- "..L["L_FIELD_HB"].." ---|r|n"..GnomTEC_Badge_FlagCache[realm][player].HB.."|n|n"
			end
			if (GnomTEC_Badge_FlagCache[realm][player].HI) then
				text = text.."|cFFFFFF80--- "..L["L_FIELD_HI"].." ---|r|n"..GnomTEC_Badge_FlagCache[realm][player].HI.."|n|n"
			end
			text = text.."|cFF800000--- EOF ---|r"			
		elseif  (3 ==	displayedTAB) then
			-- Notes account wide visible
			GNOMTEC_BADGE_FRAME_SCROLL_TEXT:EnableKeyboard(true);
			GNOMTEC_BADGE_FRAME_SCROLL_TEXT:EnableMouse(true);
			text = GnomTEC_Badge_Notes[realm][player].NOTE or ""
		elseif  (4 ==	displayedTAB) then
			-- Notes only with now played character visible
			GNOMTEC_BADGE_FRAME_SCROLL_TEXT:EnableKeyboard(true);
			GNOMTEC_BADGE_FRAME_SCROLL_TEXT:EnableMouse(true);
			if (GnomTEC_Badge_Notes[realm][player].NOTE_C) then
				text = GnomTEC_Badge_Notes[realm][player].NOTE_C[UnitName("player")] or ""
			else
				text = ""
			end
		else
			-- Log
			text = text.."|cFFFFFF80--- Addon used by ".. player.." ---|r|n"
			if (GnomTEC_Badge_FlagCache[realm][player].VA) then
				text = text..GnomTEC_Badge_FlagCache[realm][player].VA.."|n|n"
			else
				text = text.."|cFFFF0000<Unknown>|r|n|n"
			end
			text = text.."|cFFFFFF80--- Timestamp of last flag update from ".. player.." ---|r|n"
			if (GnomTEC_Badge_FlagCache[realm][player].timeStamp) then
				text = text..date("%d.%m.%y %H:%M:%S",GnomTEC_Badge_FlagCache[realm][player].timeStamp).."|n|n"
			else
				text = text.."|cFFFF0000<Unknown>|r|n|n"
			end			
			text = text.."|cFFFFFF80--- Received MSP chunks from ".. player.." ---|r|n"
			local first = true;
			for field, value in pairs( GnomTEC_Badge_FlagCache[realm][player] ) do
				if (2 == #field) then
					-- all longer field names are internal and not from MSP
					if (not first) then
						text = text..", "
					else
						first = false	
					end
					text = text..field.." ("..L["L_FIELD_"..field]..")"	
				end
			end
			if (not first) then
				text = text.."|n|n"
			else
				text = text.."|cFFFF0000<None>|r|n|n"
			end
			
			text = text.."|cFF800000--- EOF ---|r"						
		end
		GNOMTEC_BADGE_FRAME_SCROLL_TEXT:SetText(text)

-- GnomTEC_Badge:DebugPrintFlag(realm, player)

	else
		GNOMTEC_BADGE_FRAME_NA:SetText("|cffC0C0C0"..player.."|r")
		GNOMTEC_BADGE_FRAME_PLAYER_SELECTFRIENDA_BUTTON:SetText(playerStatesFriendA["Unknown"].text)		
		GNOMTEC_BADGE_FRAME_PLAYER_SELECTFRIENDC_BUTTON:SetText(playerStatesFriendC["Unknown"].text)		
		GNOMTEC_BADGE_FRAME_NT:SetText("")
		GNOMTEC_BADGE_FRAME_GUILD:SetText("")
		GNOMTEC_BADGE_FRAME_ENGINEDATA:SetText("")
		GNOMTEC_BADGE_FRAME_FR_FC:SetText( L["L_NORPFLAG"])
		GNOMTEC_BADGE_FRAME_SCROLL_TEXT:SetText("")
	end
	GNOMTEC_BADGE_FRAME_SCROLL:UpdateScrollChildRect()
	GNOMTEC_BADGE_FRAME_SCROLL_SLIDER:SetMinMaxValues(0, GNOMTEC_BADGE_FRAME_SCROLL:GetVerticalScrollRange())
	GNOMTEC_BADGE_FRAME_SCROLL_SLIDER:SetValue(sliderValue) 
end

function GnomTEC_Badge:UpdateTooltip(realm, player)
	if ((not disabledFlagDisplay) and GnomTEC_Badge.db.profile["ViewTooltip"]["Enabled"] and GnomTEC_Badge_FlagCache[realm][player]) then
		local i, n

		-- we need two line more then standard tooltip for role play status and titel
		a = 2
		for i=1, a , 1 do
			GameTooltip:AddDoubleLine("-", "-", 1.0, 1.0, 1.0, 1.0, 1.0, 1.0);
		end

		n = GameTooltip:NumLines()
		for i=0, n-a-1 , 1 do
			_G["GameTooltipTextLeft"..(n-i)]:SetText(_G["GameTooltipTextLeft"..(n-a-i)]:GetText())
			_G["GameTooltipTextLeft"..(n-i)]:SetTextColor(_G["GameTooltipTextLeft"..(n-a-i)]:GetTextColor())
			_G["GameTooltipTextRight"..(n-i)]:SetText(_G["GameTooltipTextRight"..(n-a-i)]:GetText())
			_G["GameTooltipTextRight"..(n-i)]:SetTextColor(_G["GameTooltipTextRight"..(n-a-i)]:GetTextColor())
		end
	
		local f

		if (GnomTEC_Badge_FriendStates[realm][player].FRIEND_C) then
			f = GnomTEC_Badge_FriendStates[realm][player].FRIEND_C[UnitName("player")];
		else
			f = nil;
		end
		if (f == nil) then
			GameTooltipTextLeft1:SetTextColor(0.75,0.75,0.75)
		elseif (f < 0) then
			GameTooltipTextLeft1:SetTextColor(1.0,0.0,0.0)
		elseif (f > 0) then
			GameTooltipTextLeft1:SetTextColor(0.0,1.0,0.0)
		else
			GameTooltipTextLeft1:SetTextColor(0.5,0.5,1.0)
		end
		GameTooltipTextLeft1:SetText(GnomTEC_Badge_FlagCache[realm][player].NA or player)	
		GameTooltipTextRight1:SetText("")	
	
		GameTooltipTextLeft2:SetText(GnomTEC_Badge_FlagCache[realm][player].NT or "")
		GameTooltipTextLeft2:SetTextColor(1.0,1.0,0.0)
		GameTooltipTextRight2:SetText("")
	
		if (GnomTEC_Badge_FlagCache[realm][player].Guild) then
			GameTooltipTextLeft3:SetText(GnomTEC_Badge_FlagCache[realm][player].Guild or "")
			GameTooltipTextLeft3:SetTextColor(1.0,1.0,1.0)
			GameTooltipTextRight3:SetText("")
			n = 4
		else
			n = 3
		end
	
		_G["GameTooltipTextLeft"..n]:SetText((GnomTEC_Badge_FlagCache[realm][player].EngineData or "").." ("..player..")")
		_G["GameTooltipTextLeft"..n]:SetTextColor(1.0,1.0,1.0)
		_G["GameTooltipTextRight"..n]:SetText("")
		-- Fix for ELVUI which hide this, so show it for sure
		_G["GameTooltipTextLeft"..n]:Show()

		local fr, fc, msp
					
		if type(GnomTEC_Badge_FlagCache[realm][player].FR) == "number" then
			fr = str_fr[GnomTEC_Badge_FlagCache[realm][player].FR]
		elseif type(GnomTEC_Badge_FlagCache[realm][player].FR) == "string" then
			fr = GnomTEC_Badge_FlagCache[realm][player].FR
		end
		if type(GnomTEC_Badge_FlagCache[realm][player].FC) == "number" then
			fc = str_fc[GnomTEC_Badge_FlagCache[realm][player].FC]
		elseif type(GnomTEC_Badge_FlagCache[realm][player].FC) == "string" then
			fc = GnomTEC_Badge_FlagCache[realm][player].FC
		end
		if GnomTEC_Badge_FlagCache[realm][player].FlagMSP == nil then
			msp = L["L_NORPFLAG"]
		elseif GnomTEC_Badge_FlagCache[realm][player].FlagMSP then
			if (fr or fc) then
				msp= ""
			else
				msp = L["L_HIDDENRPFLAG"]
			end
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

		f = GnomTEC_Badge_FriendStates[realm][player].FRIEND;
		if (f == nil) then
			_G["GameTooltipTextLeft"..(n+1)]:SetTextColor(0.75,0.75,0.75)
		elseif (f < 0) then
			_G["GameTooltipTextLeft"..(n+1)]:SetTextColor(1.0,0.0,0.0)
		elseif (f > 0) then
			_G["GameTooltipTextLeft"..(n+1)]:SetTextColor(0.0,1.0,0.0)
		else
			_G["GameTooltipTextLeft"..(n+1)]:SetTextColor(0.5,0.5,1.0)
		end

		_G["GameTooltipTextRight"..(n+1)]:SetText("")			

		_G["GameTooltipTextLeft"..(n+2)]:SetText(GnomTEC_Badge_FlagCache[realm][player].FactionData)
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
		GNOMTEC_BADGE_FRAME_TAB_5:UnlockHighlight();
		displayedTAB = 1
	elseif (2 == id) then
		-- Meta
		GNOMTEC_BADGE_FRAME_TAB_1:UnlockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_2:LockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_3:UnlockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_4:UnlockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_5:UnlockHighlight();
		displayedTAB = 2
	elseif (3 == id) then
		-- Notes (A)
		GNOMTEC_BADGE_FRAME_TAB_1:UnlockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_2:UnlockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_3:LockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_4:UnlockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_5:UnlockHighlight();
		displayedTAB = 3
	elseif (4 == id) then
		-- Notes (C)
		GNOMTEC_BADGE_FRAME_TAB_1:UnlockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_2:UnlockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_3:UnlockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_4:LockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_5:UnlockHighlight();
		displayedTAB = 4
	else
		-- Log
		GNOMTEC_BADGE_FRAME_TAB_1:UnlockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_2:UnlockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_3:UnlockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_4:UnlockHighlight();
		GNOMTEC_BADGE_FRAME_TAB_5:LockHighlight();
		displayedTAB = 5
	end	
	GnomTEC_Badge:DisplayBadge(displayedPlayerRealm, displayedPlayerName)
end


function GnomTEC_Badge:ClickedPlayerList(id)
	if (playerListPosition + id <= #playerList) then
		GNOMTEC_BADGE_FRAME_PLAYER_PLAYERMODEL:ClearModel();
		GnomTEC_Badge:DisplayBadge(string.gsub(GetRealmName(), "%s+", ""),playerList[playerListPosition+id]);
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
			local player = GnomTEC_Badge_FlagCache[string.gsub(GetRealmName(), "%s+", "")][playerList[playerListPosition+i]];
			local player_friend = GnomTEC_Badge_FriendStates[string.gsub(GetRealmName(), "%s+", "")][playerList[playerListPosition+i]];
			local playername = UnitName("player");
			if (player_friend.FRIEND_C == nil) then
				textNA:SetText("|cffC0C0C0"..(player.NA or playerList[playerListPosition+i]).."|r")		
			elseif (player_friend.FRIEND_C[playername] == nil) then
				textNA:SetText("|cffC0C0C0"..(player.NA or playerList[playerListPosition+i]).."|r")		
			elseif (player_friend.FRIEND_C[playername] < 0) then
				textNA:SetText("|cffff0000"..(player.NA or playerList[playerListPosition+i]).."|r")
			elseif (player_friend.FRIEND_C[playername] > 0) then
				textNA:SetText("|cff00ff00"..(player.NA or playerList[playerListPosition+i]).."|r")
			else
				textNA:SetText("|cff8080ff"..(player.NA or playerList[playerListPosition+i]).."|r")
			end	
			textNT:SetText(player.NT or "")
			if (player_friend.FRIEND == nil) then
				textENGINEDATA:SetText((player.EngineData or  L["L_ENGINEDATA_UNKNOWN"]).." (|cffC0C0C0"..playerList[playerListPosition+i].."|r)")
			elseif (player_friend.FRIEND < 0) then
				textENGINEDATA:SetText((player.EngineData or  L["L_ENGINEDATA_UNKNOWN"]).." (|cffff0000"..playerList[playerListPosition+i].."|r)")
			elseif (player_friend.FRIEND > 0) then
				textENGINEDATA:SetText((player.EngineData or  L["L_ENGINEDATA_UNKNOWN"]).." (|cff00ff00"..playerList[playerListPosition+i].."|r)")
			else
				textENGINEDATA:SetText((player.EngineData or  L["L_ENGINEDATA_UNKNOWN"]).." (|cff8080ff"..playerList[playerListPosition+i].."|r)")
			end	
			button:Show();
		end
	end
end

function GnomTEC_Badge:UpdatePlayerList()

	local key,value,rkey,rvalue,id,count,rcount, acount
	local fcount, fcount_badge, fcount_trp2, fcount_mrp, fcount_rsp, fcount_other
	local filter = string.lower(GNOMTEC_BADGE_PLAYERLIST_FILTER:GetText());
	local showFriend = GNOMTEC_BADGE_PLAYERLIST_SHOWFRIEND:GetChecked();
	local showNeutral = GNOMTEC_BADGE_PLAYERLIST_SHOWNEUTRAL:GetChecked();
	local showEnemy = GNOMTEC_BADGE_PLAYERLIST_SHOWENEMY:GetChecked();
	local showUnknown = GNOMTEC_BADGE_PLAYERLIST_SHOWUNKNOWN:GetChecked();
	
	acount = 0;
	for rkey,rvalue in pairs(GnomTEC_Badge_FlagCache) do
		for key,value in pairs(rvalue) do	
			acount = acount+1;
		end
	end

	rcount = 0;
	fcount = 0;
	fcount_badge = 0;
	fcount_trp2 = 0;
	fcount_mrp = 0;
	fcount_rsp = 0;
	fcount_other = 0;
	for key,value in pairs(GnomTEC_Badge_FlagCache[string.gsub(GetRealmName(), "%s+", "")]) do
		rcount = rcount+1;
		if (value.VA) then
			fcount = fcount + 1
			if (string.find(value.VA or "", "^GnomTEC")) then
				fcount_badge = fcount_badge + 1;
			elseif (string.find(value.VA or "", "^TotalRP2")) then
				fcount_trp2 = fcount_trp2 + 1;
			elseif (string.find(value.VA or "", "^MyRolePlay")) then
				fcount_mrp = fcount_mrp + 1;
			elseif (string.find(value.VA or "", "flagRSP")) then
				fcount_rsp = fcount_rsp + 1;
			else
				fcount_other = fcount_other + 1
			end
		end
	end

	count = 0;
	playerList = {}
	for key,value in pairs(GnomTEC_Badge_FlagCache[string.gsub(GetRealmName(), "%s+", "")]) do
		local value_friend = GnomTEC_Badge_FriendStates[string.gsub(GetRealmName(), "%s+", "")][key]
		if ((not GnomTEC_Badge.db.profile["ViewFlag"]["ShowOnlyFlagUser"]) or (value.VA)) then
		 	if (filter == "") or (string.match(string.lower(key),filter) ~= nil) or (string.match(string.lower(value.NA or ""),filter) ~= nil ) then
				if (value_friend.FRIEND == nil) then
					if showUnknown then
						count = count + 1;
						playerList[count] = key;				
					end
				elseif ((value_friend.FRIEND < 0) and showEnemy) or ((value_friend.FRIEND > 0) and showFriend) or ((value_friend.FRIEND == 0) and showNeutral) then
					count = count + 1;
					playerList[count] = key;
				end
			end
		end
	end
	table.sort(playerList)
	
	playerListPosition = floor(GNOMTEC_BADGE_PLAYERLIST_LIST_SLIDER:GetValue());
	if (count > 8) then
		GNOMTEC_BADGE_PLAYERLIST_LIST_SLIDER:SetMinMaxValues(0,count-8);
	else
		GNOMTEC_BADGE_PLAYERLIST_LIST_SLIDER:SetMinMaxValues(0,0);		
	end
	GNOMTEC_BADGE_PLAYERLIST_LIST_SLIDER:SetValue(playerListPosition);
	GnomTEC_Badge:RedrawPlayerList();
	local text = ""
	text = "Filter: "..count.." / "..string.gsub(GetRealmName(), "%s+", "")..": "..rcount.." / Total: "..acount
	if (rcount) then
		text = text.."\n|cFF808000Flag addons used on "..string.gsub(GetRealmName(), "%s+", "").." ("..string.format("%0.1f",fcount/rcount * 100).."% of seen chars have flags):"
	
		if (fcount > 0) then
			text = text.."\nBadge: "..string.format("%0.1f",fcount_badge/fcount * 100).."%"
			text = text.." / TRP2: "..string.format("%0.1f",fcount_trp2/fcount * 100).."%"
			text = text.." / MRP: "..string.format("%0.1f",fcount_mrp/fcount * 100).."%"
			text = text.." / RSP: "..string.format("%0.1f",fcount_rsp/fcount * 100).."%"
			text = text.." / Other: "..string.format("%0.1f",fcount_other/fcount * 100).."%"
		end
	end
	GNOMTEC_BADGE_PLAYERLIST_FOOTER_TEXT:SetText(text);
end

local function GnomTEC_Badge_MSPcallback(char)
	-- process new flag from char 
	local player, realm = strsplit( "-", char, 2 )
	
	if (realm) then
		-- MSP sends also callbacks if someone want's our flag
		-- in this case we should check if flag information is yet available
		-- so we check for addon version information from other side
		if (emptynil(msp.char[ player.."-"..realm ].field.VA)) then
			GnomTEC_Badge:SaveFlag(realm, player)
			if GNOMTEC_BADGE_PLAYERLIST_LIST:IsVisible() then
				GnomTEC_Badge:UpdatePlayerList()
			end	
			if ((player == displayedPlayerName) and (realm == displayedPlayerRealm)) then
				GnomTEC_Badge:DisplayBadge(realm, player)
			end
		end
	end	
end


function GnomTEC_Badge:UnitFlagName(unitName)
	local player, realm = strsplit( "-", unitName, 2 )
	local name = nil

	realm = string.gsub(realm or GetRealmName(), "%s+", "")
	if GnomTEC_Badge_FlagCache[realm] then 
		if GnomTEC_Badge_FlagCache[realm][player] then
			name = GnomTEC_Badge_FlagCache[realm][player].NA
		end
	end
	
	return name
end

local exportRealm = ""

local function sortExportTimeStampFunction(a, b)
	local aTimeStamp = GnomTEC_Badge_FlagCache[exportRealm][a].timeStamp
	local bTimeStamp = GnomTEC_Badge_FlagCache[exportRealm][b].timeStamp
	
	return (aTimeStamp > bTimeStamp)
end

function GnomTEC_Badge:Export(realm)
	local exportData = "Character;Fullname;Addon;Timestamp|n"
	local exportList = {}
	local now = time()
	local timerange = 60*60*24*7 -- letzten 7 tage
	 
	realm = string.gsub(realm or GetRealmName(), "%s+", "")	
	exportRealm = realm
	if (GnomTEC_Badge_FlagCache[realm]) then
		for key,value in pairs(GnomTEC_Badge_FlagCache[realm]) do
			if (value.VA) and (difftime(now, value.timeStamp) < timerange) then
				table.insert(exportList,key)
			end
		end
	end

	table.sort(exportList, sortExportTimeStampFunction)
	for key,value in pairs(exportList) do
		local flag = GnomTEC_Badge_FlagCache[exportRealm][value]
		exportData = exportData..value..";"..(flag.NA or "")..";"..(strsplit( ";", flag.VA, 2 ) or "")..";"..date("%d.%m.%y %H:%M:%S",flag.timeStamp).."|n"
	end

	return exportData
end

-- ----------------------------------------------------------------------
-- Frame event handler and functions
-- ----------------------------------------------------------------------

function GnomTEC_Badge:FriendAFriend()
	local realm = displayedPlayerRealm;
	local player = displayedPlayerName;

	if (GnomTEC_Badge_FriendStates[realm][player]) then
		GnomTEC_Badge_FriendStates[realm][player].FRIEND = 255;
			
		if GNOMTEC_BADGE_PLAYERLIST_LIST:IsVisible() then
			GnomTEC_Badge:UpdatePlayerList()
		end
		GnomTEC_Badge:DisplayBadge(realm, player)
	end
end

function GnomTEC_Badge:FriendAEnemy()
	local realm = displayedPlayerRealm;
	local player = displayedPlayerName;

	if (GnomTEC_Badge_FriendStates[realm][player]) then
		GnomTEC_Badge_FriendStates[realm][player].FRIEND = -255;
			
		if GNOMTEC_BADGE_PLAYERLIST_LIST:IsVisible() then
			GnomTEC_Badge:UpdatePlayerList()
		end
		GnomTEC_Badge:DisplayBadge(realm, player)
	end
end

function GnomTEC_Badge:FriendANeutral()
	local realm = displayedPlayerRealm;
	local player = displayedPlayerName;

	if (GnomTEC_Badge_FriendStates[realm][player]) then
		GnomTEC_Badge_FriendStates[realm][player].FRIEND = 0;
			
		if GNOMTEC_BADGE_PLAYERLIST_LIST:IsVisible() then
			GnomTEC_Badge:UpdatePlayerList()
		end
		GnomTEC_Badge:DisplayBadge(realm, player)
	end
end

function GnomTEC_Badge:FriendAUnknown()
	local realm = displayedPlayerRealm;
	local player = displayedPlayerName;

	if (GnomTEC_Badge_FriendStates[realm][player]) then
		GnomTEC_Badge_FriendStates[realm][player].FRIEND = nil;
			
		if GNOMTEC_BADGE_PLAYERLIST_LIST:IsVisible() then
			GnomTEC_Badge:UpdatePlayerList()
		end
		GnomTEC_Badge:DisplayBadge(realm, player)
	end
end

function GnomTEC_Badge:FriendCFriend()
	local realm = displayedPlayerRealm;
	local player = displayedPlayerName;

	if (GnomTEC_Badge_FriendStates[realm][player]) then
		if (not GnomTEC_Badge_FriendStates[realm][player].FRIEND_C) then
			GnomTEC_Badge_FriendStates[realm][player].FRIEND_C = {}
		end
		GnomTEC_Badge_FriendStates[realm][player].FRIEND_C[UnitName("player")] = 255;
			
		if GNOMTEC_BADGE_PLAYERLIST_LIST:IsVisible() then
			GnomTEC_Badge:UpdatePlayerList()
		end
		GnomTEC_Badge:DisplayBadge(realm, player)
	end
end

function GnomTEC_Badge:FriendCEnemy()
	local realm = displayedPlayerRealm;
	local player = displayedPlayerName;

	if (GnomTEC_Badge_FriendStates[realm][player]) then
		if (not GnomTEC_Badge_FriendStates[realm][player].FRIEND_C) then
			GnomTEC_Badge_FriendStates[realm][player].FRIEND_C = {}
		end
		GnomTEC_Badge_FriendStates[realm][player].FRIEND_C[UnitName("player")] = -255;
			
		if GNOMTEC_BADGE_PLAYERLIST_LIST:IsVisible() then
			GnomTEC_Badge:UpdatePlayerList()
		end
		GnomTEC_Badge:DisplayBadge(realm, player)
	end
end

function GnomTEC_Badge:FriendCNeutral()
	local realm = displayedPlayerRealm;
	local player = displayedPlayerName;

	if (GnomTEC_Badge_FriendStates[realm][player]) then
		if (not GnomTEC_Badge_FriendStates[realm][player].FRIEND_C) then
			GnomTEC_Badge_FriendStates[realm][player].FRIEND_C = {}
		end
		GnomTEC_Badge_FriendStates[realm][player].FRIEND_C[UnitName("player")] = 0;
			
		if GNOMTEC_BADGE_PLAYERLIST_LIST:IsVisible() then
			GnomTEC_Badge:UpdatePlayerList()
		end
		GnomTEC_Badge:DisplayBadge(realm, player)
	end
end

function GnomTEC_Badge:FriendCUnknown()
	local realm = displayedPlayerRealm;
	local player = displayedPlayerName;

	if (GnomTEC_Badge_FriendStates[realm][player]) then
		if (GnomTEC_Badge_FriendStates[realm][player].FRIEND_C) then
			GnomTEC_Badge_FriendStates[realm][player].FRIEND_C[UnitName("player")] = nil;
		end
			
		if GNOMTEC_BADGE_PLAYERLIST_LIST:IsVisible() then
			GnomTEC_Badge:UpdatePlayerList()
		end
		GnomTEC_Badge:DisplayBadge(realm, player)
	end
end

function GnomTEC_Badge:OpenConfiguration()
	InterfaceOptionsFrame_OpenToCategory(panelConfiguration)
	-- sometimes first call lands not on desired panel
	InterfaceOptionsFrame_OpenToCategory(panelConfiguration)
end

function GnomTEC_Badge:UpdateNote()
	local realm = displayedPlayerRealm;
	local player = displayedPlayerName;

	if (GnomTEC_Badge_Notes[realm][player]) then
		if (3 == displayedTAB) then
			GnomTEC_Badge_Notes[realm][player].NOTE = emptynil(GNOMTEC_BADGE_FRAME_SCROLL_TEXT:GetText() or "")
		elseif (4 == displayedTAB) then
			if (not GnomTEC_Badge_Notes[realm][player].NOTE_C) then
				GnomTEC_Badge_Notes[realm][player].NOTE_C = {}
			end
			GnomTEC_Badge_Notes[realm][player].NOTE_C[UnitName("player")] = emptynil(GNOMTEC_BADGE_FRAME_SCROLL_TEXT:GetText() or "")
		end		
	end
end

function GnomTEC_Badge:CleanupFlags()
	local key,value,rkey,rvalue
	
	acount = 0;
	for rkey,rvalue in pairs(GnomTEC_Badge_FlagCache) do
		for key,value in pairs(rvalue) do	
			if (not value.VA) then
				-- no addon version so there is no actual MSP flag 
				if (not GnomTEC_Badge_Notes[rkey][key].NOTE) and (not GnomTEC_Badge_Notes[rkey][key].NOTE_C) and (not GnomTEC_Badge_FriendStates[rkey][key].FRIEND_C) and (not GnomTEC_Badge_FriendStates[rkey][key].FRIEND) then
					-- only cleanup when user had not entered data for this char
					rvalue[key] = nil
				end
			end			
		end
	end

	GnomTEC_Badge:UpdatePlayerList()
end

-- initialize drop down menu afk state
local function GnomTEC_Badge_SelectAFK_InitializeDropDown(level)
	UIDropDownMenu_AddButton(playerStatesAFK["Online"])
	UIDropDownMenu_AddButton(playerStatesAFK["AFK"])
	UIDropDownMenu_AddButton(playerStatesAFK["DND"])
end

-- select afk drop down menu OnLoad
function GnomTEC_Badge:SelectAFK_DropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self, GnomTEC_Badge_SelectAFK_InitializeDropDown, "MENU")
end

-- select afk drop down menu OnClick
function GnomTEC_Badge:SelectAFK_Button_OnClick(self, button, down)
	ToggleDropDownMenu(1, nil, GNOMTEC_BADGE_TOOLBAR_SELECTAFK_DROPDOWN, self:GetName(), 0, 0)
end

-- initialize drop down menu ooc state
local function GnomTEC_Badge_SelectOOC_InitializeDropDown(level)
	UIDropDownMenu_AddButton(playerStatesOOC["NIL"])
	UIDropDownMenu_AddButton(playerStatesOOC["OOC"])
	UIDropDownMenu_AddButton(playerStatesOOC["IC"])
	UIDropDownMenu_AddButton(playerStatesOOC["LFC"])
	UIDropDownMenu_AddButton(playerStatesOOC["SL"])
end

-- select ooc drop down menu OnLoad
function GnomTEC_Badge:SelectOOC_DropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self, GnomTEC_Badge_SelectOOC_InitializeDropDown, "MENU")
end

-- select ooc drop down menu OnClick
function GnomTEC_Badge:SelectOOC_Button_OnClick(self, button, down)
	ToggleDropDownMenu(1, nil, GNOMTEC_BADGE_TOOLBAR_SELECTOOC_DROPDOWN, self:GetName(), 0, 0)
end

-- initialize drop down menu friend state A
local function GnomTEC_Badge_SelectFriendA_InitializeDropDown(level)
	UIDropDownMenu_AddButton(playerStatesFriendA["Friend"])
	UIDropDownMenu_AddButton(playerStatesFriendA["Neutral"])
	UIDropDownMenu_AddButton(playerStatesFriendA["Enemy"])
	UIDropDownMenu_AddButton(playerStatesFriendA["Unknown"])
end

-- select friend state A drop down menu OnLoad
function GnomTEC_Badge:SelectFriendA_DropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self, GnomTEC_Badge_SelectFriendA_InitializeDropDown, "MENU")
end

-- select friend state A drop down menu OnClick
function GnomTEC_Badge:SelectFriendA_Button_OnClick(self, button, down)
	ToggleDropDownMenu(1, nil, GNOMTEC_BADGE_FRAME_PLAYER_SELECTFRIENDA_DROPDOWN, self:GetName(), 0, 0)
end

-- initialize drop down menu friend state C
local function GnomTEC_Badge_SelectFriendC_InitializeDropDown(level)
	UIDropDownMenu_AddButton(playerStatesFriendC["Friend"])
	UIDropDownMenu_AddButton(playerStatesFriendC["Neutral"])
	UIDropDownMenu_AddButton(playerStatesFriendC["Enemy"])
	UIDropDownMenu_AddButton(playerStatesFriendC["Unknown"])
end

-- select friend state C drop down menu OnLoad
function GnomTEC_Badge:SelectFriendC_DropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self, GnomTEC_Badge_SelectFriendC_InitializeDropDown, "MENU")
end

-- select friend state C drop down menu OnClick
function GnomTEC_Badge:SelectFriendC_Button_OnClick(self, button, down)
	ToggleDropDownMenu(1, nil, GNOMTEC_BADGE_FRAME_PLAYER_SELECTFRIENDC_DROPDOWN, self:GetName(), 0, 0)
end


-- initialize drop down menu flag display state
local function GnomTEC_Badge_SelectFlagDisplay_InitializeDropDown(level)
	UIDropDownMenu_AddButton(flagDisplayStates["On"])
	UIDropDownMenu_AddButton(flagDisplayStates["Auto"])
	UIDropDownMenu_AddButton(flagDisplayStates["Off"])
end

-- select flag display drop down menu OnLoad
function GnomTEC_Badge:SelectFlagDisplay_DropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self, GnomTEC_Badge_SelectFlagDisplay_InitializeDropDown, "MENU")
end

-- select flag display drop down menu OnClick
function GnomTEC_Badge:SelectFlagDisplay_Button_OnClick(self, button, down)
	ToggleDropDownMenu(1, nil, GNOMTEC_BADGE_TOOLBAR_SELECTFLAGDISPLAY_DROPDOWN, self:GetName(), 0, 0)
end

function GnomTEC_Badge:DisableFlagDisplay(bool)
	disabledFlagDisplay = bool
   GnomTEC_Badge.db.profile["ViewFlag"]["DisabledFlagDisplay"] = disabledFlagDisplay
end

function GnomTEC_Badge:GetAutomaticState()
	return (playerIsInCombat and GnomTEC_Badge.db.profile["ViewFlag"]["DisableInCombat"]) or (playerIsInInstance and GnomTEC_Badge.db.profile["ViewFlag"]["DisableInInstance"])
end


function GnomTEC_Badge:SetPlayerModelToUnit(unit)
	if (UnitIsVisible(unit)) then
		GNOMTEC_BADGE_FRAME_PLAYER_PLAYERMODEL:ClearModel()
		GNOMTEC_BADGE_FRAME_PLAYER_PLAYERMODEL:SetUnit(unit)
		GNOMTEC_BADGE_FRAME_PLAYER_PLAYERMODEL:SetPortraitZoom(1)
	else
		GNOMTEC_BADGE_FRAME_PLAYER_PLAYERMODEL:ClearModel()	
	end
end


-- ----------------------------------------------------------------------
-- Hook functions
-- ----------------------------------------------------------------------

-- ----------------------------------------------------------------------
-- Event handler
-- ----------------------------------------------------------------------
function GnomTEC_Badge:PLAYER_REGEN_DISABLED(event)
	playerIsInCombat = true;
	if (GnomTEC_Badge.db.profile["ViewFlag"]["DisableAutomatic"]) then
		if (GnomTEC_Badge.db.profile["ViewFlag"]["DisableInCombat"]) then
			GnomTEC_Badge:DisableFlagDisplay(true)
		end
		if (not GnomTEC_Badge.db.profile["ViewFlag"]["GnomcorderIntegration"]) then
			if (disabledFlagDisplay) then
				GNOMTEC_BADGE_FRAME:Hide();
			end
		end
	end
end

function GnomTEC_Badge:PLAYER_REGEN_ENABLED(event)
	playerIsInCombat = false;	
	if (GnomTEC_Badge.db.profile["ViewFlag"]["DisableAutomatic"]) then
		if (GnomTEC_Badge.db.profile["ViewFlag"]["DisableInInstance"]) then
			GnomTEC_Badge:DisableFlagDisplay(playerIsInInstance);
		else 
			GnomTEC_Badge:DisableFlagDisplay(false)
		end
	end
end

function GnomTEC_Badge:PLAYER_ENTERING_WORLD(event)
	playerIsInInstance = IsInInstance()
	if (GnomTEC_Badge.db.profile["ViewFlag"]["DisableAutomatic"]) then
		if (playerIsInInstance and GnomTEC_Badge.db.profile["ViewFlag"]["DisableInInstance"]) then
			GnomTEC_Badge:DisableFlagDisplay(true)
		elseif (GnomTEC_Badge.db.profile["ViewFlag"]["DisableInCombat"]) then
			GnomTEC_Badge:DisableFlagDisplay(playerIsInCombat)
		else 
			GnomTEC_Badge:DisableFlagDisplay(false)
		end

		if (not GnomTEC_Badge.db.profile["ViewFlag"]["GnomcorderIntegration"]) then
			if (disabledFlagDisplay) then
				GNOMTEC_BADGE_FRAME:Hide();
			end
		end
	end
end

function GnomTEC_Badge:PLAYER_FLAGS_CHANGED(event)
	if (UnitIsAFK("player")) then 
		GNOMTEC_BADGE_TOOLBAR_SELECTAFK_BUTTON:SetText(playerStatesAFK["AFK"].text) 
	elseif (UnitIsDND("player")) then
		GNOMTEC_BADGE_TOOLBAR_SELECTAFK_BUTTON:SetText(playerStatesAFK["DND"].text) 
	else
		GNOMTEC_BADGE_TOOLBAR_SELECTAFK_BUTTON:SetText(playerStatesAFK["Online"].text) 
	end
end

function GnomTEC_Badge:PLAYER_EQUIPMENT_CHANGED(slot, hasItem)
	if (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
		GNOMTEC_BADGE_TOOLBAR_SHOWHELM:SetChecked(1 == ShowingHelm())
		GNOMTEC_BADGE_TOOLBAR_SHOWCLOAK:SetChecked(1 == ShowingCloak())
	end
end


function GnomTEC_Badge:PLAYER_TARGET_CHANGED(eventName)
    -- process the event
	if (not disabledFlagDisplay) then
		local player, realm = UnitName("target")
		realm = string.gsub(realm or GetRealmName(), "%s+", "")

		if Fixed_UnitIsPlayer("target") and player and realm then
			GnomTEC_Badge:DisplayBadge(realm, player)
			if (displayedPlayerRealm == realm) and (displayedPlayerName == player) then
				if (not GnomTEC_Badge.db.profile["ViewFlag"]["GnomcorderIntegration"]) then
					GNOMTEC_BADGE_FRAME:Show();
				end
				GnomTEC_Badge:SetPlayerModelToUnit("target")
			else
				if GnomTEC_Badge.db.profile["ViewFlag"]["AutoHide"] and (not GNOMTEC_BADGE_PLAYERLIST:IsVisible()) then
					if (not GnomTEC_Badge.db.profile["ViewFlag"]["GnomcorderIntegration"]) then
						GNOMTEC_BADGE_FRAME:Hide();
					end
				end	
			end
		else
			if GnomTEC_Badge.db.profile["ViewFlag"]["AutoHide"] and (not GNOMTEC_BADGE_PLAYERLIST:IsVisible()) then
				if (not GnomTEC_Badge.db.profile["ViewFlag"]["GnomcorderIntegration"]) then
					GNOMTEC_BADGE_FRAME:Hide();
				end
			end	
		end
	end
end
    
function GnomTEC_Badge:CURSOR_UPDATE(eventName)
    -- process the event
	if (GnomTEC_Badge.db.profile["ViewFlag"]["MouseOver"] and (not (GnomTEC_Badge.db.profile["ViewFlag"]["LockOnTarget"] and UnitExists("target")))) and GnomTEC_Badge.db.profile["ViewFlag"]["AutoHide"]  and (not GNOMTEC_BADGE_PLAYERLIST:IsVisible()) then
		if (not GnomTEC_Badge.db.profile["ViewFlag"]["GnomcorderIntegration"]) then
			GNOMTEC_BADGE_FRAME:Hide();
		end
	end	
end

function GnomTEC_Badge:RequestMSP(unitName)
	if (nil ~= emptynil(unitName)) then
		local player, realm = strsplit( "-", unitName, 2 )
		realm = string.gsub(realm or GetRealmName(), "%s+", "")

		msp:Request(player.."-"..realm, { "TT", "DE", "RA", "AG", "AE", "AH", "AW", "MO", "HI", "HH", "HB" } )
	end
end

function GnomTEC_Badge:UPDATE_MOUSEOVER_UNIT(eventName)
	local player, realm = UnitName("mouseover")
	realm = string.gsub(realm or GetRealmName(), "%s+", "")


 	if Fixed_UnitIsPlayer("mouseover") and player and realm then
		Safeguard_FlagEntry(realm, player)
		-- Update date from engine
		GnomTEC_Badge_FlagCache[realm][player].Guild = emptynil(GetGuildInfo("mouseover"))
		local unitLevel = UnitLevel("mouseover")
		if (unitLevel < 0) then
			unitLevel = "??"
		end
		GnomTEC_Badge_FlagCache[realm][player].EngineData =  L["L_ENGINEDATA_LEVEL"].." "..unitLevel.." "..UnitRace("mouseover").." "..UnitClass("mouseover")	
		local factionE, factionL = UnitFactionGroup("mouseover")
		if (factionE == "Alliance") then		
			GnomTEC_Badge_FlagCache[realm][player].FactionData = "|TInterface\\PvPRankBadges\\PvPRankAlliance:0|t"..factionL
		elseif (factionE == "Horde") then
			GnomTEC_Badge_FlagCache[realm][player].FactionData = "|TInterface\\PvPRankBadges\\PvPRankHorde:0|t"..factionL
		else
			GnomTEC_Badge_FlagCache[realm][player].FactionData = factionL or "???"		
		end
		if (realm ~= string.gsub(GetRealmName(), "%s+", "")) then
			GnomTEC_Badge_FlagCache[realm][player].FactionData = GnomTEC_Badge_FlagCache[realm][player].FactionData.." - "..realm
		end			
	
		-- msp request and badge display only out of combat and instances when options enabled
		if (not disabledFlagDisplay) then

	    	if ((not UnitIsUnit("mouseover", "player")) and UnitIsFriend("mouseover", "player")) then
				GnomTEC_Badge:RequestMSP(table.concat( { UnitName("mouseover") }, "-" ))
			end
			if (GnomTEC_Badge.db.profile["ViewFlag"]["MouseOver"] and (not (GnomTEC_Badge.db.profile["ViewFlag"]["LockOnTarget"] and UnitExists("target")))) then
				GnomTEC_Badge:DisplayBadge(realm, player)
				if (displayedPlayerRealm == realm) and (displayedPlayerName == player) then
					if (not GnomTEC_Badge.db.profile["ViewFlag"]["GnomcorderIntegration"]) then
						GNOMTEC_BADGE_FRAME:Show();
					end
					GnomTEC_Badge:SetPlayerModelToUnit("mouseover")
				end
			end
		end

		-- tooltip handling
		GnomTEC_Badge:UpdateTooltip(realm, player)
	end	
	
	if (GnomTEC_Badge.db.profile["ViewFlag"]["MouseOver"] and (not (GnomTEC_Badge.db.profile["ViewFlag"]["LockOnTarget"] and UnitExists("target")))) and GnomTEC_Badge.db.profile["ViewFlag"]["AutoHide"]  and (not GNOMTEC_BADGE_PLAYERLIST:IsVisible()) then
		if (displayedPlayerRealm ~= realm) or (displayedPlayerName ~= player) then
			if UnitExists("mouseover") and ((not GnomTEC_Badge.db.profile["ViewFlag"]["GnomcorderIntegration"])) then
				GNOMTEC_BADGE_FRAME:Hide();
			end
		end
	end


end

function GnomTEC_Badge:CHAT_MSG_CHANNEL(eventName, message, sender)	
	if (not disabledFlagDisplay) then
		-- Trigger the flag request for sender
		GnomTEC_Badge:RequestMSP(sender)
	end
end

function GnomTEC_Badge:CHAT_MSG_CHANNEL_JOIN(eventName, arg1, sender)	
	if (not disabledFlagDisplay) then
		-- Trigger the flag request for sender
		GnomTEC_Badge:RequestMSP(sender)
	end
end

function GnomTEC_Badge:CHAT_MSG_EMOTE(eventName, message, sender)	
	if (not disabledFlagDisplay) then
		-- Trigger the flag request for sender
		GnomTEC_Badge:RequestMSP(sender)
	end
end

function GnomTEC_Badge:CHAT_MSG_GUILD(eventName, message, sender)	
	if (not disabledFlagDisplay) then
		-- Trigger the flag request for sender
		GnomTEC_Badge:RequestMSP(sender)
	end
end

function GnomTEC_Badge:CHAT_MSG_OFFICER(eventName, message, sender)	
	if (not disabledFlagDisplay) then
		-- Trigger the flag request for sender
		GnomTEC_Badge:RequestMSP(sender)
	end
end

function GnomTEC_Badge:CHAT_MSG_PARTY(eventName, message, sender)	
	if (not disabledFlagDisplay) then
		-- Trigger the flag request for sender
		GnomTEC_Badge:RequestMSP(sender)
	end
end

function GnomTEC_Badge:CHAT_MSG_RAID(eventName, message, sender)	
	if (not disabledFlagDisplay) then
		-- Trigger the flag request for sender
		GnomTEC_Badge:RequestMSP(sender)
	end
end

function GnomTEC_Badge:CHAT_MSG_SAY(eventName, message, sender)	
	if (not disabledFlagDisplay) then
		-- Trigger the flag request for sender
		GnomTEC_Badge:RequestMSP(sender)
	end
end

function GnomTEC_Badge:CHAT_MSG_TEXT_EMOTE(eventName, message, sender)	
	if (not disabledFlagDisplay) then
		-- Trigger the flag request for sender
		GnomTEC_Badge:RequestMSP(sender)
	end
end

function GnomTEC_Badge:CHAT_MSG_WHISPER(eventName, message, sender)	
	if (not disabledFlagDisplay) then
		-- Trigger the flag request for sender
		GnomTEC_Badge:RequestMSP(sender)
	end
end

function GnomTEC_Badge:CHAT_MSG_YELL(eventName, message, sender)	
	if (not disabledFlagDisplay) then
		-- Trigger the flag request for sender
		GnomTEC_Badge:RequestMSP(sender)
	end
end

function GnomTEC_Badge:LNR_ON_NEW_PLATE(eventname, plateFrame, plateData)
	if (not GnomTEC_Badge.db.profile["ViewNameplates"]["Enabled"]) then
		return
	end

	local nameFrame = GnomTEC_Badge:GetPlateRegion(plateFrame, "name")

				
	if (nameFrame) then
		if (nameFrame:GetObjectType() == "FontString") then
			local nameFrameIsShown nameFrame:IsShown()
			
 			-- add our frame
			if (not plateFrame.gnomtec_badge) then
 				plateFrame.gnomtec_badge = plateFrame:CreateFontString()
 				plateFrame.gnomtec_badge:SetFontObject(GameFontWhite)
			end 			

			if (GnomTEC_Badge.db.profile["ViewNameplates"]["ShowOnlyName"]) then
 				-- Hide all sub-frames 
				local frames = { plateFrame:GetChildren() };
				for _, frame in ipairs(frames) do
  					frame.gnomtec_badge_alpha = frame:GetAlpha()
  					frame:SetAlpha(0)
 				end
 				
 				plateFrame.gnomtec_badge:SetPoint("BOTTOM",plateFrame, "BOTTOM",0,0)
 			else
 				plateFrame.gnomtec_badge:SetPoint("BOTTOM", nameFrame, "BOTTOM",0,0)

 				-- Hide only name-frame
 				nameFrame.gnomtec_badge_hide = true
 				nameFrame:Hide()
 			end

  			plateFrame.gnomtec_badge:Show()

			if ( "PLAYER" == plateData.type ) then
   	 		local player = nameFrame:GetText() or ""
   	 		local playerName = player
			local friend = nil;
   	 		if (not string.match(player, "%([#%*]%)")) then
   	 			-- no (*) or (#) in name then player is from our realm
   				local realm = string.gsub(GetRealmName(), "%s+", "")
					if GnomTEC_Badge_FlagCache[realm] then 
						if GnomTEC_Badge_FlagCache[realm][player] then
							playerName = GnomTEC_Badge_FlagCache[realm][player].NA or player
							if (GnomTEC_Badge_FriendStates[realm][player].FRIEND_C) then
								friend = GnomTEC_Badge_FriendStates[realm][player].FRIEND_C[UnitName("player")];
							end							
						end
					end
   	 		end	
				if (friend == nil) then
					plateFrame.gnomtec_badge:SetText("|cffC0C0C0"..playerName.."|r")
				elseif (friend < 0) then
					plateFrame.gnomtec_badge:SetText("|cffff0000"..playerName.."|r")
				elseif (friend > 0) then
					plateFrame.gnomtec_badge:SetText("|cff00ff00"..playerName.."|r")
				else
					plateFrame.gnomtec_badge:SetText("|cff8080ff"..playerName.."|r")
				end
			else
				-- it seems that blizzard not show names for every NPC
				if (nameFrameIsShown) then
					plateFrame.gnomtec_badge:SetText(nameFrame:GetText() or "")
				else
					plateFrame.gnomtec_badge:Hide()
				end			
			end
			plateFrame.gnomtec_badge:SetWidth(plateFrame.gnomtec_badge:GetStringWidth())
		end
	end
 end

function GnomTEC_Badge:LNR_ON_RECYCLE_PLATE(eventname, plateFrame, plateData)
 	-- Show all sub-frames 
	local frames = { plateFrame:GetChildren() };
	for _, frame in ipairs(frames) do
  		if (frame.gnomtec_badge_alpha) then
  			frame:SetAlpha(frame.gnomtec_badge_alpha)
  			frame.gnomtec_badge_alpha = nil
  		end
 	end

	local nameFrame = GnomTEC_Badge:GetPlateRegion(plateFrame, "name")
	if (nameFrame) then
	 	if (nameFrame.gnomtec_badge_hide) then
  			nameFrame:Show()
  			nameFrame.gnomtec_badge_hide = nil
 		end
 	end
 	if (plateFrame.gnomtec_badge) then
		plateFrame.gnomtec_badge:Hide()
	end 			
end

function GnomTEC_Badge:LNR_ON_GUID_FOUND(eventname, frame, GUID, findmethod)
 --   GnomTEC_LogMessage(LOG_DEBUG, "GUID found using"..findmethod.."for"..self:GetPlateName(frame).."'s nameplate:"..GUID);
end


function GnomTEC_Badge:LNR_ERROR_FATAL_INCOMPATIBILITY(eventname, icompatibilityType)
    -- Here you want to check if your add-on and LibNameplateRegistry are not
    -- outdated (old TOC). if they're both up to date then it means that
    -- another add-on author thinks his add-on is more important than yours. In
    -- this later case you can register LNR_ERROR_SETPARENT_ALERT and
    -- LNR_ERROR_SETSCRIPT_ALERT which will detect such behaviour and will give
    -- you the name of the incompatible add-on so you can inform your users properly
    -- about what's happening instead of just silently "not working".
end

-- ----------------------------------------------------------------------
-- RawHook for GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
-- ----------------------------------------------------------------------
function GnomTEC_Badge:GetColoredName(event, ...)

	-- let the original function or who ever colorize the name
	local colordName = GnomTEC_Badge.hooks.GetColoredName(event, ...)
	
	if (GnomTEC_Badge.db.profile["ViewChatFrame"]["Enabled"]) then
		-- we have only to do something when there are more then one arg
		if (select("#",...) > 1) then
			local arg2 = select(2,...)
			local name = GnomTEC_Badge:UnitFlagName(arg2)

			-- only if we have a flag exchange the name
			if (name) then
				local player, realm = strsplit( "-", arg2, 2 )
				realm = string.gsub(realm or GetRealmName(), "%s+", "")

				-- remove realm when it is not yet removed
				colordName = string.gsub(colordName,"%-"..realm,"")
				
				-- exchange player name with flag name
				colordName = string.gsub(colordName,player,name)			
			end
		end
	end
	
	return colordName
end

-- ----------------------------------------------------------------------
-- chat commands
-- ----------------------------------------------------------------------
function GnomTEC_Badge:ChatCommand_badge(input)
	GNOMTEC_BADGE_FRAME:Show();
	GNOMTEC_BADGE_PLAYERLIST:Show();

	if (nil ~= emptynil(input)) then
		GNOMTEC_BADGE_PLAYERLIST_FILTER:SetText(input)
		GnomTEC_Badge:UpdatePlayerList()
	end
	
	GnomTEC_Badge:ClickedPlayerList(1)
end
-- ----------------------------------------------------------------------
-- Addon OnInitialize, OnEnable and OnDisable
-- ----------------------------------------------------------------------
function GnomTEC_Badge:OnInitialize()
 	-- Code that you want to run when the addon is first loaded goes here.
	self.db = LibStub("AceDB-3.0"):New("GnomTEC_BadgeDB", defaultsDb, true);

	LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC Badge Main", optionsMain)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC Badge Profile", optionsProfile)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC Badge Meta", optionsMeta)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC Badge View Flag", optionsViewFlag)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC Badge View Tooltip", optionsViewTooltip)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC Badge View Toolbar", optionsViewToolbar)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC Badge View Nameplates", optionsViewNameplates)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC Badge View Chatframe", optionsViewChat)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC Badge Profiles Configuration", optionsProfilesConfiguration)
	self.profileOptions = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db);
	LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC Badge Profiles Select", self.profileOptions);
	LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC Badge Export", optionsExport)

	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC Badge Main", "GnomTEC Badge");
	panelConfiguration = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC Badge Profile", L["L_OPTIONS_PROFILE"], "GnomTEC Badge");
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC Badge Meta", L["L_OPTIONS_META"], "GnomTEC Badge");
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC Badge View Flag", L["L_OPTIONS_VIEW_FLAG"], "GnomTEC Badge");
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC Badge View Tooltip", L["L_OPTIONS_VIEW_TOOLTIP"], "GnomTEC Badge");
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC Badge View Toolbar", L["L_OPTIONS_VIEW_TOOLBAR"], "GnomTEC Badge");
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC Badge View Nameplates", L["L_OPTIONS_VIEW_NAMEPLATES"], "GnomTEC Badge");
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC Badge View Chatframe", L["L_OPTIONS_VIEW_CHATFRAME"], "GnomTEC Badge");
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC Badge Profiles Configuration", L["L_OPTIONS_PROFILES_CONFIGURATION"], "GnomTEC Badge");
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC Badge Profiles Select", L["L_OPTIONS_PROFILES_SELECT"], "GnomTEC Badge");
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC Badge Export", L["L_OPTIONS_EXPORT"], "GnomTEC Badge");

  	GnomTEC_RegisterAddon()
  	GnomTEC_LogMessage(LOG_INFO, "Willkommen bei GnomTEC_Badge")

end

function GnomTEC_Badge:OnEnable()
    -- Called when the addon is enabled
	local player, realm = UnitName("player")
	realm = realm or GetRealmName()

	if (not self.db.char.badge_version) then
		-- with this char we never used profiles before.
		
		-- set profile
		self.db:SetProfile(table.concat( { player, realm }, " - " ))

		if (GnomTEC_Badge_Options) then
		-- legacy version used and some options are set

			-- Initialize options which are propably not valid because they are new added in a newer version of addon
			if (nil == GnomTEC_Badge_Options["GnomcorderIntegration"]) then
				GnomTEC_Badge_Options["GnomcorderIntegration"] = false
			end
			if (nil == GnomTEC_Badge_Options["Tooltip"]) then
				GnomTEC_Badge_Options["Tooltip"] = true
			end
			if (nil == GnomTEC_Badge_Options["ChatFrame"]) then
				GnomTEC_Badge_Options["ChatFrame"] = false
			end
			if (nil == GnomTEC_Badge_Options["DisableInInstance"]) then
				GnomTEC_Badge_Options["DisableInInstance"] = true
			end
			if (nil == GnomTEC_Badge_Options["Toolbar"]) then
				GnomTEC_Badge_Options["Toolbar"] = true
			end
			if (nil == GnomTEC_Badge_Options["DisableAutomatic"]) then
				GnomTEC_Badge_Options["DisableAutomatic"] = true
			end
			if (nil == GnomTEC_Badge_Options["DisabledFlagDisplay"]) then
				GnomTEC_Badge_Options["DisabledFlagDisplay"] = false
			end
			if (nil == GnomTEC_Badge_Options["Nameplates"]) then
				GnomTEC_Badge_Options["Nameplates"] = false
			end
		
			-- remove spaces from realm names to avoid duplicates when playing on multiple realms
			-- Blizzard API uses spaces in realm names only on actual realm when using GetRealmName().
			-- Players from other realms will come with realm name without spaces
			-- !!! this is only needed for old GnomTEC_Badge_Flags and not for new GnomTEC_Badge_FlagCache
			local realmsToRename ={}
			for key,value in pairs(GnomTEC_Badge_Flags) do
				local newkey = string.gsub(key, "%s+", "")
				if (key ~= newkey) then
					realmsToRename[key] = newkey
				end
			end
			for key,value in pairs(realmsToRename) do
				GnomTEC_Badge_Flags[value] = GnomTEC_Badge_Flags[key]
				GnomTEC_Badge_Flags[key] = nil
			end

			-- copy all previously set options to profile
			self.db.profile["ViewFlag"]["MouseOver"] = GnomTEC_Badge_Options["MouseOver"]
			self.db.profile["ViewFlag"]["LockOnTarget"] = GnomTEC_Badge_Options["LockOnTarget"]
			self.db.profile["ViewFlag"]["AutoHide"] = GnomTEC_Badge_Options["AutoHide"]
			self.db.profile["ViewFlag"]["DisabledFlagDisplay"] = GnomTEC_Badge_Options["DisabledFlagDisplay"]
			self.db.profile["ViewFlag"]["DisableAutomatic"] = GnomTEC_Badge_Options["DisableAutomatic"]
			self.db.profile["ViewFlag"]["DisableInCombat"] = GnomTEC_Badge_Options["DisableInCombat"]
			self.db.profile["ViewFlag"]["DisableInInstance"] = GnomTEC_Badge_Options["DisableInInstance"]
			self.db.profile["ViewFlag"]["GnomcorderIntegration"] = GnomTEC_Badge_Options["GnomcorderIntegration"]
			self.db.profile["ViewTooltip"]["Enabled"] = GnomTEC_Badge_Options["Tooltip"]
			self.db.profile["ViewChatFrame"]["Enabled"] = GnomTEC_Badge_Options["ChatFrame"]
			self.db.profile["ViewToolbar"]["Enabled"] = GnomTEC_Badge_Options["Toolbar"]
			self.db.profile["ViewNameplates"]["Enabled"] = GnomTEC_Badge_Options["Nameplates"]
				
			-- remove legacy options variale
			GnomTEC_Badge_Options = nil
			
				-- set last version which used GnomTEC_Badge_Options in char db
				self.db.char.badge_version = "5.4.2.32"
		else
			-- set actual version in char db
			self.db.char.badge_version = addonVersion			
		end
	end	

	local version_x, version_y, version_z, version_build = strsplit( ".", self.db.char.badge_version)
	version_build = tonumber(version_build)

	-- do some other update things here 
	if (version_build <= 35) then
		if (GnomTEC_Badge_Player) then
			-- character flag is not stored in legacy global variable anymore
			self.db.char["Flag"] = GnomTEC_Badge_Player
			GnomTEC_Badge_Player = nil
		end
	end
	if (version_build <= 50) then
		if (GnomTEC_Badge_Flags) then
			-- other players flag data is now cached in seperate addon to avoid "save issue"
			-- (wow has sometimes problems with large amount of saved data and delete all configs)
			GnomTEC_Badge_FlagCache = GnomTEC_Badge_Flags
			GnomTEC_Badge_Flags = nil
		end
	end
	if (version_build <= 53) then
		-- other players friend states and notes are now stored in seperate addon to avoid "save issue"
		-- (wow has sometimes problems with large amount of saved data and delete all configs)
		for rkey,rvalue in pairs(GnomTEC_Badge_FlagCache) do
			if not GnomTEC_Badge_FriendStates[rkey] then GnomTEC_Badge_FriendStates[rkey] = {} end
			if not GnomTEC_Badge_Notes[rkey] then GnomTEC_Badge_Notes[rkey] = {} end
			for key,value in pairs(rvalue) do
				if not GnomTEC_Badge_FriendStates[rkey][key] then GnomTEC_Badge_FriendStates[rkey][key] = {} end
				if not GnomTEC_Badge_Notes[rkey][key] then GnomTEC_Badge_Notes[rkey][key] = {} end
				if (GnomTEC_Badge_FlagCache[rkey][key].FRIEND) then
					GnomTEC_Badge_FriendStates[rkey][key].FRIEND = GnomTEC_Badge_FlagCache[rkey][key].FRIEND
					GnomTEC_Badge_FlagCache[rkey][key].FRIEND = nil
				end	
				if (GnomTEC_Badge_FlagCache[rkey][key].FRIEND_C) then
					GnomTEC_Badge_FriendStates[rkey][key].FRIEND_C = GnomTEC_Badge_FlagCache[rkey][key].FRIEND_C
					GnomTEC_Badge_FlagCache[rkey][key].FRIEND_C = nil
				end	
				if (GnomTEC_Badge_FlagCache[rkey][key].NOTE) then
					GnomTEC_Badge_Notes[rkey][key].NOTE = GnomTEC_Badge_FlagCache[rkey][key].NOTE
					GnomTEC_Badge_FlagCache[rkey][key].NOTE = nil
				end	
				if (GnomTEC_Badge_FlagCache[rkey][key].NOTE_C) then
					GnomTEC_Badge_Notes[rkey][key].NOTE_C = GnomTEC_Badge_FlagCache[rkey][key].NOTE_C
					GnomTEC_Badge_FlagCache[rkey][key].NOTE_C = nil
				end	
			end
		end
	end
	
	if (version_build <= 57) then
		-- myver is unused in new LibMSP, so we can delete old version informations
		GnomTEC_Badge.db.char["Flag"]["Versions"] = {}
	end
	
	-- set actual version in char db
	self.db.char.badge_version = addonVersion
	
	-- Initialize localized strings in GUI
	GNOMTEC_BADGE_FRAME_TAB_1_TEXT:SetText(L["L_TAB_DESCR"])
	GNOMTEC_BADGE_FRAME_TAB_2_TEXT:SetText(L["L_TAB_META"])
	GNOMTEC_BADGE_FRAME_TAB_3_TEXT:SetText(L["L_TAB_NOTE_A"])
	GNOMTEC_BADGE_FRAME_TAB_4_TEXT:SetText(L["L_TAB_NOTE_C"])
	GNOMTEC_BADGE_FRAME_TAB_5_TEXT:SetText(L["L_TAB_LOG"])
	GnomTEC_Badge:ClickedTAB(1)
	
	-- Initialize color settings in GUI
	GNOMTEC_BADGE_FRAME:SetBackdropColor(unpack(GnomTEC_Badge.db.profile["ViewFlag"]["ColorBackground"]))
	GNOMTEC_BADGE_FRAME:SetBackdropBorderColor(unpack(GnomTEC_Badge.db.profile["ViewFlag"]["ColorBorder"])) 

	-- setup events and hooks
	GnomTEC_Badge:RegisterEvent("CURSOR_UPDATE");
	GnomTEC_Badge:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
	GnomTEC_Badge:RegisterEvent("PLAYER_TARGET_CHANGED");
	GnomTEC_Badge:RegisterEvent("PLAYER_REGEN_DISABLED");
	GnomTEC_Badge:RegisterEvent("PLAYER_REGEN_ENABLED");
	GnomTEC_Badge:RegisterEvent("PLAYER_ENTERING_WORLD");
	GnomTEC_Badge:RegisterEvent("PLAYER_FLAGS_CHANGED");
	GnomTEC_Badge:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");

	GnomTEC_Badge:RegisterEvent("CHAT_MSG_CHANNEL");
	GnomTEC_Badge:RegisterEvent("CHAT_MSG_CHANNEL_JOIN");
	GnomTEC_Badge:RegisterEvent("CHAT_MSG_EMOTE");
	GnomTEC_Badge:RegisterEvent("CHAT_MSG_GUILD");
	GnomTEC_Badge:RegisterEvent("CHAT_MSG_OFFICER");
	GnomTEC_Badge:RegisterEvent("CHAT_MSG_PARTY");
	GnomTEC_Badge:RegisterEvent("CHAT_MSG_RAID");
	GnomTEC_Badge:RegisterEvent("CHAT_MSG_SAY");
	GnomTEC_Badge:RegisterEvent("CHAT_MSG_TEXT_EMOTE");
	GnomTEC_Badge:RegisterEvent("CHAT_MSG_WHISPER");
	GnomTEC_Badge:RegisterEvent("CHAT_MSG_YELL");

	GnomTEC_Badge:RawHook("GetColoredName", true)
	
	GnomTEC_Badge:RegisterChatCommand("badge", "ChatCommand_badge")

		
	table.insert( msp.callback.received, GnomTEC_Badge_MSPcallback )
	
	GnomTEC_Badge:LNR_RegisterCallback("LNR_ON_NEW_PLATE");
	GnomTEC_Badge:LNR_RegisterCallback("LNR_ON_RECYCLE_PLATE");
	GnomTEC_Badge:LNR_RegisterCallback("LNR_ON_GUID_FOUND");
	GnomTEC_Badge:LNR_RegisterCallback("LNR_ERROR_FATAL_INCOMPATIBILITY");

	GnomTEC_Badge:SetMSP(true)
	
	-- GnomTEC Gnomcorder support
	if (GnomTEC_Gnomcorder) and GnomTEC_Badge.db.profile["ViewFlag"]["GnomcorderIntegration"] then
		GNOMTEC_BADGE_FRAME:SetWidth(400);
		GNOMTEC_BADGE_FRAME:SetHeight(300);
		GNOMTEC_BADGE_FRAME:SetMovable(false);
		GNOMTEC_BADGE_FRAME:SetResizable(false);
		GNOMTEC_BADGE_FRAME:SetBackdrop(nil);
		GNOMTEC_BADGE_FRAME_CloseButton:Hide();
		GnomTEC_Gnomcorder:AddButton("GnomTEC_Badge", "Badge", "Badge anzeigen", GNOMTEC_BADGE_FRAME, "Interface\\ICONS\\INV_Misc_GroupLooking", "Interface\\ICONS\\INV_Misc_GroupLooking", false, nil)
	else
		GnomTEC_Badge.db.profile["ViewFlag"]["GnomcorderIntegration"] = false
	end
	
	local player, realm = UnitName("player")
	realm = string.gsub(emptynil(realm) or GetRealmName(), "%s+", "")
	Safeguard_FlagEntry(realm, player)
	GnomTEC_Badge_FlagCache[realm][player].Guild = emptynil(GetGuildInfo("player"))	
	GnomTEC_Badge_FlagCache[realm][player].EngineData = L["L_ENGINEDATA_LEVEL"].." "..UnitLevel("player").." "..UnitRace("player").." "..UnitClass("player")	
	GnomTEC_Badge:SetPlayerModelToUnit("player")
	GnomTEC_Badge:DisplayBadge(realm, player)
	
	if (UnitIsAFK("player")) then 
		GNOMTEC_BADGE_TOOLBAR_SELECTAFK_BUTTON:SetText(playerStatesAFK["AFK"].text) 
	elseif (UnitIsDND("player")) then
		GNOMTEC_BADGE_TOOLBAR_SELECTAFK_BUTTON:SetText(playerStatesAFK["DND"].text) 
	else
		GNOMTEC_BADGE_TOOLBAR_SELECTAFK_BUTTON:SetText(playerStatesAFK["Online"].text) 
	end
	
	disabledFlagDisplay = GnomTEC_Badge.db.profile["ViewFlag"]["DisabledFlagDisplay"];
	if (GnomTEC_Badge.db.profile["ViewFlag"]["DisableAutomatic"]) then
		GNOMTEC_BADGE_TOOLBAR_SELECTFLAGDISPLAY_BUTTON:SetNormalTexture("Interface\\LFGFrame\\BattlenetWorking2") 
	elseif (GnomTEC_Badge.db.profile["ViewFlag"]["DisabledFlagDisplay"]) then
		GNOMTEC_BADGE_TOOLBAR_SELECTFLAGDISPLAY_BUTTON:SetNormalTexture("Interface\\LFGFrame\\BattlenetWorking4") 
	else
		GNOMTEC_BADGE_TOOLBAR_SELECTFLAGDISPLAY_BUTTON:SetNormalTexture("Interface\\LFGFrame\\BattlenetWorking0") 
	end
	
	if ( 1 == GnomTEC_Badge.db.char["Flag"]["Fields"]["FC"] ) then
		GNOMTEC_BADGE_TOOLBAR_SELECTOOC_BUTTON:SetText(playerStatesOOC["OOC"].text) 	
	elseif  ( 2 == GnomTEC_Badge.db.char["Flag"]["Fields"]["FC"] ) then
		GNOMTEC_BADGE_TOOLBAR_SELECTOOC_BUTTON:SetText(playerStatesOOC["IC"].text) 
	elseif  ( 3 == GnomTEC_Badge.db.char["Flag"]["Fields"]["FC"] ) then
		GNOMTEC_BADGE_TOOLBAR_SELECTOOC_BUTTON:SetText(playerStatesOOC["LFC"].text) 
	elseif  ( 4 == GnomTEC_Badge.db.char["Flag"]["Fields"]["FC"] ) then
		GNOMTEC_BADGE_TOOLBAR_SELECTOOC_BUTTON:SetText(playerStatesOOC["SL"].text) 
	else
		GNOMTEC_BADGE_TOOLBAR_SELECTOOC_BUTTON:SetText(playerStatesOOC["NIL"].text) 	
	end	

	if (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
		GNOMTEC_BADGE_TOOLBAR_SHOWHELM:SetChecked(1 == ShowingHelm())
		GNOMTEC_BADGE_TOOLBAR_SHOWCLOAK:SetChecked(1 == ShowingCloak())
	end
		
	GnomTEC_Badge:DisableFlagDisplay(disabledFlagDisplay)
	if (GnomTEC_Badge.db.profile["ViewToolbar"]["Enabled"]) then
		GNOMTEC_BADGE_TOOLBAR:Show()
	end
	
	GnomTEC_LogMessage(LOG_INFO, "GnomTEC_Badge Enabled")
end

function GnomTEC_Badge:OnDisable()
    -- Called when the addon is disabled
    
	GnomTEC_Badge:UnhookAll() 
	GnomTEC_Badge:UnregisterAllEvents();
	table.vanish( msp.callback.received, GnomTEC_Badge_MSPcallback )
	GnomTEC_Badge:LNR_UnregisterAllCallbacks();
end

-- ----------------------------------------------------------------------
-- External API
-- ----------------------------------------------------------------------








