local M = {}

function M.bootstrap()
   local fn = vim.fn
   local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

   vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e222a" })

   if fn.empty(fn.glob(install_path)) > 0 then
      print("Cloning packer ..")
      --fn.system({ "git", "clone", "--depth", "1", "https://github.com/asiryk/packer.nvim", install_path })
      fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })

      -- install plugins + compile their configs
      vim.cmd("packadd packer.nvim")
      require("plugins")
      vim.cmd("PackerSync")
   end
end

function M.startup(plugins)
   local present, packer = pcall(require, "packer")

   if not present then return end

   packer.init({
      auto_clean = true,
      compile_on_sync = true,
      git = { clone_timeout = 6000 },
      display = {
         working_sym = "",
         error_sym = "✗",
         done_sym = "",
         removed_sym = "",
         moved_sym = "",
         open_fn = function()
            return require("packer.util").float { border = "single" }
         end,
      },
   })

   packer.startup(function(use)
      for plugin_name, config in pairs(plugins) do
         use({ plugin_name, config })
      end
   end)
end

function M.lazy_load(tb)
   vim.api.nvim_create_autocmd(tb.events, {
      pattern = "*",
      group = vim.api.nvim_create_augroup(tb.augroup_name, {}),
      callback = function()
         if tb.condition() then
            vim.api.nvim_del_augroup_by_name(tb.augroup_name)

            -- dont defer for treesitter as it will show slow highlighting
            -- This deferring only happens only when we do "nvim filename"
            if tb.plugins ~= "nvim-treesitter" then
               vim.defer_fn(function()
                  vim.cmd("PackerLoad " .. tb.plugins)
               end, 0)
            else
               vim.cmd("PackerLoad " .. tb.plugins)
            end
         end
      end,
   })
end

function M.load_on_file_open(plugin_name)
   M.lazy_load({
      events = { "BufRead", "BufWinEnter", "BufNewFile" },
      augroup_name = "BeLazyOnFileOpen" .. plugin_name,
      plugins = plugin_name,
      condition = function()
         local file = vim.fn.expand("%")
         return file ~= "NvimTree_1" and file ~= "[packer]" and file ~= ""
      end,
   })
end

return M
