local utils = require("maps.bindings.utils")

local colemak_maps = {
    { "n", "j" },
    { "e", "k" },
    { "s", "h" },
    { "t", "l" },
}

for _, pairs in ipairs(colemak_maps) do
    local left = pairs[1]
    local right = pairs[2]

    local upper_l = string.upper(left)
    local upper_r = string.upper(right)

    -- map for lowercase
    utils.map("", left, right, utils.nore)

    -- map for uppercase
    utils.map("", upper_l, upper_r, utils.nore)

    -- map for reverse lowercase
    utils.map("", right, left, utils.nore)

    -- map for reverse uppercase
    utils.map("", upper_r, upper_l, utils.nore)
end
