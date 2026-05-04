if not require("config.tools").env_enabled("NVIM_ENABLE_COMMENT", false) then
  return
end

require("Comment").setup({
  pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})
