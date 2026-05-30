# Neovim 简明使用说明

## 一、首次安装

```bash
# 1. 系统依赖（Manjaro）；配置文件就位后，首次启动会自动克隆所有插件
sudo pacman -S neovim git ripgrep fd fzf bat
sudo pacman -S lua-language-server pyright clang gopls rust-analyzer bash-language-server
sudo pacman -S ttf-hack-nerd && fc-cache -fv
```

> 插件全部托管在 `~/.local/share/nvim/site/pack/plugins/start/`，使用 Neovim 0.12+ 原生包机制，无需 lazy.nvim。

---

## 二、领导键

`<Leader>` = **空格键**

---

## 三、核心键绑定速查

### 文件与窗口

| 键位 | 作用 |
|---|---|
| `<Space>w` | 保存文件 |
| `<Space>q` | 退出 |
| `<C-s>` | 更新保存（普通/插入/可视模式都可用） |
| `-` | 在当前窗口打开文件浏览器 (Netrw) |
| `<C-h/j/k/l>` | 在分屏窗口间跳转 |
| `<Space>cd` | 切换 Neovim 工作目录到当前文件所在目录 |

### 模糊搜索（fzf-lua）

| 键位 | 作用 |
|---|---|
| `<Space>ff` | 查找文件 |
| `<Space>fg` | 全项目内容搜索（live grep） |
| `<Space>fb` | 切换缓冲区 |
| `<Space>fh` | 搜索帮助文档 |

### 搜索与替换

| 键位 | 作用 |
|---|---|
| `<Space>/` | 清除搜索高亮 |
| `\` | 全文交互式替换（光标停在 `s/旧/新/gc` 中间） |
| `;` | 直接进入命令行（等同 `:`） |
| `;;` | 原始的 `;`（重复 f/F/t/T） |

### 文本编辑

| 键位 | 作用 |
|---|---|
| `<M-j>` / `<M-k>` | 上下移动当前行（可视模式下移动选区） |
| `<Space><BS>` | 清除全文尾部空格 |
| `Y` | 复制到行尾（与 `D`、`C` 行为一致） |
| `<F10>` | 开关拼写检查 |
| `<F11>` | 插入一条 70 字符分隔线 |
| `<F12>` | 插入文件头注释（自动识别 .py/.sh/.lua） |
| `<C-d>`（插入模式） | 插入当前日期时间 |

### 括号自动闭合

输入 `(`、`[`、`{` 自动补全右括号；如果右括号已存在，再次按下会自动跳过。
另有 `<M-=>` 行尾补 `;` 并换行，`<M-->` 行尾补 `:` 并换行。

### 多光标（multicursor.nvim）

| 键位 | 作用 |
|---|---|
| `<C-n>` | 选中光标处单词，并向下添加下一个匹配 |
| `<Space>S` | 跳过当前匹配，添加下一个 |
| `<Space>x` | 删除当前主光标 |
| `<Esc>` | 多光标存在时清除多光标，否则清除搜索高亮 |

### 包围符号（nvim-surround）

| 键位 | 示例 | 效果 |
|---|---|---|
| `ys{动作}{符号}` | `ysiw"` | 给单词加上 `"..."` |
| `cs{原}{新}` | `cs'"` | 把 `'...'` 改成 `"..."` |
| `ds{符号}` | `ds(` | 删除外层 `( ... )` |

### 注释（mini.comment）

| 键位 | 作用 |
|---|---|
| `gcc` | 注释/取消注释当前行 |
| `gc{动作}` | 注释一段，例如 `gcip` 注释整个段落 |
| 可视模式下 `gc` | 注释当前选区 |

### LSP（光标在符号上）

| 键位 | 作用 |
|---|---|
| `gd` | 跳转到定义 |
| `gr` | 查看引用 |
| `K` | 悬浮文档 |
| `<Space>rn` | 重命名符号 |
| `<Space>ca` | 代码动作（修复建议） |
| `[d` / `]d` | 上一个 / 下一个诊断 |
| `<Tab>`（插入模式） | 触发 LSP 自动补全菜单 |

### Git（gitsigns）

签栏会自动显示增删改标记。常用：
- `:Gitsigns preview_hunk` 预览改动
- `:Gitsigns stage_hunk` 暂存当前块
- `:Gitsigns reset_hunk` 撤销当前块

### LaTeX

| 键位 | 作用 |
|---|---|
| `<Space>ll` | 异步编译当前 .tex（latexmk + xelatex） |
| `<Space>lv` | 自动识别 zathura/evince/okular 打开 PDF |

### 其他实用

| 键位 | 作用 |
|---|---|
| `<Space>pp` | 切换 paste 模式 |
| `j` / `k` | 在折行的长行内按视觉行移动 |
| `<Home>` / `<End>` | 行首 / 行尾 |
| `<PageUp>` / `<PageDown>` | 跳到上 / 下一段 |

---

## 四、维护

```vim
:PluginUpdate     " 自动 git pull 所有本地插件
:checkhealth      " 体检
:LspInfo          " 查看当前 LSP 连接状态
```

Neovide GUI 下额外支持：`<C-=>` / `<C-->` / `<C-0>` 调节字号。

---

## 五、目录速记

```
~/.config/nvim/init.lua                              # 唯一配置文件
~/.local/share/nvim/site/pack/plugins/start/         # 插件目录
~/.local/share/nvim/undo/                            # 持久化撤销
```
