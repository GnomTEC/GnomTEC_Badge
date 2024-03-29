-- **********************************************************************
-- GnomTEC Badge - PratSupport
-- Version: 10.0.0.69
-- Author: GnomTEC
-- Copyright 2011-2022 by GnomTEC
-- http://www.gnomtec.de/
-- **********************************************************************

if not Prat then return end
if _G.TRP3_API then return end


Prat:AddModuleToLoad(function()

  local PRAT_MODULE = Prat:RequestModuleName("GnomTEC_Badge")

  if PRAT_MODULE == nil then
    return
  end

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

  local L = LibStub("AceLocale-3.0"):GetLocale("GnomTEC_Badge")

  local module = Prat:NewModule(PRAT_MODULE)

  Prat:SetModuleDefaults(module.name, {
    profile = {
      on = true,
    }
  })

  local serverPlugins = { servers = {} }

  Prat:SetModuleOptions(module.name, {
    name = "GnomTEC_Badge",
    desc = "GnomTEC_Badge integration into Prat 3.0",
    type = "group",
    args = {
    }
  })

  --[[------------------------------------------------
      Module Event Functions
  ------------------------------------------------]] --
  function module:OnModuleEnable()
    Prat.RegisterChatEvent(self, "Prat_PreAddMessage")
  end

  function module:OnModuleDisable()
    Prat.UnregisterAllChatEvents(self)
  end

  --[[------------------------------------------------
      Core Functions
  ------------------------------------------------]] --

  -- replace text using prat event implementation
  function module:Prat_PreAddMessage(e, m, frame, event)
  
	if (GnomTEC_Badge.db.profile["ViewChatFrame"]["Enabled"] ) then
   	local player = cleanpipe(m.PLAYER)
	   local realm = string.gsub(emptynil(cleanpipe(m.SERVER)) or GetRealmName(), "%s+", "")
		if GnomTEC_Badge_FlagCache[realm] then 
			if GnomTEC_Badge_FlagCache[realm][player] then
				m.PLAYER = string.gsub(m.PLAYER,player,GnomTEC_Badge_FlagCache[realm][player].NA or player)
			end
		end
	end
  end

  return
end) -- Prat:AddModuleToLoad
