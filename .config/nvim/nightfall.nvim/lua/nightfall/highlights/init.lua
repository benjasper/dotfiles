local M = {}

M.plugins = {
	["treesitter"] = "treesitter",
}

---@param colors PaletteColors
---@param opts nightfall.Config
---@return nightfall.Highlights
function M.setup(colors, opts)
	local groups = {
		base = true,
		treesitter = true,
		lsp = true,
		kinds = true,
	}

	if opts.plugins.all then
		for _, group in pairs(M.plugins) do
			groups[group] = true
		end
	elseif opts.plugins.auto and package.loaded.lazy then
		local plugins = require("lazy.core.config").plugins
		for plugin, group in pairs(M.plugins) do
			if plugins[plugin] then
				groups[group] = true
			end
		end
	end

	-- manually enable/disable plugins
	for plugin, group in pairs(M.plugins) do
		local use = opts.plugins[group]
		use = use == nil and opts.plugins[plugin] or use
		if use ~= nil then
			if type(use) == "table" then
				use = use.enabled
			end
			groups[group] = use or nil
		end
	end

	local ret = {}

	for group, enabled in pairs(groups) do
		if enabled then
			for hl, val in pairs(require("nightfall.highlights." .. group).get(colors, opts)) do
				ret[hl] = val
			end
		end
	end

	return ret
end

return M