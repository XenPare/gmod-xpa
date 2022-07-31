return "Moving", "*", {
	--[[
		xpa teleport <steamid/name/userid>
	]]

	["teleport"] = {
		name = "Teleport",
		aliases = {"tp", "bring", "tele"},
		immunity = 1000,
		icon = "icon16/arrow_down.png",
		visible = true,
		func = function(pl, args)
			local target = XPA.FindPlayer(args[1])
			if not IsValid(target) or not IsValid(pl) then
				return
			end

			if target:GetImmunity() > pl:GetImmunity() then
				return
			end

			if not target:Alive() then
				pl:ChatPrint("Target is dead")
				return
			end

			target:ExitVehicle()

			local tracedata = {}
			tracedata.start = pl:GetShootPos()
			tracedata.endpos = tracedata.start + pl:GetAimVector() * 10000
			tracedata.filter = pl

			local trace = util.TraceLine(tracedata)
			local offset = Vector(0, 0, 1)
			if trace.HitNormal ~= Vector(0, 0, 1) then
				offset = trace.HitNormal * 16
			end

			target.ReturnPos = target:GetPos()
			local init = XPA.FindEmptyPos(trace.HitPos + offset, {pl}, 600, 20, Vector(16, 16, 64))
			target:SetPos(init)

			XPA.AChatLog(pl:Name() .. " has teleported " .. target:Name())
		end
	},

	--[[
		xpa goto <steamid/name/userid>
	]]

	["goto"] = {
		name = "GoTo",
		immunity = 1000,
		icon = "icon16/arrow_right.png",
		visible = true,
		func = function(pl, args)
			local target = XPA.FindPlayer(args[1])
			if not IsValid(target) or not IsValid(pl) then
				return
			end

			if not target:Alive() then
				pl:ChatPrint("Target is dead")
				return
			end

			pl:ExitVehicle()
			if not pl:Alive() then
				pl:Spawn()
			end

			pl.ReturnPos = pl:GetPos()
			pl:SetPos(XPA.FindEmptyPos(target:GetPos(), {pl}, 600, 30, Vector(16, 16, 64)))

			XPA.AChatLog(pl:Name() .. " has teleported to " .. target:Name())
		end
	},

	--[[
		xpa return <steamid/name/userid>
	]]

	["return"] = {
		name = "Return",
		immunity = 1000,
		icon = "icon16/arrow_redo.png",
		visible = true,
		func = function(pl, args)
			local target = XPA.FindPlayer(args[1])
			if not IsValid(target) or not IsValid(pl) then
				return
			end

			if target:GetImmunity() > pl:GetImmunity() then
				return
			end

			if not target:Alive() then
				pl:ChatPrint("Target is dead")
				return
			end

			if not target.ReturnPos then
				pl:ChatPrint("There is no return position for " .. target:Name())
				return
			end

			target:ExitVehicle()
			target:SetPos(target.ReturnPos)
			target.ReturnPos = nil
		end
	}
}, true