XPA.Config = {}

XPA.Config.SkidsEnabled = true -- https://github.com/cresterienvogel/Skids

XPA.Config.AdminGroupLogin = false
XPA.Config.AdminGroupID = "35419163"

XPA.Config.BansUpdate = 3600
XPA.Config.PlaytimeUpdate = 300

XPA.Config.Database = "sqlite" -- firebase/sqlite/mysqloo

-- MySQLOO
-- leave everything blank if you don't plan to use mysqloo
XPA.Config.MySQLOOHost = ""
XPA.Config.MySQLOOUser = ""
XPA.Config.MySQLOOPassword = ""
XPA.Config.MySQLOOName = ""

-- Firebase
-- leave everything blank if you don't plan to use firebase
-- initialize base tables with given functions from xpa/db/firebase.lua
XPA.Config.FirebaseLink = "https://my-db.firebaseio.com/"
XPA.Config.FirebaseKey = ""

XPA.Config.Prefix = "[!|/|%.]"

XPA.Config.SelfArgs = {
	["me"] = true,
	["self"] = true,
	["^"] = true
}

-- rank - immunity
-- you can add a fancy title at xpa/core/usergroups/sh_init.lua
XPA.Config.Ranks = {
	["founder"] = 100000,
	["supervisor"] = 10000,
	["superadmin"] = 5000,
	["admin"] = 1000
}