local def_time = "1440"

function XPA.BanForm(pl)
	if istable(pl) then
		for _, _pl in pairs(pl) do
			XPA.BanForm(_pl)
		end
		return
	end
	
	local name = pl:Name()

	local fr = vgui.Create("DFrame")
	fr:SetTitle("Ban " .. name)
	fr:SetSize(300, 128)
	fr:Center()
	fr:MakePopup()
	fr:SetPaintBackgroundEnabled(true)

	local time = vgui.Create("DTextEntry", fr)
	time:Dock(TOP)
	time:DockMargin(0, 1, 0, 1)
	time:SetTall(28)
	time:SetText(def_time)

	time.Think = function(self, w, h) 
		if self:IsEditing() and self:GetValue() == def_time then
			self:SetText("")
		end
		if not self:IsEditing() and self:GetValue() == "" then
			self:SetText(def_time)
		end
	end

	local reason = vgui.Create("DTextEntry", fr)
	reason:Dock(TOP)
	reason:DockMargin(0, 1, 0, 1)
	reason:SetTall(28)
	reason:SetText("Enter the reason")

	reason.Think = function(self) 
		if self:IsEditing() and self:GetValue() == "Enter the reason" then
			self:SetText("")
		end
		if not self:IsEditing() and self:GetValue() == "" then
			self:SetText("Enter the reason")
		end
	end

	local ban = vgui.Create("DButton", fr)
	ban:SetText("Ban " .. name)
	ban:Dock(BOTTOM)

	ban.Think = function(self)
		if tonumber(time:GetValue()) then
			if not self:IsEnabled() then
				self:SetEnabled(true)
			end
			self:SetText("Ban " .. name .. " for " .. XPA.ConvertTime(time:GetValue() * 60))
		else
			if self:IsEnabled() then
				self:SetEnabled(false)
			end
			self:SetText("Ban " .. name .. " for " .. "???")
		end

		if reason:GetValue() == "" or reason:GetValue() == "Enter the reason" then
			if self:IsEnabled() then
				self:SetEnabled(false)
			end
		else
			if not self:IsEnabled() then
				self:SetEnabled(true)
			end
		end
	end

	ban.DoClick = function()
		fr:Remove()
		RunConsoleCommand("xpa", "ban", pl:SteamID(), time:GetValue(), reason:GetValue())
	end
end