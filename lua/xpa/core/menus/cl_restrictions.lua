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

	local search = vgui.Create("DTextEntry", parent)
	search:Dock(TOP)
	search:SetText("")
	search:SetPlaceholderText(table.Count(tbl) .. " restrictions found")

	search:SetEnterAllowed(true)
	search:SetEditable(true)

	search.OnChange = function()
		local id = search:GetValue()
		list:Clear()

		if id == "" then
			for sid, v in pairs(tbl) do
				if isdrp then
					list:AddLine(tostring(sid), v.gag and tostring(v.gag) or "false", v.mute and tostring(v.mute) or "false", v.pban and tostring(v.pban) or "false")
				else
					list:AddLine(tostring(sid), v.gag and tostring(v.gag) or "false", v.mute and tostring(v.mute) or "false")
				end
			end
		else
			for sid, v in pairs(tbl) do
				if string.find(sid, id) then
					if isdrp then
						list:AddLine(tostring(sid), v.gag and tostring(v.gag) or "false", v.mute and tostring(v.mute) or "false", v.pban and tostring(v.pban) or "false")
					else
						list:AddLine(tostring(sid), v.gag and tostring(v.gag) or "false", v.mute and tostring(v.mute) or "false")
					end
				end
			end
		end
	end

	for sid, v in pairs(tbl) do
		if isdrp then
			list:AddLine(tostring(sid), v.gag and tostring(v.gag) or "false", v.mute and tostring(v.mute) or "false", v.pban and tostring(v.pban) or "false")
		else
			list:AddLine(tostring(sid), v.gag and tostring(v.gag) or "false", v.mute and tostring(v.mute) or "false")
		end
	end

	list.OnRowSelected = function(panel, rowIndex, row)
		SetClipboardText("http://steamcommunity.com/profiles/" .. util.SteamIDTo64(row:GetValue(1)))
	end
end

net.Receive("XPA Restrictions List", function()
	local restrictions = net.ReadTable()

	local fr = vgui.Create("DFrame")
	fr:SetTitle("XPA Restrictions List")
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
			addRestrictions(restrictions, fr)
		end
		self:SetFraction(Lerp(SysTime() - start, 0, 1))
	end
end)