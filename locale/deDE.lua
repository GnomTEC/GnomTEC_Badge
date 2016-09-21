-- German localization file for deDE
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("GnomTEC_Badge", "deDE")
if not L then return end
	
L["L_STR_FR0"] = ""
L["L_STR_FR1"] = "Rollenspieler"
L["L_STR_FR2"] = "Gelegenheits-Rollenspieler"
L["L_STR_FR3"] = "Vollzeit-Rollenspieler"
L["L_STR_FR4"] = "Rollenspielneuling"
L["L_STR_FR5"] = "Erwachsener Rollenspieler"

L["L_STR_FC0"] = ""
L["L_STR_FC1"] = "Außerhalb des Rollenspiels (OOC)"
L["L_STR_FC2"] = "Im Rollenspiel (IC)"
L["L_STR_FC3"] = "Suche Kontakt (LFC)"
L["L_STR_FC4"] = "Erzähler (SL)"


L["L_OPTIONS_TITLE"] = "Addon zur Anzeige und Verwaltung von Rollenspiel-Charakterbeschreibungen mit Support von'Marry Sue Protocol'-basierten Flags.\n\n"

L["L_OPTIONS_PROFILE"] = "Charakterbeschreibung"
L["L_OPTIONS_PROFILE_NA"] = "Name"
L["L_OPTIONS_PROFILE_NT"] = "Titel"
L["L_OPTIONS_PROFILE_DE"] = "Physische Beschreibung"
L["L_OPTIONS_PROFILE_FR"] = "Rollenspielerfahrung"
L["L_OPTIONS_PROFILE_FC"] = "Rollenspielstatus"
L["L_OPTIONS_PROFILE_CU"] = "Aktuell"
L["L_OPTIONS_PROFILE_RA"] = "Rasse"
L["L_OPTIONS_PROFILE_AG"] = "Alter"
L["L_OPTIONS_PROFILE_AE"] = "Augenfarbe"
L["L_OPTIONS_PROFILE_AH"] = "Größe"
L["L_OPTIONS_PROFILE_AW"] = "Gewicht"
L["L_OPTIONS_META"] = "Metainformationen"
L["L_OPTIONS_META_MO"] = "Motto"
L["L_OPTIONS_META_HI"] = "Geschichte"
L["L_OPTIONS_META_HH"] = "Wohnort"
L["L_OPTIONS_META_HB"] = "Geburtsort"
L["L_OPTIONS_META_NH"] = "Dynastie"
L["L_OPTIONS_META_NI"] = "Spitzname"

L["L_OPTIONS_VIEW_FLAG"] = "Anzeige - Flag"
L["L_OPTIONS_VIEW_FLAG_SHOWONLYFLAGUSER"] = "Zeige Rollenspielflag nur für Ziele die ein Rollenspielflag benutzen."
L["L_OPTIONS_VIEW_FLAG_MOUSEOVER"] = "Zeige Rollenspielflag auch bei MouseOver."
L["L_OPTIONS_VIEW_FLAG_LOCKONTARGET"] = "Bevorzuge Target vor MouseOver bei der Anzeige."
L["L_OPTIONS_VIEW_FLAG_AUTOHIDE"] = "Verstecke Rollenspielflag automatisch."
L["L_OPTIONS_VIEW_FLAG_DISABLEINCOMBAT"] = "Während des Kampfes keine Flags anzeigen oder aktualisieren."
L["L_OPTIONS_VIEW_FLAG_DISABLEININSTANCE"] = "In Gruppen-, Raid-, Schlachtfeld- oder Arenainstanzen keine Flags anzeigen oder aktualisieren."
L["L_OPTIONS_VIEW_FLAG_GNOMCORDERINTEGRATION"] = "Integration in GnomTEC Gnomcorder (benötigt /reload oder Neustart)"
L["L_OPTIONS_VIEW_FLAG_COLOR"] = "Allgemeine Farbeinstellungen"
L["L_OPTIONS_VIEW_FLAG_COLOR_BACKGROUND"] = "Hintergrund"
L["L_OPTIONS_VIEW_FLAG_COLOR_BORDER"] = "Rand"
L["L_OPTIONS_VIEW_FLAG_COLOR_TEXT"] = "Texte"
L["L_OPTIONS_VIEW_FLAG_COLOR_TITLE"] = "Überschriften"
L["L_OPTIONS_VIEW_FLAG_COLOR_RESET"] = "Farben rücksetzen"
L["L_OPTIONS_VIEW_FLAG_LOCKED"] = "Fenster fixieren."

