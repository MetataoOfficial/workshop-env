-- ~/.config/nvim/init.lua  (Neovim 0.12+ 架构)
-- ~/.local/share/nvim/site/pack/plugins/start/  (Default)
--

----------------------------------------------------------------------
-- 1. 基础选项 (Options)
----------------------------------------------------------------------
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

local o = vim.o

-- 显示与交互
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
o.whichwrap    = "b,s,<,>,[,],h,l"       -- 行首/尾自动跨行

-- 缩进
o.expandtab, o.shiftwidth, o.tabstop, o.softtabstop = true, 4, 4, 4
o.smartindent  = true
o.shiftround   = true                    -- 缩进对齐到 shiftwidth 倍数

-- 搜索
o.ignorecase, o.smartcase = true, true
o.hlsearch     = true
o.incsearch    = true

-- 文件与备份
o.autoread     = true
o.undofile     = true
o.confirm      = true
o.fileencoding = "utf-8"
o.fileencodings = "utf-8,gbk,big5,ucs-bom"

-- 折叠
o.foldmethod   = "indent"
o.foldlevel    = 99

-- 其他性能与体验优化
o.clipboard    = "unnamedplus"
o.splitright, o.splitbelow = true, true
o.completeopt  = "menu,menuone,noselect,popup"
o.path         = o.path .. ",**"
o.wildignore   = "*/node_modules/*,*/.git/*,*/target/*,*/dist/*,*.o,*.pyc"
o.wildoptions  = "pum,fuzzy"
o.wildmode     = "longest:full,full"

-- 列表/段落格式化
o.formatlistpat = [[^\s*\(\d\+\|[-*]\)\+[\]:.)}\t ]\s*]]
vim.opt.formatoptions:append("n")

----------------------------------------------------------------------
-- 2. 内置插件管理 (本地化极速挂载，彻底免疫超时)
----------------------------------------------------------------------
local plugins = {
  { name = "fzf-lua",             src = "https://github.com/ibhagwan/fzf-lua" },
  { name = "tokyonight.nvim",     src = "https://github.com/folke/tokyonight.nvim" },
  { name = "nvim-surround",       src = "https://github.com/kylechui/nvim-surround" },
  { name = "mini.comment",        src = "https://github.com/nvim-mini/mini.comment" },
  { name = "multicursor.nvim",    src = "https://github.com/jake-stewart/multicursor.nvim" },
  { name = "gitsigns.nvim",       src = "https://github.com/lewis6991/gitsigns.nvim" },
}

local data_path = vim.fn.stdpath("data")
local start_dir = data_path .. "/site/pack/plugins/start/"

-- 智能检测：如果未下载过，进行全自动深度下载
if vim.fn.isdirectory(start_dir .. "fzf-lua") == 0 then
  vim.notify("首次启动，正在全自动下载精选核心插件，请稍候...", vim.log.levels.INFO)
  vim.fn.mkdir(start_dir, "p")
  for _, p in ipairs(plugins) do
    local target_path = start_dir .. p.name
    print("正在克隆标准包: " .. p.name)
    vim.fn.system({ "git", "clone", "--depth", "1", p.src, target_path })
  end
  vim.notify("🎉 插件已全部同步到位！", vim.log.levels.INFO)
end

-- 核心修复点：绕过容易超时的 vim.pack.add，直接用原生 runtimepath 秒级挂载本地路径
for _, p in ipairs(plugins) do
  local path = start_dir .. p.name
  vim.opt.runtimepath:append(path)
end

-- 2.1 基础外观与核心插件初始化
vim.cmd.colorscheme("tokyonight-night")
require("nvim-surround").setup()
require("mini.comment").setup()
require("gitsigns").setup()

-- 原生 Netrw 文件浏览器精细调优 (极轻量)
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 25

-- 2.2 Multicursor (多光标) 配置与快捷键
local mc = require("multicursor-nvim")
mc.setup()

-- 添加/跳过下一个匹配光标 (避开 <C-s> 与保存键冲突)
vim.keymap.set({"n", "v"}, "<C-n>",     function() mc.matchAddCursor(1)  end)
vim.keymap.set({"n", "v"}, "<leader>S", function() mc.matchSkipCursor(1) end)
vim.keymap.set({"n", "v"}, "<leader>x", mc.deleteCursor)

-- 使用官方推荐的 keymap layer：仅在存在多光标时才接管 <Esc>，
-- 这样不会与 :nohl 等单光标下的常规行为冲突
mc.addKeymapLayer(function(layerSet)
  layerSet("n", "<esc>", function()
    if not mc.cursorsEnabled() then
      mc.enableCursors()
    else
      mc.clearCursors()
    end
  end)
end)

