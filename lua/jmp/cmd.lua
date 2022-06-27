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

-- Create a scratch buffer for the current filepath
vim.api.nvim_create_user_command("Note", function()
    local function mk_notes_dir(dir)
        if vim.fn.isdirectory(dir) == 0 then
            local mkdir_res = vim.fn.mkdir(dir, "p")

            if mkdir_res == 0 then
                vim.notify("ERROR: mkdir: failed to create '" .. dir .. "'")
                return
            end
        end
    end

    local sep = ":"
    local notes_dir = vim.fn.stdpath("data") .. "/notes"

    mk_notes_dir(notes_dir)

    local clean_bufnm = string.gsub(vim.fn.expand("%:p:r"), "/", sep)

    -- create path to note: ~/.local/share/nvim/notes/santized_buf_name
    local note_path = table.concat(
        { notes_dir, "/", clean_bufnm, sep, "note.txt" },
        ""
    )

    vim.cmd("e " .. note_path)
end, {})
