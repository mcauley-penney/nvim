-- https://neovim.io/doc/user/autocmd.html
-- https://www.youtube.com/watch?v=ekMIIAqTZ34

local grp

local aucmd_tbl = {

    enter_buf = {
        BufEnter = {
            {
                -- set textwidth depending on ft
                callback = function()
                    require("aucmd.functions").set_textwidth()
                end,
            },

            {
                callback = function()
                    vim.api.nvim_buf_set_option(0, "formatoptions", "2cjnpqr")
                end,
            },
        },

        BufNewFile = {
            {
                command = "silent! 0r $HOME/.config/nvim/utils/templates/skeleton.%:e",
            },
        },

        -- load view, such as cursor position
        BufWinEnter = { { command = "silent! loadview" } },

        FileType = {
            {
                pattern = "markdown,txt",
                callback = function()
                    vim.api.nvim_win_set_option(0, "spell", true)
                end,
            },
            {
                -- allow us to close various buffers with just 'q'
                pattern = "help,lspinfo,qf,startuptime",
                callback = function()
                    vim.api.nvim_set_keymap(
                        "n",
                        "q",
                        "<cmd>close<CR>",
                        { noremap = true, silent = true }
                    )
                end,
            },
            {
                pattern = "html",
                callback = function()
                    vim.cmd("silent !xdg-open %")
                end,
            },
        },
    },

    editing = {
        CmdlineLeave = {
            {
                callback = function()
                    vim.fn.timer_start(3000, function()
                        print(" ")
                    end)
                end,
            },
        },

        -- after grep, open qf
        QuickFixCmdPost = { { command = "copen" } },

        TextYankPost = {
            {
                command = [[ silent! lua vim.highlight.on_yank{ higroup="Yank", timeout=130 }]],
            },
        },
    },

    leave_buf = {
        -- update view upon leaving
        BufWinLeave = { { command = "silent! mkview" } },

        -- set cursor back to beam, Alacritty doesn't do this
        ExitPre = {
            {
                callback = function()
                    vim.api.nvim_set_option("guicursor", "a:ver90")
                end,
            },
        },
    },
}

for group_nm, event_tbls in pairs(aucmd_tbl) do
    grp = vim.api.nvim_create_augroup(group_nm, { clear = true })

    for event, aucmd_tbls in pairs(event_tbls) do
        for _, aucmd in pairs(aucmd_tbls) do
            -- add group name to aucmd tbl
            aucmd = vim.tbl_extend("force", aucmd, { group = grp })

            vim.api.nvim_create_autocmd(event, aucmd)
        end
    end
end
