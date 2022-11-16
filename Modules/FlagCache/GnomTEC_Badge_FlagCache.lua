-- **********************************************************************
-- GnomTEC Badge Flag Cache
-- Version: 10.0.2.69
-- Author: GnomTEC
-- Copyright 2016-2022 by GnomTEC
-- http://www.gnomtec.de/
-- **********************************************************************

-- ----------------------------------------------------------------------
-- global flag cache for other players flag data
-- ----------------------------------------------------------------------

GnomTEC_Badge_FlagCache = {
	[string.gsub(GetRealmName(), "%s+", "")] = {
		[UnitName("player")] = {};
	},
}

-- ----------------------------------------------------------------------
-- no more code here as all work is done in GnomTEC Badge
-- ----------------------------------------------------------------------









