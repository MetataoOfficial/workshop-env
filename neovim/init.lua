-- ~/.config/nvim/init.lua  (Neovim 0.12+)

----------------------------------------------------------------------
-- options
----------------------------------------------------------------------
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

local o = vim.o
o.number, o.relativenumber = true, true
o.expandtab, o.shiftwidth, o.tabstop, o.softtabstop = true, 4, 4, 4
o.smartindent  = true
o.ignorecase, o.smartcase = true, true
o.termguicolors = true
o.signcolumn   = "yes"
o.undofile     = true
o.clipboard    = "unnamedplus"
o.scrolloff    = 6
o.splitright, o.splitbelow = true, true
o.completeopt  = "menu,menuone,noselect,popup"
o.path         = o.path .. ",**"          -- :find 递归
o.wildignore   = "*/node_modules/*,*/.git/*,*/target/*,*/dist/*"
o.wildoptions  = "pum,fuzzy"               -- 命令行模糊匹配

----------------------------------------------------------------------
-- keymaps
----------------------------------------------------------------------
local map = vim.keymap.set
map("n", "<leader>w", "<cmd>w<cr>")
map("n", "<leader>q", "<cmd>q<cr>")
map("n", "<esc>",     "<cmd>noh<cr><esc>")
map("t", "<esc>",     [[<C-\><C-n>]])
map("n", "<leader>e", "<cmd>Explore<cr>")  -- 内置文件浏览

----------------------------------------------------------------------
-- autocmds
----------------------------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.hl.on_yank({ timeout = 200 }) end,
})

----------------------------------------------------------------------
-- GUI font (Neovide 等 GUI 前端生效，终端 nvim 会忽略)
----------------------------------------------------------------------
vim.o.guifont = "Hack Nerd Font:h14"

-- Neovide 专属设置
if vim.g.neovide then
  vim.g.neovide_padding_top    = 8
  vim.g.neovide_padding_bottom = 8
  vim.g.neovide_padding_left   = 8
  vim.g.neovide_padding_right  = 8

  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_cursor_trail_size       = 0.2
  vim.g.neovide_refresh_rate            = 60   -- 屏幕高刷可改成 120/144

  -- Ctrl +/- 调字号，Ctrl 0 复位（很实用）
  local function set_font(size)
    vim.o.guifont = ("Hack Nerd Font:h%d"):format(size)
  end
  local font_size = 14
  vim.keymap.set("n", "<C-=>", function() font_size = font_size + 1; set_font(font_size) end)
  vim.keymap.set("n", "<C-->", function() font_size = math.max(6, font_size - 1); set_font(font_size) end)
  vim.keymap.set("n", "<C-0>", function() font_size = 14; set_font(font_size) end)
end

----------------------------------------------------------------------
-- plugins (vim.pack, 0.12 内置)
----------------------------------------------------------------------
vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/ibhagwan/fzf-lua" },
  { src = "https://github.com/folke/tokyonight.nvim" },  -- 配色，喜欢别的换掉
})

-- treesitter
-- 装 parser（首次启动后跑一次 :TSInstall lua vim vimdoc python c bash markdown markdown_inline）
require("nvim-treesitter").setup()

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local ok = pcall(vim.treesitter.start, args.buf)
    if ok then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- fzf-lua 快捷键（需要系统装了 fzf：pacman -S fzf）
map("n", "<leader>ff", "<cmd>FzfLua files<cr>")
map("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>")
map("n", "<leader>fb", "<cmd>FzfLua buffers<cr>")
map("n", "<leader>fh", "<cmd>FzfLua help_tags<cr>")

-- 配色
vim.cmd.colorscheme("tokyonight-night")

if vim.g.neovide then
  vim.g.neovide_opacity = 0.9   -- 想不透明改成 1.0
  vim.g.neovide_window_blurred = false
end

----------------------------------------------------------------------
-- LSP (内置，无需 nvim-lspconfig)
-- server 用 pacman 装：sudo pacman -S lua-language-server pyright
----------------------------------------------------------------------
vim.lsp.config("luals", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".git" },
  settings = { Lua = { workspace = { checkThirdParty = false } } },
})
vim.lsp.config("pyright", {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", ".git" },
})
vim.lsp.enable({ "luals", "pyright" })

-- 进入 LSP buffer 时启用内置补全 + 常用键
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local b = args.buf
    vim.lsp.completion.enable(true, args.data.client_id, b, { autotrigger = true })
    local opts = { buffer = b }
    map("n", "gd", vim.lsp.buf.definition,    opts)
    map("n", "gr", vim.lsp.buf.references,    opts)
    map("n", "K",  vim.lsp.buf.hover,         opts)
    map("n", "<leader>rn", vim.lsp.buf.rename, opts)
    map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    map("n", "[d", vim.diagnostic.goto_prev,  opts)
    map("n", "]d", vim.diagnostic.goto_next,  opts)
  end,
})
