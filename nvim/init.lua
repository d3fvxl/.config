require("config.opt")
require("config.remap")
-- use folke/lazy
require("config.lazy")

local augroup = vim.api.nvim_create_augroup
local MyGroup = augroup('MyGroup', {})
local autocmd = vim.api.nvim_create_autocmd

autocmd('LspAttach', {
    group = MyGroup,
    callback = function(e)
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end
        vim.keymap.set('n', keys, func, { buffer = e.buffer, desc = desc })
    end

    nmap('gd', vim.lsp.buf.definition, 'Go to definition')
    nmap('K', vim.lsp.buf.hover, 'Hover documentation')
    nmap('<leader>vws', vim.lsp.buf.workspace_symbol, 'Search workspace symbol')
    nmap('<leader>vd', vim.diagnostic.open_float, 'Show diagnostics')
    nmap('<leader>vca', vim.lsp.buf.code_action, 'Code action')
    nmap('<leader>vrr', vim.lsp.buf.references, 'Show references')
    nmap('<leader>vrn', vim.lsp.buf.rename, 'Rename symbol')
    nmap('[d', vim.diagnostic.goto_next, 'Next diagnostic')
    nmap(']d', vim.diagnostic.goto_prev, 'Previous diagnostic')
    vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, { buffer = e.buffer, desc = 'Signature help' })
    end
})