L["L_OPTIONS_VIEW_TOOLTIP"] = "Anzeige - Tooltip"
L["L_OPTIONS_VIEW_TOOLTIP_ENABLED"] = "Zeige Rollenspielflag auch im Tooltip an"

L["L_OPTIONS_VIEW_TOOLBAR"] = "Anzeige - Toolbar"
L["L_OPTIONS_VIEW_TOOLBAR_ENABLED"] = "Zeige Toolbar zum schnelleren Umschalten diverser Statusvariablen."
L["L_OPTIONS_VIEW_TOOLBAR_LOCKED"] = "Toolbar fixieren."

L["L_OPTIONS_VIEW_NAMEPLATES"] = "Anzeige - Namensplaketten"
L["L_OPTIONS_VIEW_NAMEPLATES_ENABLED"] = "Ersetzte Namensplaketten durch Namen aus den Rollenspielflags."
L["L_OPTIONS_VIEW_NAMEPLATES_SHOWONLYNAME"] = "Verstecke alle Teile der Namensplaketten außer dem Spielernamen."

L["L_OPTIONS_VIEW_CHATFRAME"] = "Anzeige - Chatframe"
L["L_OPTIONS_VIEW_CHATFRAME_ENABLED"] = "Ersetzte Spielernamen im Blizzard Chatfenster mit deren Namen aus den Flags."

L["L_OPTIONS_PROFILES_CONFIGURATION"] = "Profile - Konfiguration"

L["L_OPTIONS_PROFILES_SELECT"] = "Profile - Auswahl"

L["L_OPTIONS_EXPORT"] = "Export flag user list (last 7 days)"


L["L_NORPFLAG"] = "<kein Rollenspielflag vorhanden>"
L["L_HIDDENRPFLAG"] = "<Kein Rollenspielstatus angegeben>"
 
L["L_ENGINEDATA_UNKNOWN"] = "Stufe -- Unbekannt Unbekannt"
L["L_ENGINEDATA_LEVEL"] = "Stufe"
 
L["L_TAB_DESCR"] = "Beschr."
L["L_TAB_META"] = "Meta"
L["L_TAB_NOTE_A"] = "Notiz (A)"
L["L_TAB_NOTE_C"] = "Notiz (C)"
L["L_TAB_LOG"] = "Log"
	
L["L_FIELD_VA"] = "Addon Version"	
L["L_FIELD_NA"] = "Name"
L["L_FIELD_NT"] = "Titel"
L["L_FIELD_RA"] = "Rasse"
L["L_FIELD_CU"] = "Aktuell"
L["L_FIELD_DE"] = "Physische Beschreibung"
L["L_FIELD_FR"] = "Rollenspielerfahrung"
L["L_FIELD_FC"] = "Rollenspielstatus"
L["L_FIELD_AG"] = "Alter"
L["L_FIELD_AE"] = "Augenfarbe"
L["L_FIELD_AH"] = "Größe"
L["L_FIELD_AW"] = "Gewicht"
L["L_FIELD_MO"] = "Motto"
L["L_FIELD_HI"] = "Geschichte"
L["L_FIELD_HH"] = "Wohnort"
L["L_FIELD_HB"] = "Geburtsort"
L["L_FIELD_NH"] = "Dynastie"
L["L_FIELD_NI"] = "Spitzname"

