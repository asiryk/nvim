local function bootstrap_manager()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

local function map_to_lazy(name, config)
  local lazy_cfg = {}
  lazy_cfg[1] = name
  for key, value in pairs(config) do
    lazy_cfg[key] = value
  end
  return lazy_cfg
end

local function load()
  bootstrap_manager()

  local config = {}
  for key, value in pairs(require("plugins.config")) do
    table.insert(config, map_to_lazy(key, value))
  end

  require("lazy").setup(config)
end

return {
  load = load,
}
