local StringPattern = "[\"|']"
local ArgSepPattern	= "[ ]"
local EscapePattern	= "[\\]"

function XPA.ParseArgs(str)
	local ret = {}
	local instr = false
	local strchar = ""
	local chr = ""
	local escaped = false

	for i = 1, #str do
		local char = str[i]
		if escaped then
			chr = chr .. char
			escaped = false
			continue
		end

		if char:find(StringPattern) and not instr and not escaped then
			instr = true
			strchar = char
		elseif char:find(EscapePattern) then
			escaped = true
			continue
		elseif instr and char == strchar then
			table.insert(ret, chr:Trim())
			chr = ""
			instr = false
		elseif char:find(ArgSepPattern) and not instr then
			if chr ~= "" then
				table.insert(ret, chr)
				chr = ""
			end
		else
			chr = chr .. char
		end
	end

	if chr:Trim():len() ~= 0 then
		table.insert(ret, chr)
	end

	return ret
end