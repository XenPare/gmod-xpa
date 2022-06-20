local init, fr = false
local color_admin = Color(0, 161, 255)

local run_replacements = {
	["ban"] = function(target)
		XPA.BanForm(target)
	end
}

local function runCommand(target, key, cmd)
	if run_replacements[key] then
		run_replacements[key](target)
		return
	end

	if cmd.self then
		if cmd.string then
			Derma_StringRequest(
				cmd.name,
				"Enter the required info",
				"",
				function(str)
					RunConsoleCommand("xpa", key, str) 
				end
			)
		else
			RunConsoleCommand("xpa", key)
		end
	else
		if cmd.string then
			Derma_StringRequest(
				cmd.name,
				"Enter the required info",
				"",
				function(str) 
					if istable(target) then
						for _, pl in ipairs(target) do
							if not IsValid(pl) then
								LocalPlayer():ChatPrint("One or more player has disconnected")
								return
							end
							local id = pl:SteamID()
							if pl:IsBot() then
								id = pl:Name()
							end
							RunConsoleCommand("xpa", key, id, unpack(XPA.ParseArgs(str))) 
						end
					else
						if not IsValid(target) then
							LocalPlayer():ChatPrint("Player has disconnected")
							return
						end
						local id = target:SteamID()
						if target:IsBot() then
							id = target:Name()
						end
						RunConsoleCommand("xpa", key, id, unpack(XPA.ParseArgs(str))) 
					end
				end
			)
		else
			if istable(target) then
				for _, pl in ipairs(target) do
					if not IsValid(pl) then
						LocalPlayer():ChatPrint("One or more player has disconnected")
						return
					end
					local id = pl:SteamID()
					if pl:IsBot() then
						id = pl:Name()
					end
					RunConsoleCommand("xpa", key, id) 
				end
			else
				if not IsValid(target) then
					LocalPlayer():ChatPrint("Player has disconnected")
					return
				end
				local id = target:SteamID()
				if target:IsBot() then
					id = target:Name()
				end
				RunConsoleCommand("xpa", key, id)
			end
		end
	end
end

local function addPlayers(parent, list, key, cmd)
	local panel = vgui.Create("EditablePanel", parent)
	panel:Dock(FILL)

	local fill = vgui.Create("DPanel", panel)
	fill:Dock(FILL)
	fill:DockPadding(2, 2, 2, 2)

	local back = vgui.Create("DButton", panel)
	back:Dock(BOTTOM)
	back:DockMargin(0, 4, 0, 0)
	back:SetTall(32)
	back:SetText("Back")

	back.DoClick = function()
		panel:Remove()
		list:SetVisible(true)
	end

	local scroll = vgui.Create("DScrollPanel", fill)
	scroll:Dock(FILL)

	local selected, cfirst = {}, false
	for id, tm in pairs(team.GetAllTeams()) do
		local _list = vgui.Create("DCollapsibleCategory", scroll)
		_list:Dock(TOP)
		_list:SetLabel(tm.Name)
		_list.Players = 0

		if #team.GetPlayers(id) > 9 then
			_list:SetExpanded(false)
		end

		local layout = vgui.Create("DIconLayout", _list)
		layout:Dock(FILL)
		layout:SetSpaceY(1)
		layout:SetSpaceX(1)

		for _, pl in ipairs(player.GetAll()) do
			if pl:Team() ~= id then
				continue
			end

			_list.Players = _list.Players + 1

			local player = vgui.Create("DButton", layout)
			player:SetFont("Default")
			player:SetText(pl:Name())	
			player:SetTooltip(pl:Alive() and "Alive" or "Dead")
			player:SetSize(167, 24)

			if pl:IsAdmin() then
				player:SetColor(color_admin)
				player:SetTooltip(player:GetTooltip() .. " (" .. pl:GetUserGroupTitle() .. ")")
			end

			player.Think = function(self)
				if IsValid(pl) then
					return
				end
				if selected[self] then
					selected[self] = nil
				end
				_list.Players = _list.Players - 1
				if _list.Players <= 0 then
					_list:Remove()
				end
				self:Remove()
			end

			player.DoClick = function()
				runCommand(pl, key, cmd)
			end

			player.DoRightClick = function(self)
				self:SetEnabled(false)
				selected[self] = pl

				if cfirst then
					return
				end

				cfirst = true

				local run = vgui.Create("DButton", panel)
				run:Dock(BOTTOM)
				run:DockMargin(0, 4, 0, 0)
				run:SetTall(32)
				run:SetText("Run command")
				run:SetTooltip("LMB to run command\nRMB to reset selected players")
			
				run.Think = function(self)
					if table.Count(selected) > 0 then
						return
					end
					self:Remove()
					cfirst = false
				end

				run.DoClick = function()
					local cpls = {}
					for _, cpl in pairs(selected) do
						table.insert(cpls, cpl)
					end
					runCommand(cpls, key, cmd)
				end

				run.DoRightClick = function(self)
					for button, _ in pairs(selected) do
						selected[button] = nil
						button:SetEnabled(true)
					end
					cfirst = false
					self:Remove()
				end
			end
		end

		_list:SetContents(layout)
		if _list.Players == 0 then
			_list:Remove()
		end
	end
