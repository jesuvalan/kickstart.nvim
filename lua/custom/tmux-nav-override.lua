-- Seamless Ctrl-h/j/k/l between nvim windows and tmux panes.
-- Turn off the plugin's own mappings and set them explicitly, so they
-- reliably replace kickstart's <C-w> mappings regardless of load order.
vim.g.tmux_navigator_no_mappings = 1
vim.pack.add({ 'https://github.com/christoomey/vim-tmux-navigator' })

local map = vim.keymap.set
map({ 'n', 't' }, '<C-h>', '<cmd>TmuxNavigateLeft<cr>',  { desc = 'Window/pane left' })
map({ 'n', 't' }, '<C-j>', '<cmd>TmuxNavigateDown<cr>',  { desc = 'Window/pane down' })
map({ 'n', 't' }, '<C-k>', '<cmd>TmuxNavigateUp<cr>',    { desc = 'Window/pane up' })
map({ 'n', 't' }, '<C-l>', '<cmd>TmuxNavigateRight<cr>', { desc = 'Window/pane right' })
