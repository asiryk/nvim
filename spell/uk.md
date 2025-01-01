# Ukrainian spell check

Source code: [link](https://github.com/brown-uk/dict_uk).

1. Download .aff and .dic files (from release tab).
1. Rename them to uk.aff and uk.dic. Move files to .config/nvim/spell.
1. `:mkspell ~/.config/nvim/spell/uk` - generate Neovim binary file.
1. Spell check is ready: `:set spell spelllang=en,uk`
