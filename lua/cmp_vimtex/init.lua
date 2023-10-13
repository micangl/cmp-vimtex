local M = {}

local group = vim.api.nvim_create_augroup('cmp_vimtex', {clear = true})
vim.api.nvim_create_autocmd({"BufWinEnter",}, {
    pattern = '*.tex',
    group = group,
    callback = function()
        if cmp_vimtex_global.config.bibtex_parser.enabled == 1 then
            cmp_vimtex_global.start_parser(cmp_vimtex_global)
        end
    end,
})


M.setup = function(options)
    require('cmp').register_source('vimtex', require('cmp_vimtex.source').new(options))
end

return M
