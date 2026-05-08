# Niri 工作空间使用指南 (CELL 适配版)

## ⌨️ 快捷键速查

### 1. 核心导航与跳转

| 快捷键 | 功能 | 说明 |
| --- | --- | --- |
| `Mod + Tab` | 逻辑跳转 | **LRU 次序**：快速回到上一个操作的窗口 |
| `Mod + H / L` | 轨道左右滑动 | 在无限水平画卷中左右穿梭 |
| `Mod + J / K` | 工作区切换 | 在垂直堆叠的工作区间切换（Down/Up） |

### 2. 应用程序启动 (延续 i3wm 习惯)

| 快捷键 | 目标程序 | 对应 i3 命令 |
| --- | --- | --- |
| `Mod + Return` | **Alacritty** | `$terminal_launcher` |
| `Mod + Space` | **Firefox** | `$browser_launcher` |
| `Mod + Escape` | **Emacs** | `$editor_launcher` |
| `Mod + BackSpace` | **Nemo** | `$filer_launcher` |
| `Mod + X` | **Rofi** | 应用启动器 |

### 3. 轨道与窗口管理

* **移动窗口顺序**：`Mod + Shift + H / L`（像搬动幻灯片一样调整全屏窗口顺序）。

* **移动窗口顺序**：`Mod + Shift + J / K`（调整窗口所处的工作区）。

* **全屏/最大化**：`Mod + Z`（切换最大化状态）。

* **关闭窗口**：`Mod + Shift + C` 。

* **浮动模式**：`Mod + V` 。


### 4. 工作区映射 (n/i/o/u 逻辑)

| 快捷键 | 功能 |
| --- | --- |
| `Mod + n/i/o/u` | 切换到工作区 1/2/3/4 |
| `Mod + Shift + n/i/o/u` | 将当前窗口移动到工作区 1/2/3/4 |

### 5. 系统控制

* **音量控制**：`XF86AudioRaise/LowerVolume` 。

* **亮度控制**：`XF86MonBrightnessUp/Down` 。

* **锁屏与休眠**：`Mod + Ctrl + Grave` (锁屏) 。

* **重载配置**：`Mod + Shift + R` 。

---

## 🛠️ 环境依赖

* **键盘布局**：需预先在 `~/.config/xkb/symbols/` 定义 `cell` 文件 。

* **基础组件**：`waybar`（状态栏）、`fcitx5`（输入法）、`nm-applet`（网络管理）。
