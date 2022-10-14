local present, luasnip = pcall(require, "luasnip")

if not present then return end

local options = {
  history = true,
  updateevents = "TextChanged,TextChangedI",
}

luasnip.config.set_config(options)
