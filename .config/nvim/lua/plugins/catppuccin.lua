
local Plugin = {'catppuccin/nvim'}
Plugin.lazy=false
Plugin.name="catppuccin"

function Plugin.config()
  require("catppuccin").setup({
    flavour = "latte",
  })
end

return Plugin

