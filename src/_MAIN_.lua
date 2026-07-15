--check if luacurl is installed
local fs = class:getAPI('filesystem', 0)
local ok, cURL = pcall(require, "cURL")
if not ok then
	print("luacurl needs to be installed to install it type\nluarocks install lua-curl")
end
local args = {...}
local lfpk = class:getAPI('lfpk', 0)
local function ins(a, b, d, isLocal)
	if isLocal then
		local pk = lfpk:parse(a)
		for name, info in pairs((pk.info.packageDependencies or {})) do
			ins(name, info.verion, info.branch)
		end
		lfpk:install(pk)
	else
		local c = cURL.easy_init()
		local url = "https://raw.githubusercontent.com/" .. a .. '/refs/heads/' .. (b or "main") .. "/lfpk/lfrt/" .. (d or "latest") .. ".lfpk"
		print(url)
		c:setopt_url(url)
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
			for name, info in pairs((pk.info.packageDependencies or {})) do
				ins(name, info.verion, info.branch)
			end
			lfpk:install(pk)
		else
			print("Error:", err)
		end
	end
end
if args[1] == 'installLocal' then
	ins(args[2], args[3], args[4], true)
elseif args[1] == 'install' then
	ins(args[2], args[3], args[4])
else
	print([[
usage:
	* install <GithubUsername/GithubRepo> [RepoBranch (defaults to main)] [version] 
	* installLocal <example.lfpk>
	]])
end
