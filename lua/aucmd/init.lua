local new_cmds = {

    BufEnter = {
        {
            callback = function()
                require("aucmd.functions").set_textwidth()
            end,
        },
    },

    BufNewFile = {
        {
            command = "silent! 0r $HOME/.config/nvim/utils/templates/skeleton.%:e",
        },
    },

    BufWinEnter = {
        { command = "silent! loadview" },
    },

    BufWinLeave = {
        { command = "silent! mvview" },
    },

    CmdlineLeave = {
        {

            callback = function()
                vim.fn.timer_start(1500, function()
                    print(" ")
                end)
            end,
        },
    },

    ExitPre = {
        {

            callback = function()
                vim.api.nvim_set_option("guicursor", "a:ver90")
            end,
        },
    },

    FileType = {
        {
            pattern = "txt",
            callback = function()
                vim.api.nvim_set_option("spell", true)
            end,
        },
        {
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
    },

    InsertEnter = {
        {
            callback = function()
                vim.api.nvim_set_option("number", false)
                vim.api.nvim_set_option("relativenumber", false)
            end,
        },
    },

    QuickFixCmdPost = {
        {
            command = "TroubleToggle quickfix",
        },
    },

    TextYankPost = {
        {
            callback = function()
                vim.highlight.on_yank({ higroup = "Yank", timeout = 165 })
            end,
        },
    },
}

for event, opt_tbls in pairs(new_cmds) do
    for _, opt_tbl in pairs(opt_tbls) do
        vim.api.nvim_create_autocmd(event, opt_tbl)
    end
end
