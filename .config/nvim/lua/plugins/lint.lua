local severities = {
  ['warning'] = vim.diagnostic.severity.WARN,
  ['error'] = vim.diagnostic.severity.ERROR,
}

return {
  'mfussenegger/nvim-lint',
  config = function()
    local lint = require('lint')

    local name = 'slim-lint'
    lint.linters[name] = {
      cmd = name,
      args = {
        '--reporter',
        'json',
        '--stdin-file-path',
        function() return vim.api.nvim_buf_get_name(0) end,
      },
      stdin = true,
      stream = 'stdout',
      ignore_exitcode = true,
      parser = function(output, bufnr)
        local trimmed_output = vim.trim(output)
        if trimmed_output == "" then
          return {}
        end
        local decode_opts = { luanil = { object = true, array = true } }
        local ok, data = pcall(vim.json.decode, output, decode_opts)
        if not ok then
          return {
            {
              bufnr = bufnr,
              lnum = 0,
              col = 0,
              message = "Could not parse linter output due to: " .. data .. "\noutput: " .. output
            }
          }
        end

        local diagnostics = {}
        for _, file in ipairs((data or {}).files) do
          for _, offense in ipairs(file.offenses or {}) do
            local line = offense.location and offense.location.line or nil
            table.insert(diagnostics, {
              lnum = line and (line - 1) or 0,
              end_lnum = nil,
              col = 0,
              end_col = nil,
              message = offense.message,
              code = offense.linter,
              severity = severities[offense.severity],
              source = name
            })
          end
        end
        return diagnostics
      end
    }

    vim.api.nvim_create_autocmd({ 'BufRead', 'BufWritePost' }, {
      pattern = { '*.slim' },
      callback = function()
        lint.try_lint(name)
      end,
    })
  end,
}
