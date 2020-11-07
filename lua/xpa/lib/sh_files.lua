function XPA.AddDir(dir) -- ##materials/stuff/stuff2
	local files, dirs = file.Find(dir .. "/*", "GAME")
	for _, fdir in pairs(dirs) do
		if fdir ~= ".svn" then
			XPA.AddDir(dir .. "/" .. fdir)
		end
	end
	for _, f in pairs(files) do
		resource.AddFile(dir .. "/" .. f)
	end
end