end

local function addCommands(categories, commands, parent)
	local panel = vgui.Create("DPanel", parent)
	panel:Dock(FILL)
	panel:DockPadding(2, 2, 2, 2)

	local scroll = vgui.Create("DScrollPanel", panel)
	scroll:Dock(FILL)

	table.sort(categories, function(a, b) 
		return #a > #b 
	end)

	for _, title in SortedPairs(categories) do
		local list = vgui.Create("DCollapsibleCategory", scroll)
		list:Dock(TOP)
		list:SetLabel(title)
		list:SetExpanded(false)
		list.Commands = 0	

		local layout = vgui.Create("DIconLayout", list)
		layout:Dock(FILL)
		layout:SetSpaceY(1)
		layout:SetSpaceX(1)

		for key, data in pairs(commands) do
			if data.category ~= title then
				continue
			end 

			list.Commands = list.Commands + 1

			local act = vgui.Create("DButton", layout)
			act:SetFont("Default")
			act:SetText(data.name)	
			if data.icon then
				act:SetIcon(data.icon)
			end
			if data.tooltip then
				act:SetTooltip("xpa " .. key .. "\n\n" .. data.tooltip)
			else
				act:SetTooltip("xpa " .. key)
			end
			act:SetSize(114, 24)

			act.DoClick = function()
				if data.self then
					runCommand(nil, key, data)
				else
					panel:SetVisible(false)
					addPlayers(parent, panel, key, data)
				end
			end

			if data.opened and not list:GetExpanded() then
				list:SetExpanded(true)
			end
		end

		list:SetContents(layout)
		if list.Commands == 0 then
			list:Remove()
		end
	end
end

net.Receive("XPA Menu", function()
	if IsValid(fr) then 
		fr:Close()
		return 
	end

	local categories = net.ReadTable()
	local commands = net.ReadTable()

	fr = vgui.Create("DFrame")
	fr:SetTitle("XenPare Administration Experience " .. XPA.Version)
	fr:SetPos(-1000, 25)
	fr:MoveTo(5, 25, 0.2)

	fr:MakePopup()
	fr:SetDraggable(false)
	fr:SetKeyboardInputEnabled(false)

	fr.Close = function()
		fr:MoveTo(-1000, 25, 0.2, 0, -1, function()
			fr:Remove()
		end)	
	end

	local wide, tall = 375, ScrH() / 1.8
	if not init then
		fr:SetSize(wide, 56)

		local progress = vgui.Create("DProgress", fr) -- fancy enough
		progress:Dock(TOP)
		progress:SetTall(22)
		progress:SetFraction(0)

		local start = SysTime()
		progress.Think = function(self)
			if self:GetFraction() == 1 then
				self:Remove()
				fr:SetSize(wide, tall)
				addCommands(categories, commands, fr)
				init = true
			end
			self:SetFraction(Lerp(SysTime() - start, 0, 1))
		end
	else
		fr:SetSize(wide, tall)
		addCommands(categories, commands, fr)
	end
end)