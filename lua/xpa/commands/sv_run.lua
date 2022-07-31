local commands = XPA.Commands or {}
local selfargs = XPA.Config.SelfArgs
concommand.Add(
	"xpa",
	function(pl, cmd, args)
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
			argstring = "with args: " .. table.concat(nargs, ", ")
		end

		XPA.MsgC((IsValid(pl) and pl:Name() or "Server") .. ' has executed "' .. command.name  .. '" command ' .. argstring)
	end,
	function(cmd, arg)
		local tbl = {}

		local foundarg = tobool(arg:find("[%a]+"))
		if not foundarg then
			for command in pairs(commands) do
				table.insert(tbl, "xpa " .. command)
			end
		else
			local t = string.Explode(" ", arg)
			local w = t[2]

			local command = commands[w]
			if command then
				if command.autocompletion then
					tbl = command.autocompletion(arg)
				elseif not command.self then
					local hstring = command.string
					for _, pl in pairs(player.GetAll()) do
						table.insert(tbl, "xpa " .. w .. ' "' .. pl:Name() .. '" ' .. (hstring and '"100"' or ""))
					end
				end
			end
		end

		return tbl
	end
)

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
			argstring = "with args: " .. table.concat(args, ", ")
		end

		XPA.MsgC((IsValid(pl) and pl:Name() or "Server") .. ' has executed "' .. command.name  .. '" command ' .. argstring)
		return not pl:IsMuted() and text or ""
	end
end)