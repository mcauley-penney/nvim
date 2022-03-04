local M = {}
local utils = require("utils")
local stl_bg = utils.get_hl_grp_rgb("StatusLine", "bg")

M.make_hl_def_bg = function(hi_tbl)
    hi_tbl["bg"] = stl_bg

    return utils.make_hl_grp_str(hi_tbl)
end

return M