-- 2.3 开启 Neovim 内置的高效原生语法高亮
vim.cmd("syntax on")
vim.cmd("filetype plugin indent on")

----------------------------------------------------------------------
-- 3. 快捷键映射 (Keymaps)
----------------------------------------------------------------------
local map = vim.keymap.set

-- 核心与文件操作
map("n", "<leader>w", "<cmd>w<cr>")
map("n", "<leader>q", "<cmd>q<cr>")
map({"n", "v"}, "<C-s>", "<cmd>update<cr>")
map("i", "<C-s>", "<C-o><cmd>update<cr>")

-- 使用原生高级文件管理器 Explore，按下 - 键直接在当前窗口展开目录
map("n", "-", "<cmd>Explore<cr>")

-- 光标与文本移动增强
map({"n", "x"}, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({"n", "x"}, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({"n", "x"}, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({"n", "x"}, "<Up>",   "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("i", "<Down>", "<C-o>gj")
map("i", "<Up>",   "<C-o>gk")

map({"n", "v"}, "<Home>", "^")
map({"n", "v"}, "<End>", "$")
map("n", "<PageUp>", "{")
map("n", "<PageDown>", "}")

-- 命令行与辅助快捷键
map({"n", "x"}, ";", ":")
map({"n", "x"}, ";;", ";")
map("n", "<leader>/", "<cmd>noh<cr>", { silent = true })
map("n", "\\", ":%s/%/gc", { desc = "Global replace with confirm" })
map("n", "<leader>cd", "<cmd>cd %:p:h<cr><cmd>pwd<cr>")
map("n", "<leader>pp", "<cmd>setlocal paste!<cr>")
map("n", "<F10>", "<cmd>setlocal spell!<cr>")

-- 窗口切换
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- 文本行编辑与调整
map("n", "<M-j>", "<cmd>m .+1<cr>==")
map("n", "<M-k>", "<cmd>m .-2<cr>==")
map("v", "<M-j>", ":m '>+1<cr>gv=gv")
map("v", "<M-k>", ":m '<-2<cr>gv=gv")
map("n", "<leader><bs>", [[<cmd>%s/\s\+$//e<cr>]])
map("x", "p", "P")
map("x", "P", "p")
map("n", "Y", "y$")

-- 工具函数：动态内容插入
map("i", "<C-d>", function() return os.date("%Y-%m-%d %H:%M:%S") end, { expr = true })

-- F11: 插入标准分界线
map({"n", "i"}, "<F11>", function()
  local line = string.rep("-", 70)
  vim.api.nvim_put({ line }, "l", true, true)
end)

-- F12: 动态插入文件头说明
map({"n", "i"}, "<F12>", function()
  local filename = vim.fn.expand("%:t")
  local ext = vim.fn.expand("%:e")
  local comment_char = (ext == "sh" or ext == "py") and "# " or "-- "
  local header = {
    comment_char .. "File: " .. filename,
    comment_char .. "Created: " .. os.date("%Y-%m-%d %H:%M:%S"),
    comment_char .. "Author: Teacher",
    comment_char .. string.rep("-", 64)
  }
  vim.api.nvim_put(header, "l", false, true)
end)

-- Tab 键智能补全映射：在输入模式下如果前方有内容，按 Tab 唤醒内置 LSP/Omni 菜单
map("i", "<Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-x><C-o>"
end, { expr = true })

-- fzf-lua 模糊搜索
map("n", "<leader>ff", "<cmd>FzfLua files<cr>")
map("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>")
map("n", "<leader>fb", "<cmd>FzfLua buffers<cr>")
map("n", "<leader>fh", "<cmd>FzfLua help_tags<cr>")

----------------------------------------------------------------------
-- 4. 自动化行为 (Autocmds) & 括号智能处理
----------------------------------------------------------------------
local au = vim.api.nvim_create_autocmd

-- 高亮 Yank
au("TextYankPost", { callback = function() vim.hl.on_yank({ timeout = 200 }) end })

-- 恢复上次光标位置
au("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
      pcall(vim.cmd, "normal! zz")
    end
  end,
})

-- 创建一个自动命令组，避免重复加载时叠加
local autocd_group = vim.api.nvim_create_augroup("AutoCDGroup", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  group = autocd_group,
  pattern = "*",
  callback = function()
    -- 获取当前缓冲区的类型和文件路径
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = 0 })
    local file_path = vim.api.nvim_buf_get_name(0)

    -- 排除非特殊文件缓冲区（如 terminal, nofile）并确保文件路径不为空
    if buftype == "" and file_path ~= "" then
      -- 提取文件所在的目录
      local dir = vim.fs.dirname(file_path)
      -- 检查目录是否存在，并切换
      if vim.fn.isdirectory(dir) == 1 then
        vim.api.nvim_set_current_dir(dir)
      end
    end
  end,
})

-- 保存时自动清理尾随空格
au("BufWritePre", {
  pattern = "*",
  callback = function()
    local cur = vim.api.nvim_win_get_cursor(0)
    pcall(vim.cmd, [[keeppatterns %s/\s\+$//e]])
    pcall(vim.api.nvim_win_set_cursor, 0, cur)
  end,
})

-- 大文件性能优化方案 (> 5MB 自动关闭重度功能)
au({ "BufReadPre", "BufNewFile" }, {
  pattern = "*",
  callback = function(args)
    local max_size = 5 * 1024 * 1024 -- 5MB
    local ok, stats = pcall(vim.uv.fs_stat, args.file)
    if ok and stats and stats.size > max_size then
      vim.bo[args.buf].undofile = false
      vim.bo[args.buf].swapfile = false
      vim.cmd("syntax off")
    end
  end,
})

-- 自动化括号闭合与行尾分号/冒号映射
-- 注意：变量名避开 Lua 内置全局函数 pairs，否则会抹掉迭代器导致启动报错
-- 自动化括号闭合与行尾分号/冒号映射
local pair_match_map = { ["("] = ")", ["["] = "]", ["{"] = "}" }

for open, close in pairs(pair_match_map) do
  vim.keymap.set('i', open, function()
    -- 获取当前行内容和当前光标的列号 (从 0 开始计数)
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]

    -- 截取光标之后的文本
    local after_cursor = string.sub(line, col + 1)

    -- 使用 Lua 正则判断光标后是否全为空格/制表符，或者已经到行尾
    -- ^%s*$ 匹配纯空白字符或空字符串
    if string.match(after_cursor, "^%s*$") then
      -- 在行尾：自动闭合，并将光标向左移动一格放到括号中间
      return open .. close .. "<Left>"
    else
      -- 在行中：仅插入左括号，不自动闭合
      return open
    end
  end, { expr = true, noremap = true, silent = true })
end

-- 快捷在行尾补齐常规符号并换行 (Alt + 符号)
map("i", "<M-=>", "<Esc>A;<Cr>")
map("i", "<M-->", "<Esc>A:<Cr>")

----------------------------------------------------------------------
-- 5. 内置 LSP 配置 (基于 0.12+ 标准原生架构，函数式结构彻底规避结合歧义)
----------------------------------------------------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- 创建 LSP 挂载后的核心快捷键与自动补全行为
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local b = args.buf

    -- 改用最纯净、永不报接口失效错误的标准 omnifunc 补全挂载
    vim.bo[b].omnifunc = "v:lua.vim.lsp.omnifunc"

    local opts = { buffer = b }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition,          opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references,          opts)
    vim.keymap.set("n", "K",  vim.lsp.buf.hover,               opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,      opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

    -- 使用 0.11+ 推荐的现代 API，规避 goto_prev/goto_next 弃用警告
    vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count =  1, float = true }) end, opts)
  end,
})

