return "Menus", "*", {
	--[[
		xpa info
	]]

	["info"] = {
		name = "Info",
		icon = "icon16/help.png",
		visible = true,
		self = true,
		func = function(pl)
			XPA.SendMsg(pl, "XenPare Administration Experience " .. XPA.Version .. ", build from " .. XPA.Build .. " by " .. XPA.Author)
		end
	},

	--[[
		xpa finder
	]]

	["finder"] = {
		name = "Finder",
		icon = "icon16/magnifier.png",
		visible = true,
		self = true,
		func = function(pl)
			net.Start("XPA Finder")
				net.WriteTable(XPA.Playtime)
				net.WriteTable(XPA.Restrictions)
				net.WriteTable(XPA.Bans)
			net.Send(pl)
		end
	},

	--[[
		xpa menu
	]]

	["menu"] = {
		name = "Menu",
		icon = "icon16/help.png",
		self = true,
		func = function(pl)
			local init = table.Copy(XPA.Commands)
			for cmd, data in pairs(init) do
				if data.immunity then
					if data.immunity > pl:GetImmunity() then
						init[cmd] = nil
						continue
					end
				end
				if not data.visible then
					init[cmd] = nil
					continue
				end
				if data.check then
					data.check = nil
				end
				if data.init then
					data.init = nil
				end
				data.func = nil
			end
			net.Start("XPA Menu")
				net.WriteTable(XPA.GetCommandCategories())
				net.WriteTable(init)
			net.Send(pl)
		end
	}
}, false
