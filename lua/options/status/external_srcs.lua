local get_hi = require("utils").get_hi_grp_rgb
local hi = require("options.status.highlight")

local M = {}

-- Return an associative table of strings for each type of diagnostic.
-- This function loops through all diagnostic groups found in "lsp.lua",
-- uses their base highlight groups and associated symbols to create strings
-- of diagnostic info to put in the statusline.
-- @return associative array; key = diagnostic type name, val = string for
-- that type that will be inserted into statusline
local function _get_diag_str_tbl(diag_signs, bg_hl)
    local count = nil
    local cur_hi = nil
    local diag_grp = nil
    local diag_tbl = {}

    -- for each user-chosen sign and its configurations
    for diag_type, cfg in pairs(diag_signs) do
        -- get count
        count = #vim.diagnostic.get(0, { severity = string.upper(diag_type) })

        -- create diagnostic group name from diag type
        diag_grp = "Diagnostic" .. diag_type

        -- create highlight
        cur_hi = hi.make_hi_grp_str({
            grp = "Status" .. diag_grp,
            bg = bg_hl,
            fg = get_hi(diag_grp, "fg"),
        })

        --[[
                create str for each type.
                We must create an associative array so that the strings can be
                accessed by name later. The array where the diagnostic symbols
                are defined, in lsp.lua, is an associative array, meaning that
                it cannot guarantee ordered access. Therefore, we must order it
                ourselves
            ]]
        diag_tbl[diag_type] = table.concat({ cur_hi, cfg.sym, "%*:", count, "  " }, "")
    end

    -- return associative table of diagnostic str; diag_type = diag_count_str
    return diag_tbl
end

local function _get_diag_success_str(bg_hl)
    -- create hl grp for when there are no diagnostics
    local success_hi = hi.make_hi_grp_str({
        grp = "DiagnosticSuccess",
        bg = bg_hl,
        fg = "#347d39",
    })

    local sym = "[]"

    return table.concat({ success_hi, sym, "%* " }, "")
end

-- Create strings of diagnostic information and concatenate them into one string
-- @param status_bg: background highlight of StatusLine
-- @return string of diagnostic info to place into statusline
M.get_diag_str = function(lsp_signs, bg_hl)
    -- if lsp is not available, get word count
    if vim.lsp.get_client_by_id(1) ~= nil then
        -- if we have an lsp client but no diagnostics, return confirmation
        if #vim.diagnostic.get(0) < 1 then
            return _get_diag_success_str(bg_hl)
        else
            local diag_str_tbl = _get_diag_str_tbl(lsp_signs, bg_hl)

            local ordered_diag_str_tbl = {
                diag_str_tbl["Error"],
                diag_str_tbl["Warn"],
                diag_str_tbl["Hint"],
                diag_str_tbl["Info"],
            }

            return table.concat(ordered_diag_str_tbl, "")
        end
    end
end

--- retrieve and return filetype icon from nvim-web-devicons.
-- gets icon from nvim-web-devicons, applies the proper background highlight
-- to it, and returns it as a string.
-- @param status_bg: background highlight of StatusLine
-- @return str of icon with proper highlights or nil
M.get_ft_icon = function(ft, bg_hl)
    local buf = vim.api.nvim_buf_get_name(0)

    local sym, color = require("nvim-web-devicons").get_icon_color(buf, ft)

    if sym ~= nil then
        local icon_hi = hi.make_hi_grp_str({
            grp = "StatusIcon",
            bg = bg_hl,
            fg = color,
        })

        return table.concat({ " ", icon_hi, sym, "%*" }, "")
    end

    return nil
end

M.get_mod_str = function(mod_str, bg_hl)
    local mod_hi = hi.make_hi_grp_str({
        grp = "StatusMod",
        bg = bg_hl,
        fg = get_hi("Error", "fg"),
    })

    return table.concat({ mod_hi, mod_str, "%* " }, "")
end

M.get_wordcount_str = function(loc_str, ft)
    local wc = vim.api.nvim_eval("wordcount()")["words"]

    if ft == "text" then
        loc_str = table.concat({ "\\w:", wc, "  ", loc_str }, "")
    end

    return loc_str
end

return M
