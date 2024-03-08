#!/usr/bin/env lua

os.execute([[
  rm -rfd ~/.config/nvim/plugin/;
  rm -rfd ~/.local/share/nvim/;
  rm -rfd ~/.local/state/nvim;
  rm -rfd ~/.cache/nvim/;
]])
