local function addPlayers(tbl, parent)
	local panel = vgui.Create("DPanel", parent)
	panel:Dock(FILL)

	local list = vgui.Create("DListView", panel)
	list:Dock(FILL)
	list:SetMultiSelect(false)

	list:AddColumn("SteamID")
	list:AddColumn("Name")
	list:AddColumn("Played")

	local search = vgui.Create("DTextEntry", panel)
	search:Dock(TOP)
	search:SetTall(26)
	search:SetText("")
	search:SetPlaceholderText(table.Count(tbl) .. " players found")

	search:SetEnterAllowed(true)
	search:SetEditable(true)

	search.OnChange = function()
		local id = search:GetValue()
		list:Clear()

		if id == "" then
			for sid, v in pairs(tbl) do
				list:AddLine(sid, v.name, XPA.ConvertTime(v.time))
			end
		else
			for sid, v in pairs(tbl) do
				local name = v.name
				if sid:found(id) or name:found(id) then
					list:AddLine(sid, name, XPA.ConvertTime(v.time))
				end
			end
		end
	end

	for sid, v in pairs(tbl) do
		list:AddLine(sid, v.name, XPA.ConvertTime(v.time))
	end

	list.OnRowSelected = function(_, _, row)
		SetClipboardText("http://steamcommunity.com/profiles/" .. util.SteamIDTo64(row:GetValue(1)))
	end

	return panel
end

local function addRestrictions(tbl, parent)
	local isdrp = false
	if engine.ActiveGamemode() == "darkrp" then
		isdrp = true
	end

	local panel = vgui.Create("DPanel", parent)
	panel:Dock(FILL)

	local list = vgui.Create("DListView", panel)
	list:Dock(FILL)
	list:SetMultiSelect(false)

	list:AddColumn("SteamID")
	list:AddColumn("Gag")
	list:AddColumn("Mute")
	if isdrp then
		list:AddColumn("Police Ban")
	end

	local search = vgui.Create("DTextEntry", panel)
	search:Dock(TOP)
	search:SetTall(26)
	search:SetText("")
	search:SetPlaceholderText(table.Count(tbl) .. " restricted players found")

	search:SetEnterAllowed(true)
	search:SetEditable(true)

	local function insert(id, tbl)
		local args = {
			id, 
			tbl.gag and "Yes" or "No", 
			tbl.mute and "Yes" or "No"
		}
		
		if isdrp then
			table.insert(args, tbl.pban and tbl.pban or "false")
		end

		list:AddLine(unpack(args))
	end

	search.OnChange = function()
		local id = search:GetValue()
		list:Clear()

		if id == "" then
			for sid, v in pairs(tbl) do
				insert(sid, v)
			end
		else
			for sid, v in pairs(tbl) do
				if string.find(sid, id) then
					insert(sid, v)
				end
			end
		end
	end

	for sid, v in pairs(tbl) do
		insert(sid, v)
	end

	list.OnRowSelected = function(_, _, row)
		SetClipboardText("http://steamcommunity.com/profiles/" .. util.SteamIDTo64(row:GetValue(1)))
	end

	return panel
end

local function addBans(tbl, parent)
	local panel = vgui.Create("DPanel", parent)
	panel:Dock(FILL)

	local list = vgui.Create("DListView", panel)
	list:Dock(FILL)
	list:SetMultiSelect(false)

	list:AddColumn("SteamID")
	list:AddColumn("Remaining")
	list:AddColumn("Reason")

	local search = vgui.Create("DTextEntry", panel)
	search:Dock(TOP)
	search:SetTall(26)
	search:SetText("")
	search:SetPlaceholderText(table.Count(tbl) .. " bans found")

	search:SetEnterAllowed(true)
	search:SetEditable(true)

	search.OnChange = function()
		local id = search:GetValue()
		list:Clear()

		if id == "" then
			for sid, v in pairs(tbl) do
				local time = tonumber(v.time)
				list:AddLine(sid, time > 0 and XPA.ConvertTime(((time - os.time()) * 60) / 60) or "∞", v.reason)
			end
		else
			for sid, v in pairs(tbl) do
				local time, reason = tonumber(v.time), v.reason
				if string.find(sid, id) or string.find(reason, id) then
					list:AddLine(sid, time > 0 and XPA.ConvertTime(((time - os.time()) * 60) / 60) or "∞", reason)
				end
			end
		end
	end

	for sid, v in pairs(tbl) do
		local time = tonumber(v.time)
		list:AddLine(sid, time > 0 and XPA.ConvertTime(((time - os.time()) * 60) / 60) or "∞", v.reason)
	end

	list.OnRowSelected = function(_, _, row)
		SetClipboardText("http://steamcommunity.com/profiles/" .. util.SteamIDTo64(row:GetValue(1)))
	end

	return panel
end

net.Receive("XPA Finder", function()
	local players = net.ReadTable()
	local restricted = net.ReadTable()
	local banned = net.ReadTable()

	local fr = vgui.Create("DFrame")
	fr:SetTitle("XPA Finder")
	fr:SetSize(ScrW() / 3, ScrH() / 1.2)
	fr:Center()
	fr:MakePopup()

	local sheet = vgui.Create("DPropertySheet", fr)
	sheet:Dock(FILL)

	local progress = vgui.Create("DProgress", fr)
	progress:Dock(TOP)
	progress:SetTall(22)
	progress:SetFraction(0)

	local start = SysTime()
	progress.Think = function(self)
		if self:GetFraction() == 1 then
			self:Remove()

			local playtime = addPlayers(players, sheet)
			sheet:AddSheet("Players", playtime, "icon16/zoom.png")

			local restrictions = addRestrictions(restricted, sheet)
			sheet:AddSheet("Restrictions", restrictions, "icon16/delete.png")

			local bans = addBans(banned, sheet)
			sheet:AddSheet("Bans", bans, "icon16/lock.png")
		end
		self:SetFraction(Lerp(SysTime() - start, 0, 1))
	end
end)