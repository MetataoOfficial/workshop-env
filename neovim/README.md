```
~/.config/nvim/
├── init.lua
└── lua/
    ├── config/
    │   ├── options.lua
    │   ├── keymaps.lua
    │   ├── autocmds.lua
    │   ├── functions.lua
    │   └── lazy.lua
    └── plugins/
        ├── ui.lua
        ├── editor.lua
        ├── treesitter.lua
        ├── lsp.lua
        └── completion.lua
```


```bash
git clone https://github.com/folke/lazy.nvim.git ~/.local/share/nvim/lazy/lazy.nvim

sudo pacman -S lua-language-server pyright clang gopls rust-analyzer bash-language-server
```
