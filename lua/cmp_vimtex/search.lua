local cmp = require('cmp')

local search = {}

search.perform_search = function(opts)
  if cmp.visible() then
    local label = cmp.get_selected_entry():get_word()

    local data = extract_bib_data(label)

    -- Execute search
    local url = nil
    if cmp_vimtex_global~= nil and cmp_vimtex_global.config ~= nil then
      if opts ~= nil and opts.engine ~= nil then
        if cmp_vimtex_global.config.search.search_engines[opts.engine] ~= nil then
          url = cmp_vimtex_global.config.search.search_engines[opts.engine].get_url(data)
        else
          url = cmp_vimtex_global.config.search.search_engines[cmp_vimtex_global.config.search.default].get_url(data)
        end
      else
        url = cmp_vimtex_global.config.search_engines[cmp_vimtex_global.config.search.default].get_url(data)
      end
    end

    if url ~= nil then
      vim.cmd(string.format([[silent execute '!google-chrome-stable ' "%s"]], url))
    end
  else
    -- Check if under cursor there is a citation key. If so, query the cache to
    -- get additional data for a websearch; if no data can be found, simply
    -- search using the citation key.
  end
end

local extract_bib_data = function(label)
  if cmp_vimtex_global ~= nil and cmp_vimtex_global.bib_files ~= nil then
    for _, el in pairs(cmp_vimtex_global.bib_files) do
      if el[label] ~= nil then
        return el[label]
      end
    end
  end
  return label
end

return search
