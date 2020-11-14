local ent = FindMetaTable("Entity")

function ent:SetSimpleTimer(delay, func)
	timer.Simple(delay, function()
		if IsValid(self) then
			func()
		end
	end)
end

function ent:SetTimer(identifier, delay, repetitions, func)
	timer.Create(identifier, delay, repetitions, function()
		if IsValid(self) then
			func()
		end
	end)
end

function ent:RemoveTimer(identifier)
	timer.Remove(identifier)
end