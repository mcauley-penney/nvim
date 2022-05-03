-- vim.fn: https://neovim.io/doc/user/usr_41.html#function-list

--[[
    Make grep a simpler command
    Thanks Romain! see https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
]]
vim.cmd([[
    function! LOOK( ... )
        return system(join([&grepprg] + [expandcmd( join( a:000, ' ' ))], ' '))
    endfunction
]])

vim.cmd(
    ":com -nargs=+ -complete=file_in_path -bar LOOK  cgetexpr LOOK(<f-args>)"
)

-- original by monkoose
-- https://www.reddit.com/r/neovim/comments/u221as/comment/i4g4r8b/?utm_source=share&utm_medium=web2x&context=3
vim.api.nvim_create_user_command("Cppath", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

-- Testing --------------------------------------------------------------------
-- _G.lua_grep = function(fargs)
--     local grepprg = vim.api.nvim_get_option_value("grepprg", {})
--     local grep_cmd = grepprg .. vim.fn.expandcmd(table.concat(fargs, " "))
--     return vim.fn.system(grep_cmd)
-- end

-- bar: https://neovim.io/doc/user/map.html#:command-bar
-- vim.api.nvim_create_user_command("Test", function(opts)
--     vim.cmd("cgetexpr luaeval(look_grep(<f-args))")
-- end, { bar = true, complete = "file_in_path", nargs = "+" })
