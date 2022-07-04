-- Make grep a simpler command
-- Original: romainl
-- https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
vim.cmd([[
    function! LOOK( ... )
        return system(join([&grepprg] + [expandcmd( join( a:000, ' ' ))], ' '))
    endfunction
]])

vim.cmd(
    ":com -nargs=+ -complete=file_in_path -bar LOOK  cgetexpr LOOK(<f-args>)"
)

-- Copy the current file path to the clipboard
-- Original: monkoose
-- https://www.reddit.com/r/neovim/comments/u221as/comment/i4g4r8b/?utm_source=share&utm_medium=web2x&context=3
vim.api.nvim_create_user_command("Cppath", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})