-- 将配置改成动态函数返回，彻底摧毁局部变量在语法边界上的连读歧义
local function get_server_config(server_name)
  if server_name == "basedpyright" then
    return { cmd = { "basedpyright-langserver", "--stdio" }, filetypes = { "python" } }
  elseif server_name == "luals" then
    return { cmd = { "lua-language-server" }, filetypes = { "lua" } }
  elseif server_name == "bashls" then
    return { cmd = { "bash-language-server", "start" }, filetypes = { "sh", "bash" } }
  elseif server_name == "dartls" then
    return { cmd = { "dart", "language-server", "--protocol=lsp" }, filetypes = { "dart" } }
  end
  return nil
end

-- 智能按需挂载启动 (纯指令式调用，绝对无法产生 table 混淆)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "lua", "sh", "bash", "dart" },
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    local server_name = ft == "python" and "basedpyright"
      or (ft == "sh" and "bashls"
      or (ft == "bash" and "bashls"
      or ft .. "ls"))

    local config = get_server_config(server_name)
    if config then
      config.capabilities = capabilities
      config.name = server_name
      vim.lsp.start(config, { bufnr = args.buf })
    end
  end,
})

----------------------------------------------------------------------
-- 6. LaTeX 构建与跨平台 PDF 智能预览
----------------------------------------------------------------------
-- LaTeX 异步编译（安全优化版）
map("n", "<leader>ll", function()
  local file_path = vim.fn.expand("%:p")
  if file_path == "" then
    print("Error: Current buffer has no file path.")
    return
  end

  -- 动态获取文件所在的绝对目录，彻底解决 auto change dir 的顾虑
  local file_dir = vim.fs.dirname(file_path)
  -- 打印提示，让心里有底
  print("LaTeX compiler triggered asynchronously...")

  vim.system(
    {
      "latexmk",
      "-xelatex",
      "-interaction=nonstopmode",
      "-halt-on-error", -- 遇到致命错误立即停止，绝不阻塞后台
      file_path
    },
    {
      detach = true,
      cwd = file_dir,   -- 强制将编译工作目录锁定在文件所在目录，缓存垃圾不乱飞
      -- 将输出重定向到系统的黑洞，防止管道阻塞导致 GUI 卡死
      stdout = function(_, _) end,
      stderr = function(_, _) end
    },
    -- 编译结束后的回调（可选：可以在这里加上编译成功/失败的轻量通知）
    function(obj)
      if obj.code == 0 then
        vim.schedule(function() print("✨ LaTeX compiled successfully!") end)
      else
        vim.schedule(function() print("❌ LaTeX compilation failed. Check your logs.") end)
      end
    end
  )
end)

