--if cmp_vimtex_global == nil then
--  require("cmp_vimtex").setup()
--end

local source = require("cmp_vimtex").source
if source == nil then
  require("cmp_vimtex").setup()
end
