-- VS Code comforts: Problems panel, jump-anywhere, diff view, YAML schemas.
-- vim.pack has no lazy-loading, so these load at startup; all four are light.
vim.pack.add({
  'https://github.com/folke/trouble.nvim',
  'https://github.com/folke/flash.nvim',
  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/b0o/schemastore.nvim',
  'https://github.com/akinsho/bufferline.nvim',
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

-- tabs:bufferline --

local function close_buffer(buf)
  buf = (buf and buf > 0) and buf or vim.api.nvim_get_current_buf()
  if vim.bo[buf].modified then
    vim.notify('Buffer has unsaved changes (:w, or :bd! to discard)', vim.log.levels.WARN)
    return
  end
  -- show another buffer in every window that has this one, so no window closes
  local other
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if b ~= buf and vim.bo[b].buflisted then other = b break end
  end
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_call(win, function()
      if other then vim.cmd('buffer ' .. other) else vim.cmd('enew') end
    end)
  end
  vim.cmd('bdelete ' .. buf)
end


local ok_bl, bufferline = pcall(require, 'bufferline')
if ok_bl then
  bufferline.setup({
    options = {
      close_command = function(n) close_buffer(n) end,
      right_mouse_command = function(n) close_buffer(n) end,
      diagnostics = 'nvim_lsp',                      -- error/warning counts on tabs
      offsets = {                                    -- keep the bar clear of the explorer
        { filetype = 'neo-tree', text = 'Explorer', separator = true },
      },
    },
  })
  map('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'Close buffer' })
end

vim.keymap.set('n', '<leader>bd', function() close_buffer() end, { desc = 'Close buffer, keep window' })
