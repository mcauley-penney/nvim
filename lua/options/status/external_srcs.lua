local M = {}

local set_hl = require("options.status.hl").make_hl_def_bg

-- Return an associative table of strings for each type of diagnostic.
-- This function loops through all diagnostic groups found in "lsp.lua",
-- uses their base highlight groups and associated symbols to create strings
-- of diagnostic info to put in the statusline.
-- @return associative array; key = diagnostic type name, val = string for
-- that type that will be inserted into statusline
local function _get_diag_str_tbl(diag_signs, hl_mtbl)
    local count = nil
    local diag_tbl = {}

    -- for each user-chosen sign and its configurations
    for diag_type, cfg in pairs(diag_signs) do
        -- get count
        count = #vim.diagnostic.get(0, { severity = string.upper(diag_type) })

        --[[
            create str for each type.
            We must create an associative array so that the strings can be
            accessed by name later. The array where the diagnostic symbols
            are defined, in lsp.lua, is an associative array, meaning that
            it cannot guarantee ordered access. Therefore, we must order it
            ourselves
          ]]
        diag_tbl[diag_type] = table.concat(
            { hl_mtbl[diag_type], cfg.sym, "%*:", count, "  " },
            ""
        )
    end

    -- return associative table of diagnostic str; diag_type = diag_count_str
    return diag_tbl
end

-- Create strings of diagnostic information and concatenate them into one string
-- @param status_bg: background highlight of StatusLine
-- @return string of diagnostic info to place into statusline
M.get_diag_str = function(lsp_signs, hl_mtbl)
    if #vim.diagnostic.get(0) < 1 then
        local success_sym = "[]"
        return table.concat({ hl_mtbl.Success, success_sym, "%* " }, "")
    else
        local diag_str_tbl = _get_diag_str_tbl(lsp_signs, hl_mtbl)

        local ordered_diag_str_tbl = {
            diag_str_tbl["Error"],
            diag_str_tbl["Warn"],
            diag_str_tbl["Hint"],
            diag_str_tbl["Info"],
        }

        return table.concat(ordered_diag_str_tbl, "")
    end
end

--- retrieve and return filetype icon from nvim-web-devicons.
-- gets icon from nvim-web-devicons, applies the proper background highlight
-- to it, and returns it as a string.
-- @param ft: current filetype
-- @return str of icon with proper highlights or nil
M.get_ft_icon = function(buf, ft)
    local sym, color = require("nvim-web-devicons").get_icon_color(buf, ft)

    if sym ~= nil then
        local icon_hi = set_hl({
            grp = "StatusIcon",
            fg = color,
        })

        return table.concat({ " ", icon_hi, sym, "%*" }, "")
    end
end

M.get_wordcount_str = function()
    local wc = vim.api.nvim_eval("wordcount()")["words"]

    return table.concat({ "\\w:", wc, "  " }, "")
end

return M
