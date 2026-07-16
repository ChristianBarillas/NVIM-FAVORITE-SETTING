-- Reemplaza los diagnósticos de eslint_d que daba null-ls
return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require('lint')

    lint.linters_by_ft = {
      javascript = { 'eslint_d' },
      javascriptreact = { 'eslint_d' },
      typescript = { 'eslint_d' },
      typescriptreact = { 'eslint_d' },
    }

    -- Solo lintear si el proyecto tiene configuración de ESLint
    local function has_eslint_config(bufnr)
      local fname = vim.api.nvim_buf_get_name(bufnr)
      if fname == '' then
        return false
      end
      return #vim.fs.find({
        '.eslintrc',
        '.eslintrc.js',
        '.eslintrc.cjs',
        '.eslintrc.json',
        'eslint.config.js',
        'eslint.config.mjs',
        'eslint.config.cjs',
      }, { path = fname, upward = true }) > 0
    end

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = vim.api.nvim_create_augroup('nvim_lint', { clear = true }),
      callback = function(ev)
        local linters = lint.linters_by_ft[vim.bo[ev.buf].filetype]
        if linters and not has_eslint_config(ev.buf) then
          return
        end
        lint.try_lint(nil, { ignore_errors = true })
      end,
    })
  end,
}
