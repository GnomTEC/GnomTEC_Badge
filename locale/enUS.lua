-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("GnomTEC_Badge", "enUS", true)
if not L then return end

L["L_STR_FR0"] = "Normal roleplayer"
L["L_STR_FR1"] = "Casual roleplayer"
L["L_STR_FR2"] = "Full–time roleplayer"
L["L_STR_FR3"] = "Beginner roleplayer"
L["L_STR_FR4"] = "Mature roleplayer"

L["L_STR_FC0"] = "Out Of Character (OOC)"
L["L_STR_FC1"] = "In Character (IC)"
L["L_STR_FC2"] = "Looking For Contact"
L["L_STR_FC3"] = "Storyteller (SL)"


L["L_OPTIONS_TITLE"] = "Addon for display and managment of roleplay character descriptions with support of channel and 'Marry Sue Protocol' base roleplay flag protocols.\n\n"

L["L_OPTIONS_PROFILE"] = "Character description"
L["L_OPTIONS_PROFILE_NA"] = "Name"
L["L_OPTIONS_PROFILE_NT"] = "Title"
L["L_OPTIONS_PROFILE_DE"] = "Description"
L["L_OPTIONS_PROFILE_FR"] = "Roleplaying style"
L["L_OPTIONS_PROFILE_FC"] = "roleplaying status"

L["L_OPTIONS_VIEW"] = "Display options"
L["L_OPTIONS_VIEW_MOUSEOVER"] = "Show roleplay flag also on mouseover."
L["L_OPTIONS_VIEW_LOCKONTARGET"] = "Prefer target over mouseover for display."
L["L_OPTIONS_VIEW_AUTOHIDE"] = "Hide roleplay flag automatically."
L["L_OPTIONS_VIEW_DISABLEINCOMBAT"] = "Don't show or update roleplay flag while in combat."
L["L_OPTIONS_VIEW_GNOMCORDERINTEGRATION"] = "Integration in GnomTEC Gnomcorder (requires /reload oder restart)"
L["L_OPTIONS_VIEW_TOOLTIP"] = "Show roleplay flag also in tooltip"

 L["L_NORPFLAG"] = "<no roleplay flag>"
 
 L["L_ENGINEDATA_UNKNOWN"] = "Level -- Unknown Unknown"
 L["L_ENGINEDATA_LEVEL"] = "Level"