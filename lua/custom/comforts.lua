-- VS Code comforts: Problems panel, jump-anywhere, diff view, YAML schemas.
-- vim.pack has no lazy-loading, so these load at startup; all four are light.
vim.pack.add({
  'https://github.com/folke/trouble.nvim',
  'https://github.com/folke/flash.nvim',
  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/nvim-lua/plenary.nvim',      -- diffview needs it; harmless if neo-tree already pulled it in
  'https://github.com/b0o/schemastore.nvim',
})

local map = vim.keymap.set

-- trouble: Problems panel
local ok_trouble, trouble = pcall(require, 'trouble')
if ok_trouble then
  trouble.setup({})
  map('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Problems (workspace)' })
  map('n', '<leader>xb', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Problems (buffer)' })
end

-- flash: jump anywhere on screen in two keystrokes
local ok_flash, flash = pcall(require, 'flash')
if ok_flash then
  flash.setup({})
  map({ 'n', 'x', 'o' }, 'gs', function() flash.jump() end, { desc = 'Flash jump' })
end

-- diffview: side-by-side diffs and file history
map('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = 'Git diff view' })
map('n', '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', { desc = 'File history' })

-- yaml-language-server with real schemas (Kubernetes, GitHub Actions, Helm...)
local ok_schema, schemastore = pcall(require, 'schemastore')
if ok_schema then
  vim.lsp.config('yamlls', {
    settings = {
      yaml = {
        schemaStore = { enable = false, url = '' },   -- use schemastore.nvim instead of the built-in fetch
        schemas = schemastore.yaml.schemas(),
      },
    },
  })
  vim.lsp.enable('yamlls')
end
