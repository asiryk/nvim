require("Comment").setup()
require "editor/completion"
require "editor/syntax"
require "colorizer".setup {  -- requires termguicolors
  "html", "css", "javascript", "typescript", "svelte", "lua"
}
