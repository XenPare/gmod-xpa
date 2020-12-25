local function addPlayers(tbl, parent)
	local list = vgui.Create("DListView", parent)
	list:Dock(FILL)
	list:SetMultiSelect(false)

	list:AddColumn("SteamID")
	list:AddColumn("Name")
	list:AddColumn("Played")

	local search_panel = vgui.Create("EditablePanel", parent)
	search_panel:Dock(TOP)
	search_panel:SetTall(26)

	local search = vgui.Create("DTextEntry", search_panel)
	search:Dock(FILL)
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
				if sid:find(id) or name:lower():find(id:lower()) then
					list:AddLine(sid, name, XPA.ConvertTime(v.time))
				end
			end
		end
	end

	for sid, v in pairs(tbl) do
		list:AddLine(sid, v.name, XPA.ConvertTime(v.time))
	end

	list.OnRowSelected = function(_, _, row)
		SetClipboardText(row:GetValue(1))
	end
end

local function addRestrictions(tbl, parent)
	local isdrp = false
	if engine.ActiveGamemode() == "darkrp" then
		isdrp = true
	end

	local list = vgui.Create("DListView", parent)
	list:Dock(FILL)
	list:SetMultiSelect(false)

	list:AddColumn("SteamID")
	list:AddColumn("Gag")
	list:AddColumn("Mute")
	if isdrp then
		list:AddColumn("Police Ban")
	end

	local search_panel = vgui.Create("EditablePanel", parent)
	search_panel:Dock(TOP)
	search_panel:SetTall(26)

	local search = vgui.Create("DTextEntry", search_panel)
	search:Dock(FILL)
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
				if sid:find(id) then
					insert(sid, v)
				end
			end
		end
	end

	for sid, v in pairs(tbl) do
		insert(sid, v)
	end

	list.OnRowSelected = function(_, _, row)
		SetClipboardText(row:GetValue(1))
	end
end

local function addBans(tbl, parent)
	local list = vgui.Create("DListView", parent)
	list:Dock(FILL)
	list:SetMultiSelect(false)

	list:AddColumn("SteamID")
	list:AddColumn("Remaining")
	list:AddColumn("Reason")

	local search_panel = vgui.Create("EditablePanel", parent)
	search_panel:Dock(TOP)
	search_panel:SetTall(26)

	local search = vgui.Create("DTextEntry", search_panel)
	search:Dock(FILL)
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
				list:AddLine(sid, time > 0 and (XPA.ConvertTime(((time - os.time()) * 60) / 60) ~= "" and XPA.ConvertTime(((time - os.time()) * 60) / 60) or "Expired") or "∞", v.reason)
			end
		else
			for sid, v in pairs(tbl) do
				local time, reason = tonumber(v.time), v.reason
				if sid:find(id) or reason:lower():find(id:lower()) then
					list:AddLine(sid, time > 0 and (XPA.ConvertTime(((time - os.time()) * 60) / 60) ~= "" and XPA.ConvertTime(((time - os.time()) * 60) / 60) or "Expired") or "∞", reason)
				end
			end
		end
	end

	for sid, v in pairs(tbl) do
		local time = tonumber(v.time)
		list:AddLine(sid, time > 0 and (XPA.ConvertTime(((time - os.time()) * 60) / 60) ~= "" and XPA.ConvertTime(((time - os.time()) * 60) / 60) or "Expired") or "∞", v.reason)
	end

	list.OnRowSelected = function(_, _, row)
		SetClipboardText(row:GetValue(1))
	end
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

			local playtime = vgui.Create("DPanel", sheet)
			addPlayers(players, playtime)
			sheet:AddSheet("Players", playtime, "icon16/zoom.png")

			local restrictions = vgui.Create("DPanel", sheet)
			addRestrictions(restricted, restrictions)
			sheet:AddSheet("Restrictions", restrictions, "icon16/delete.png")

			local bans = vgui.Create("DPanel", sheet)
			addBans(banned, bans)
			sheet:AddSheet("Bans", bans, "icon16/lock.png")
		end
		self:SetFraction(Lerp(SysTime() - start, 0, 1))
	end
end)