-- ~/.config/nvim/init.lua  (Neovim 0.12+)
----------------------------------------------------------------------
-- options
----------------------------------------------------------------------
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

local o = vim.o

-- 显示
o.number, o.relativenumber = true, true
o.cursorline   = true
o.signcolumn   = "yes"
o.scrolloff    = 6
o.showmatch    = true
o.matchtime    = 2
o.colorcolumn  = "+1"
o.termguicolors = true
o.list         = true
o.listchars    = "tab:│ ,trail:·,extends:#,nbsp:."

-- 折行
o.wrap         = true
o.linebreak    = true                    -- 折行不切断单词
o.whichwrap    = "b,s,<,>,[,],h,l"       -- 行首/尾按 h/l 或方向键自动跨行

-- 缩进
o.expandtab, o.shiftwidth, o.tabstop, o.softtabstop = true, 4, 4, 4
o.smartindent  = true
o.shiftround   = true                    -- >> << 对齐到 shiftwidth 倍数

-- 搜索
o.ignorecase, o.smartcase = true, true
o.hlsearch     = true
o.incsearch    = true

-- 文件
o.autoread     = true
o.undofile     = true
o.confirm      = true
o.fileencoding = "utf-8"
o.fileencodings = "utf-8,gbk,big5,ucs-bom"

-- 折叠（基本不折，需要时手动 zc/zo）
o.foldmethod   = "indent"
o.foldlevel    = 99

-- 其他
o.clipboard    = "unnamedplus"
o.splitright, o.splitbelow = true, true
o.completeopt  = "menu,menuone,noselect,popup"
o.path         = o.path .. ",**"
o.wildignore   = "*/node_modules/*,*/.git/*,*/target/*,*/dist/*,*.o,*.pyc"
o.wildoptions  = "pum,fuzzy"
o.wildmode     = "longest:full,full"

-- 列表/段落格式化（识别 1. 2. - * 之类列表头）
o.formatlistpat = [[^\s*\(\d\+\|[-*]\)\+[\]:.)}\t ]\s*]]
vim.opt.formatoptions:append("n")

----------------------------------------------------------------------
-- keymaps
----------------------------------------------------------------------
local map = vim.keymap.set

-- 基础
map("n", "<leader>w", "<cmd>w<cr>")
map("n", "<leader>q", "<cmd>q<cr>")
map("n", "<esc>",     "<cmd>noh<cr><esc>")
map("t", "<esc>",     [[<C-\><C-n>]])
map("n", "<leader>e", "<cmd>Explore<cr>")

