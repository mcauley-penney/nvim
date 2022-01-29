require("fidget").setup({
    text = {
        commenced = "INIT", -- message shown when task starts
        completed = "DONE",
        done = " ",
        spinner = "noise",
    },
    timer = {
        fidget_decay = 1000,
        spinner_rate = 100,
        task_decay = 1000,
    },
})
