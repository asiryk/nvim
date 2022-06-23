local present, comment_nvim = pcall(require, "comment-nvim")

if not present then
   return
end

local options = {}
comment_nvim.setup(options)
