local function addBans(tbl, parent)
	local list = vgui.Create("DListView", parent)
	list:Dock(FILL)
	list:SetMultiSelect(false)

	list:AddColumn("SteamID")
	list:AddColumn("Remaining")
	list:AddColumn("Reason")

	local search = vgui.Create("DTextEntry", parent)
	search:Dock(TOP)
	search:SetText("")
	search:SetPlaceholderText(table.Count(tbl) .. " bans found")

	search:SetEnterAllowed(true)
	search:SetEditable(true)

	search.OnChange = function()
		local id = search:GetValue()
		list:Clear()

		if id == "" then
			for sid, v in pairs(tbl) do
				list:AddLine(tostring(sid), tonumber(v.time) > 0 and XPA.ConvertTime(((tonumber(v.time) - os.time()) * 60) / 60) or "∞", tostring(v.reason))
			end
		else
			for sid, v in pairs(tbl) do
				if string.find(sid, id) or string.find(v.reason, id) then
					list:AddLine(tostring(sid), tonumber(v.time) > 0 and XPA.ConvertTime(((tonumber(v.time) - os.time()) * 60) / 60) or "∞", tostring(v.reason))
				end
			end
		end
	end

	for sid, v in pairs(tbl) do
		list:AddLine(tostring(sid), tonumber(v.time) > 0 and XPA.ConvertTime(((tonumber(v.time) - os.time()) * 60) / 60) or "∞", tostring(v.reason))
	end

	list.OnRowSelected = function(panel, rowIndex, row)
		SetClipboardText("http://steamcommunity.com/profiles/" .. util.SteamIDTo64(row:GetValue(1)))
	end
end

net.Receive("XPA Ban List", function()
	local banned = net.ReadTable()

	local fr = vgui.Create("DFrame")
	fr:SetTitle("XPA Ban List")
	fr:SetSize(ScrW() / 3, ScrH() / 1.2)
	fr:Center()
	fr:MakePopup()

	local progress = vgui.Create("DProgress", fr)
	progress:Dock(TOP)
	progress:SetTall(22)
	progress:SetFraction(0)

	local start = SysTime()
	progress.Think = function(self)
		if self:GetFraction() == 1 then
			self:Remove()
			addBans(banned, fr)
		end
		self:SetFraction(Lerp(SysTime() - start, 0, 1))
	end
end)