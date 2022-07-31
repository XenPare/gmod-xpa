local skids = {}
timer.Simple(0, function()
	http.Fetch("https://raw.github.com/cresterienvogel/Skids/master/skids.json",
		function(content)
			skids = util.JSONToTable(content)
		end
	)
end)

if XPA.Config.SkidsEnabled then
	hook.Add("CheckPassword", "XPA Skids", function(steamid)
		if table.HasValue(skids, util.SteamIDFrom64(steamid)) then
			return false, "Prohibited skid connection"
		end
	end)
end