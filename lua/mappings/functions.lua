-- api docs: https://neovim.io/doc/user/api.html

local str = {
    c_sl = "// ",
    dash = "-- ",
    latx = "% ",
    text = "- ",
    octo = "# ",
}

local ft_match_table = {
    ["c"] = str.c_sl,
    ["css"] = "/*  */",
    ["cuda"] = str.c_sl,
    ["gitcommit"] = str.text,
    ["gitconfig"] = str.octo,
    ["javascript"] = str.c_sl,
    ["lua"] = str.dash,
    ["make"] = str.octo,
    ["markdown"] = str.text,
    ["python"] = str.octo,
    ["sh"] = str.octo,
    ["tex"] = str.latx,
    ["txt"] = str.text,
    ["text"] = str.text,
    ["vim"] = '" ',
    ["yaml"] = str.octo,
}

local M = {

    -- Toggles number and relativenumber.
    -- Checks the current state of the number and
    -- relativenumber settings and adjusts settings
    -- accordingly: if number isn't on, turn it on;
    -- if it is, turn on relativenumber; if relativenumber
    -- is on, turn off all numbering.
    num_toggle = function()
        local set_opt = vim.api.nvim_win_set_option

        -- determine what settings are on
        local num_on = vim.api.nvim_win_get_option(0, "number")
        local relnum_on = vim.api.nvim_win_get_option(0, "relativenumber")

        -- if number is off, turn it on
        if not num_on then
            set_opt(0, "number", true)

            -- if number is on but relnum is off, turn on relnum
        elseif num_on and not relnum_on then
            set_opt(0, "relativenumber", true)

            -- if relnum is on, turn all off
        else
            set_opt(0, "number", false)
            set_opt(0, "relativenumber", false)
        end

        return ""
    end,

    -- Send comments to buffer at cursor position.
    -- Initializes a table of comment strings,
    -- a dictionary of filetype keys and their
    -- associated comment string, and returns
    -- the correct comment string for the current
    -- filetype.
    send_comment = function()
        local ft = vim.api.nvim_buf_get_option(0, "filetype")

        return ft_match_table[ft]
    end,
}

return M
