function XPA.BanForm(pl)
	local name = pl:Name()

	local Frame = vgui.Create("DFrame")
	Frame:SetTitle("Ban " .. name)
	Frame:SetSize(300, 128)
	Frame:Center()
	Frame:MakePopup()
	Frame:SetPaintBackgroundEnabled(true)

	local Time = vgui.Create("DTextEntry", Frame)
	Time:Dock(TOP)
	Time:DockMargin(0, 1, 0, 1)
	Time:SetTall(28)
	Time:SetText("1440")

	Time.Think = function(self, w, h) 
		if self:IsEditing() and self:GetValue() == "1440" then
			self:SetText("")
		end
		if not self:IsEditing() and self:GetValue() == "" then
			self:SetText("1440")
		end
	end

	local Reason = vgui.Create("DTextEntry", Frame)
	Reason:Dock(TOP)
	Reason:DockMargin(0, 1, 0, 1)
	Reason:SetTall(28)
	Reason:SetText("Enter the reason")

	Reason.Think = function(self) 
		if self:IsEditing() and self:GetValue() == "Enter the reason" then
			self:SetText("")
		end
		if not self:IsEditing() and self:GetValue() == "" then
			self:SetText("Enter the reason")
		end
	end

	local Go = vgui.Create("DButton", Frame)
	Go:SetText("Ban " .. name)
	Go:Dock(BOTTOM)

	Go.Think = function(self)
		if tonumber(Time:GetValue()) then
			if not self:IsEnabled() then
				self:SetEnabled(true)
			end
			self:SetText("Ban " .. name .. " for " .. XPA.ConvertTime(Time:GetValue() * 60))
		else
			if self:IsEnabled() then
				self:SetEnabled(false)
			end
			self:SetText("Ban " .. name .. " for " .. "???")
		end

		if Reason:GetValue() == "" or Reason:GetValue() == "Enter the reason" then
			if self:IsEnabled() then
				self:SetEnabled(false)
			end
		else
			if not self:IsEnabled() then
				self:SetEnabled(true)
			end
		end
	end

	Go.DoClick = function()
		Frame:Remove()
		RunConsoleCommand("xpa", "ban", pl:SteamID(), Time:GetValue(), Reason:GetValue())
	end
end