-- LaTeX PDF 智能预览路径识别 (<leader>lv)
map("n", "<leader>lv", function()
  local pdf = vim.fn.expand("%:p:r") .. ".pdf"
  if vim.fn.filereadable(pdf) == 0 then
    print("Error: PDF file not found. Build the document first via <leader>ll")
    return
  end

  -- 自动匹配系统环境下的最适预览器
  local viewer = "zathura" -- 默认首选
  if vim.fn.executable("zathura") == 0 then
    if vim.fn.executable("evince") == 1 then viewer = "evince"
    elseif vim.fn.executable("okular") == 1 then viewer = "okular"
    else viewer = "xdg-open" end
  end

  vim.system({ viewer, pdf }, { detach = true })
  print("Opening PDF with " .. viewer)
end)

----------------------------------------------------------------------
-- 7. Neovide / GUI 渲染特化增强
----------------------------------------------------------------------
vim.o.guifont = "Hack:h14"

if vim.g.neovide then
  vim.o.linespace = 2
  vim.g.neovide_padding_top, vim.g.neovide_padding_bottom = 8, 8
  vim.g.neovide_padding_left, vim.g.neovide_padding_right = 8, 8

  -- 高刷屏帧率同步与能效平衡
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_refresh_rate_idle = 5

  -- 核心响应速度调优
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_scroll_animation_far_lines = 0
  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_cursor_trail_size = 0.1
  vim.g.neovide_cursor_vfx_mode = ""

  -- 窗口模糊与透明度视效
  vim.g.neovide_opacity = 0.85
  vim.g.neovide_window_blurred = true
  vim.g.neovide_floating_blur_amount_x = 1.0
  vim.g.neovide_floating_blur_amount_y = 1.0

  -- 动态字号热调节组
  local font_size = 14
  local function set_font(size) vim.o.guifont = ("Hack:h%d"):format(size) end
  map("n", "<C-=>", function() font_size = font_size + 1; set_font(font_size) end)
  map("n", "<C-->", function() font_size = math.max(6, font_size - 1); set_font(font_size) end)
  map("n", "<C-0>", function() font_size = 14; set_font(font_size) end)
end

----------------------------------------------------------------------
-- 8. 扩展工具命令：一键更新所有原生插件 (采用现代安全 API)
----------------------------------------------------------------------
vim.api.nvim_create_user_command("PluginUpdate", function()
  local plugin_dir = vim.fn.stdpath("data") .. "/site/pack/plugins/start/"
  local handle = vim.uv.fs_scandir(plugin_dir)
  if not handle then
    vim.notify("未找到标准插件安装目录！", vim.log.levels.ERROR)
    return
  end

  vim.notify("开始检查并异步更新所有本地标准插件...", vim.log.levels.INFO)

  while true do
    local name, type = vim.uv.fs_scandir_next(handle)
    if not name then break end
    if type == "directory" then
      print("正在同步更新: " .. name)
      vim.fn.system({ "git", "-C", plugin_dir .. name, "pull" })
    end
  end

  vim.notify("🎉 所有本地标准插件已成功同步至最新版本！", vim.log.levels.INFO)
end, {})
