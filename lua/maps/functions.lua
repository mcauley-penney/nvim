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
    ["cpp"] = str.c_sl,
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

-- https://github.com/ray-x/nvim/blob/d25925d4b6c7b19c8cac2d3b29f2e4ee052ea804/lua/core/helper.lua#L64-L93
-- _G.Snake = function(s)
--     if s == nil then
--         s = vim.fn.expand("<cword>")
--     end
--     lprint("replace: ", s)
--     local n = s
--         :gsub("%f[^%l]%u", "_%1")
--         :gsub("%f[^%a]%d", "_%1")
--         :gsub("%f[^%d]%a", "_%1")
--         :gsub("(%u)(%u%l)", "%1_%2")
--         :lower()
--     vim.fn.setreg("s", n)
--     vim.cmd([[exe "norm! ciw\<C-R>s"]])
--     lprint("newstr", n)
-- end

-- -- convert to camel case
-- _G.Camel = function()
--     local s
--     if s == nil then
--         s = vim.fn.expand("<cword>")
--     end
--     local n = string.gsub(s, "_%a+", function(word)
--         local first = string.sub(word, 2, 2)
--         local rest = string.sub(word, 3)
--         return string.upper(first) .. rest
--     end)
--     vim.fn.setreg("s", n)
--     vim.cmd([[exe "norm! ciw\<C-R>s"]])
-- end

local M = {

    -- Send comments to buffer at cursor position.
    send_comment = function()
        local ft = vim.api.nvim_buf_get_option(0, "filetype")

        return ft_match_table[ft]
    end,
}

return M
