local utils = require("maps.bindings.utils")

local colemak_maps = {
    { "n", "j" }, -- down
    { "e", "k" }, -- up
    { "s", "h" }, -- left
    { "t", "l" }, -- right
}

for _, pairs in ipairs(colemak_maps) do
    local lhs = pairs[1]
    local rhs = pairs[2]

    local upper_lhs = string.upper(lhs)
    local upper_rhs = string.upper(rhs)

    -- map for lowercase
    utils.map("", lhs, rhs, utils.nore)

    -- map for uppercase
    utils.map("", upper_lhs, upper_rhs, utils.nore)

    -- map for reverse lowercase
    utils.map("", rhs, lhs, utils.nore)

    -- map for reverse uppercase
    utils.map("", upper_rhs, upper_lhs, utils.nore)
end
