--[[
    mappings
        defaults: https://hea-www.harvard.edu/~fine/Tech/vi.html
]]

local files = { "colemak", "base", "lsp", "plugins" }

for _, file in ipairs(files) do
    require("mappings.bindings." .. file)
end
