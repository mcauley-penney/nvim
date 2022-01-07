local utils = require("mappings.bindings.utils")

-- jump diagnostics
utils.map(
    "n",
    "<up>",
    "<cmd>lua vim.diagnostic.goto_prev{ float = false }<cr>",
    utils.cmd
)
utils.map(
    "n",
    "<down>",
    "<cmd>lua vim.diagnostic.goto_next{ float = false }<cr>",
    utils.cmd
)

-- rename
utils.map("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<cr>", utils.cmd)

-- show line diagnostics
utils.map(
    "n",
    "<leader>vd",
    '<cmd>lua vim.diagnostic.open_float(0, { header="", severity_sort=true })<cr>',
    {}
)
