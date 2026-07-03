--check if luacurl is installed
local ok, cURL = pcall(require, "cURL")
if not ok then
	print("luacurl needs to be installed to install it type\nluarocks install lua-curl")
end
local c = cURL.easy_init()

c:setopt_url("https://luafoxyt.github.io/lfpk-lfrt/repos.txt")
local dat = ""
c:setopt_writefunction(function(_, data)
dat = dat .. data
end, "write") -- Writes chunks directly to file disk
local success, err = pcall(function() c:perform() end)
c:close()
if success then print("Repos Download Complete!") else print("Error:", err) end
local repos = table.parse(dat)
local args = {...}
if args[1] == 'install' then
	for i, v in ipairs(repos) do
		local url = v:gsub('@ONE@', args[2])
		local c = cURL.easy_init()

c:setopt_url("https://luafoxyt.github.io/lfpk-lfrt/repos.txt")
local dat = ""
c:setopt_writefunction(function(_, data)
dat = dat .. data
end, "write") -- Writes chunks directly to file disk
local success, err = pcall(function() c:perform() end)
c:close()
if success then print("Installer Script Download Complete!") else print("Error:", err) end
load(dat, '=dls', 't', _ENV)()
end
end