-- 折行: j/k 按视觉行移动；带 count 时按物理行（兼容 5j 这种）
map({"n","x"}, "j",      "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({"n","x"}, "k",      "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({"n","x"}, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({"n","x"}, "<Up>",   "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("i",       "<Down>", "<C-o>gj")
map("i",       "<Up>",   "<C-o>gk")

-- Ctrl-S 保存（normal / insert / visual 都行）
map({"n","v"}, "<C-s>", "<cmd>update<cr>")
map("i",       "<C-s>", "<C-o><cmd>update<cr>")

-- 取消搜索高亮
map("n", "<leader>/", "<cmd>noh<cr>", { silent = true })

-- 切窗口
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- ; 替代 :，省一个 shift（旧配置带过来）
map({"n","x"}, ";",  ":")
map({"n","x"}, ";;", ";")

-- 切到当前 buffer 所在目录
map("n", "<leader>cd", "<cmd>cd %:p:h<cr><cmd>pwd<cr>")

-- 切换 paste 模式
map("n", "<leader>pp", "<cmd>setlocal paste!<cr>")

-- F6 切换拼写检查
map("n", "<F6>", "<cmd>setlocal spell!<cr>")

-- Alt-j/k 上下移动当前行/选区
map("n", "<M-j>", "<cmd>m .+1<cr>==")
map("n", "<M-k>", "<cmd>m .-2<cr>==")
map("v", "<M-j>", ":m '>+1<cr>gv=gv")
map("v", "<M-k>", ":m '<-2<cr>gv=gv")

-- 手动清行尾空白（保存时也会自动做一次）
map("n", "<leader><bs>", [[<cmd>%s/\s\+$//e<cr>]])

-- 可视模式下粘贴不污染寄存器
map("x", "p", "P")
map("x", "P", "p")

-- Y 复制到行尾（nvim 0.6+ 默认即此，显式写出来更清楚）
map("n", "Y", "y$")

----------------------------------------------------------------------
-- autocmds
----------------------------------------------------------------------
local au = vim.api.nvim_create_autocmd

-- 高亮 yank
au("TextYankPost", {
  callback = function() vim.hl.on_yank({ timeout = 200 }) end,
})

-- 打开文件时回到上次编辑位置
au("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
      pcall(vim.cmd, "normal! zz")
    end
  end,
})

-- 保存前自动去行尾空白
au("BufWritePre", {
  pattern = "*",
  callback = function()
    local cur = vim.api.nvim_win_get_cursor(0)
    pcall(vim.cmd, [[keeppatterns %s/\s\+$//e]])
    pcall(vim.api.nvim_win_set_cursor, 0, cur)
  end,
})

----------------------------------------------------------------------
-- GUI font (Neovide 等 GUI 前端生效，终端 nvim 会忽略)
----------------------------------------------------------------------
vim.o.guifont = "Hack:h14"

if vim.g.neovide then
  vim.o.linespace = 2

  vim.g.neovide_padding_top    = 8
  vim.g.neovide_padding_bottom = 8
  vim.g.neovide_padding_left   = 8
  vim.g.neovide_padding_right  = 8

  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_cursor_trail_size       = 0.2
  vim.g.neovide_refresh_rate            = 60

  vim.g.neovide_opacity        = 0.9
  vim.g.neovide_window_blurred = false

  -- Ctrl +/- 调字号，Ctrl 0 复位
  local function set_font(size)
    vim.o.guifont = ("Hack:h%d"):format(size)
  end
  local font_size = 14
  vim.keymap.set("n", "<C-=>", function() font_size = font_size + 1; set_font(font_size) end)
  vim.keymap.set("n", "<C-->", function() font_size = math.max(6, font_size - 1); set_font(font_size) end)
  vim.keymap.set("n", "<C-0>", function() font_size = 14; set_font(font_size) end)

  -- -- 关闭一些华而不实的特效
  -- 真正值得关的：滚动动画（影响"快"的体感）
  vim.g.neovide_scroll_animation_length = 0
  vim.g.neovide_scroll_animation_far_lines = 0  -- 大跳转(gg/G)也瞬移

  -- 光标动画压短即可，完全关掉反而看不清光标在哪
  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_cursor_trail_size = 0.1
  vim.g.neovide_cursor_vfx_mode = ""   -- 粒子特效，默认关

  -- 模糊和透明：要美观就开，要纯净就关
  vim.g.neovide_opacity = 0.85
  vim.g.neovide_window_blurred = true
  vim.g.neovide_floating_blur_amount_x = 1.0
  vim.g.neovide_floating_blur_amount_y = 1.0

  -- 高刷屏一定开（这才是真正影响流畅度的）
  vim.g.neovide_refresh_rate = 60   -- 144Hz 屏改 144

  -- 失焦时降帧，省电
  vim.g.neovide_refresh_rate_idle = 5

  -- 不需要打开
  -- vim.g.neovide_profiler = false  -- 默认就是 false
end

----------------------------------------------------------------------
-- plugins (vim.pack, 0.12 内置)
----------------------------------------------------------------------
vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
  { src = "https://github.com/ibhagwan/fzf-lua" },
  { src = "https://github.com/folke/tokyonight.nvim" },
})

-- treesitter（首次启动后跑一次 :TSInstall lua vim vimdoc python c bash markdown markdown_inline）
require("nvim-treesitter").setup()

au("FileType", {
  callback = function(args)
    local ok = pcall(vim.treesitter.start, args.buf)
    if ok then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- fzf-lua 快捷键（系统装 fzf：sudo pacman -S fzf）
map("n", "<leader>ff", "<cmd>FzfLua files<cr>")
map("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>")
map("n", "<leader>fb", "<cmd>FzfLua buffers<cr>")
map("n", "<leader>fh", "<cmd>FzfLua help_tags<cr>")

-- 配色
vim.cmd.colorscheme("tokyonight-night")

----------------------------------------------------------------------
-- LSP（内置，无需 nvim-lspconfig）
-- server 用 pacman 装：sudo pacman -S lua-language-server pyright bash-language-server
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
vim.lsp.config("bashls", {
  cmd = { "bash-language-server", "start" },
  filetypes = { "sh", "bash" },
  root_markers = { ".git" },
})
vim.lsp.enable({ "luals", "pyright", "bashls" })

au("LspAttach", {
  callback = function(args)
    local b = args.buf
    vim.lsp.completion.enable(true, args.data.client_id, b, { autotrigger = true })
    local opts = { buffer = b }
    map("n", "gd", vim.lsp.buf.definition,        opts)
    map("n", "gr", vim.lsp.buf.references,        opts)
    map("n", "K",  vim.lsp.buf.hover,             opts)
    map("n", "<leader>rn", vim.lsp.buf.rename,    opts)
    map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    map("n", "[d", vim.diagnostic.goto_prev,      opts)
    map("n", "]d", vim.diagnostic.goto_next,      opts)
  end,
})
