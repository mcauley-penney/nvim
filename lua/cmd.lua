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
