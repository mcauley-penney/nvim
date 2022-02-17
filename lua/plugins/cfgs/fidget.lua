require("fidget").setup({
    text = {
        commenced = "INIT",
        completed = "DONE",
        done = " ",
        spinner = "noise",
    },
    timer = {
        fidget_decay = 1000,
        spinner_rate = 100,
        task_decay = 1000,
    },
    window = {
        blend = 0,
        relative = "editor",
    },
})
