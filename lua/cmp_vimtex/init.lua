local M = {}

local function _start_parser()
  if cmp_vimtex_global.config.bibtex_parser.enabled then
    cmp_vimtex_global.start_parser(cmp_vimtex_global)
  end
end

M.setup = function(options)
  require("cmp").register_source("vimtex", require("cmp_vimtex.source").new(options))

  -- Create autocommand to start bibtex_parser when we open new LaTeX buffers
  local group = vim.api.nvim_create_augroup("cmp_vimtex", {})
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "tex",
    group = group,
    callback = _start_parser,
  })

  -- Start bibtex_parser now if we are already in a LaTeX buffer
  if vim.opt_local.filetype:get() == "tex" then
    _start_parser()
  end
end

return M
