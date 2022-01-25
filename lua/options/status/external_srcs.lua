local hi = require("options.status.highlight")

local M = {}

-- Create strings of diagnostic information and concatenate them into one string
-- @return string of diagnostic info to place into statusline
M.get_diagnostics = function(status_bg)
    -- Return an associative table of strings for each type of diagnostic.
    -- This function loops through all diagnostic groups found in "lsp.lua", uses their
    -- base highlight groups and associated symbols to create strings of diagnostic info
    -- to put in the statusline.
    -- @return associative array; key = diagnostic type name, val = string for that type
    -- that will be inserted into statusline
    local function _get_diag_str_tbl()
        local count = nil
        local cur_hi = nil
        local diag_fg = nil
        local diag_tbl = {}

        -- for signs in LSP signs
        for type, cfg in pairs(require("lsp.utils").signs) do
            -- get count
            count = #vim.diagnostic.get(0, { severity = string.upper(type) })

            -- create diagnostic group name from diag type
            diag_fg = "Diagnostic" .. type

            -- create highlight
            cur_hi = hi.create_hi_grp_str({
                grp = "Status" .. diag_fg,
                bg = status_bg,
                fg = require("utils").get_hl_by_name(diag_fg),
            })

            --[[
                create str for each type.
                We must create an associative array so that the strings can be accessed
                by name later. The array where the diagnostic symbols are defined, in
                lsp.lua, is an associative array, meaning that it cannot guarantee
                ordered access. Therefore, we must order it ourselves
            ]]
            diag_tbl[type] = table.concat({ cur_hi, cfg.sym, "%*:", count, "  " }, "")
        end

        -- return associative table of diagnostic str; diag_type = diag_count_str
        return diag_tbl
    end

    -- START: check for LSP availability
    local cur_lsp = vim.lsp.get_client_by_id(1)

    -- if lsp is available, include diagnostic info in status
    if cur_lsp ~= nil then
        -- get total diagnostic count
        local total_count = #vim.diagnostic.get(0)

        -- if we have no diagnostics, return a nice little symbol
        if total_count < 1 then
            local success_hi = hi.create_hi_grp_str({
                grp = "DiagnosticSuccess",
                bg = status_bg,
                fg = "#347d39",
            })

            local sym = "[]"

            return table.concat({ success_hi, sym, "%* " }, "")
        else
            local diag_tbl = _get_diag_str_tbl()

            local ordered_diag_str_tbl = {
                diag_tbl["Error"],
                diag_tbl["Warn"],
                diag_tbl["Hint"],
                diag_tbl["Info"],
            }

            return table.concat(ordered_diag_str_tbl, "")
        end
    end
end

M.get_icon = function(status_bg)
    local buf = vim.fn.expand("%:t")
    local ext = vim.fn.expand("%:e")

    local sym, color = require("nvim-web-devicons").get_icon_color(buf, ext)

    if sym ~= nil then
        local icon_hi = hi.create_hi_grp_str({
            grp = "StatusIcon",
            bg = status_bg,
            fg = color,
        })

        return table.concat({ " ", icon_hi, sym, "%*" }, "")
    end

    return nil
end

return M
