return {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    opts = {
        symbol_folding = {
            -- Depth past which nodes will be folded by default
            autofold_depth = 1,
        },
        guides = {
            enabled = false,
        },
    },
    keys = {
        { "<leader>o", "<cmd>Outline<cr>", desc = "[T]oggle [O]utline" },
    },
}
