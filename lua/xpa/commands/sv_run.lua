local commands = XPA.Commands or {}
concommand.Add("xpa", function(pl, cmd, args)
	local command = commands[args[1]]
	if not command then
		return
	end

	if command.immunity then
		if IsValid(pl) then
			if pl:GetImmunity() < command.immunity then
				pl:ChatPrint("No access")
				return
			end
		end
	end

	local nargs = table.Copy(args)
	table.remove(nargs, 1)

	for k, arg in pairs(nargs) do
		if arg == "me" or arg == "^" then
			nargs[k] = pl:Name()
		end
	end
	command.func(IsValid(pl) and pl or nil, nargs)
	if #nargs == 0 then
		XPA.MsgC((IsValid(pl) and pl:Name() or "Server") .. ' has executed "' .. command.name  .. '" command with no args')
	else
		XPA.MsgC((IsValid(pl) and pl:Name() or "Server") .. ' has executed "' .. command.name  .. '" command with args: ' .. table.ToString(nargs))
	end
end)

local prefix = "[!|/|%.]"
hook.Add("PlayerSay", "XPA Chat Commands", function(pl, text, team)
	local cmd = string.match(text, prefix .. "(.-) ") or string.match(text, prefix .. "(.+)") or ""
	local line = string.match(text, prefix .. ".- (.+)")
	cmd = string.lower(cmd)

	local command = commands[cmd]
	if command and IsValid(pl) then
		if command.immunity then
			if pl:GetImmunity() < command.immunity then
				pl:ChatPrint("No access")
				if not pl:IsMuted() then
					return text
				else
					return ""
				end
			end
		end

		local args = line and XPA.ParseArgs(line) or {}
		if #args > 0 then
			for k, arg in pairs(args) do
				if arg == "me" or arg == "^" then
					args[k] = pl:Name()
				end
			end
		end

		command.func(IsValid(pl) and pl or nil, args)

		if #args == 0 then
			XPA.MsgC((IsValid(pl) and pl:Name() or "Server") .. ' has executed "' .. command.name  .. '" command with no args')
		else
			XPA.MsgC((IsValid(pl) and pl:Name() or "Server") .. ' has executed "' .. command.name  .. '" command with args: ' .. table.ToString(args))
		end
		return text
	end
end)