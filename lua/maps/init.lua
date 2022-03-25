--[[
    mappings
        defaults: https://hea-www.harvard.edu/~fine/Tech/vi.html
]]

local files = { "colemak", "base", "lsp", "plugins" }

for _, file in pairs(files) do
    require(table.concat({ "maps.bindings.", file }, ""))
end
