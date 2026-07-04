--check if luacurl is installed
local ok, cURL = pcall(require, "cURL")
if not ok then
	print("luacurl needs to be installed to install it type\nluarocks install lua-curl")
end
local c = cURL.easy_init()
local args = {...}
local lfpk = class:getAPI('lfpk', 0)
local function ins(a, b, c)
c:setopt_url("https:/raw.githubusercontent.com/" .. a .. '/refs/heads/' .. (b or "master") .. "/lfpk/lfrt/" .. (c or "latest") .. ".lfar")
local fn = "./.tmp" .. math.random(99999) .. ".lfpk"
	local f = fs.open(fn, 'wb')
c:setopt_writefunction(function(_, data)
f:write(data)
end, "write") -- Writes chunks directly to file disk
local success, err = pcall(function() c:perform() end)
c:close()
f:flush()
f:close()
if success then
	print("file downloaded now installing")
	local pk = lfpk:parse(fn)
	for name, info in pk.info.Deps do
			ins(name, info.verion, info.branch)
	end
	lfpk:install(pk)
else
	print("Error:", err)
end
end
ins(args[2], args[3], args[4])