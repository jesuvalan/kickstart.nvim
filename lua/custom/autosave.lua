vim.opt.autowriteall = true   -- also write before :quit, :next, :edit etc., never prompt

vim.g.autosave = true

vim.api.nvim_create_autocmd({ 'FocusLost', 'BufLeave', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('autosave', { clear = true }),
  callback = function(ev)
    local b = ev.buf
    if vim.g.autosave
      and vim.bo[b].modified and vim.bo[b].modifiable
      and vim.bo[b].buftype == '' and vim.api.nvim_buf_get_name(b) ~= '' then
      vim.api.nvim_buf_call(b, function() vim.cmd('silent! update') end)
    end
  end,
})

vim.api.nvim_create_user_command('AutosaveToggle', function()
  vim.g.autosave = not vim.g.autosave
  print('autosave ' .. (vim.g.autosave and 'on' or 'off'))
end, {})
