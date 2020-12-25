local commands = XPA.Commands or {}
local selfargs = XPA.Config.SelfArgs
concommand.Add("xpa", function(pl, cmd, args)
	local command = commands[args[1]]
	if not command then
		return
	end

	if command.immunity then
		if IsValid(pl) and pl:GetImmunity() < command.immunity then
			pl:ChatPrint("No access")
			return
		end
	end

	local nargs = table.Copy(args)
	table.remove(nargs, 1)

	for k, arg in pairs(nargs) do
		if selfargs[arg] then
			nargs[k] = pl:Name()
		end
	end

	command.func(IsValid(pl) and pl or nil, nargs)

	local argstring = "with no args"
	if #nargs > 0 then
		argstring = "with args: " .. table.ToString(nargs)
	end

	XPA.MsgC((IsValid(pl) and pl:Name() or "Server") .. ' has executed "' .. command.name  .. '" command ' .. argstring)
end)

local prefix = XPA.Config.Prefix
hook.Add("PlayerSay", "XPA Chat Commands", function(pl, text, team)
	local cmd = string.match(text, prefix .. "(.-) ") or string.match(text, prefix .. "(.+)") or ""
	local line = string.match(text, prefix .. ".- (.+)")
	cmd = string.lower(cmd)

	local command = commands[cmd]
	if command and IsValid(pl) then
		if command.immunity and pl:GetImmunity() < command.immunity then
			pl:ChatPrint("No access")
			return not pl:IsMuted() and text or ""
		end

		local args = line and XPA.ParseArgs(line) or {}
		if #args > 0 then
			for k, arg in pairs(args) do
				if selfargs[arg] then
					args[k] = pl:Name()
				end
			end
		end

		command.func(IsValid(pl) and pl or nil, args)

		local argstring = "with no args"
		if #args > 0 then
			argstring = "with args: " .. table.ToString(args)
		end

		XPA.MsgC((IsValid(pl) and pl:Name() or "Server") .. ' has executed "' .. command.name  .. '" command ' .. argstring)
		return not pl:IsMuted() and text or ""
	end
end)