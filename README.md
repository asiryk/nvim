# nvim configuration

![preview](https://user-images.githubusercontent.com/61456651/202856540-ddb5478d-4de7-483c-b859-1b6ddc771a70.png)

## TODO

- [ ] Add syntax correction and underline for comments or identifier names (either builtin or plugin)

## Requirements

- Neovim
- A C compiler in your path and libstdc++ installed (gcc, g++) for TreeSitter

## Removing

To completely remove any footprints of the config:

```zsh
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim
```

## Useful things I want to remember

### Fix very long lines

Set a width, and split very long lines with the ones that
fit into specified width

```
:set textwidth=90
:g/^/normal gq$
```

### Spell check

```
:set spell spelllang=uk,en
```

- `zg` - add custom word to dictionary
- `zug` - remove custom word from dictionary
- `<C-^>` - Toggle between 2 recent buffers
