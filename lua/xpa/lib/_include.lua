local function includeShared(folder)
	for _, file in pairs(file.Find(folder .. "/sh_*.lua", "LUA")) do
		AddCSLuaFile(folder .. "/" .. file)
		if SERVER then
			include(folder .. "/" .. file)
		else
			include(folder .. "/" .. file)
		end
	end
end

local function includeClient(folder)
	for _, file in pairs(file.Find(folder .. "/cl_*.lua", "LUA")) do
		AddCSLuaFile(folder .. "/" .. file)
		if CLIENT then
			include(folder .. "/" .. file)
		end
	end
end

local function includeServer(folder)
	for _, file in pairs(file.Find(folder .. "/sv_*.lua", "LUA")) do
		if SERVER then
			include(folder .. "/" .. file)
		end
	end
end

function XPA.IncludeCompounded(folder)
	if string.EndsWith(folder, "/*") then
		local cfolder = string.Explode("/*", folder)[1]
		includeShared(cfolder)
		includeClient(cfolder)
		includeServer(cfolder)
		local _, dirs = file.Find(cfolder .. "/*", "LUA")
		for __, dir in pairs(dirs) do
			includeShared(cfolder .. "/" .. dir)
			includeClient(cfolder .. "/" .. dir)
			includeServer(cfolder .. "/" .. dir)
		end
	else
		includeShared(folder)
		includeClient(folder)
		includeServer(folder)
	end
end