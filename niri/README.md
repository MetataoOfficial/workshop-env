# Niri WM Keybindings

The keybindings are designed around three spatial layers:

- H / L : Columns (left / right)
- J / K : Workspaces (up / down)
- N / I / O / U : Monitors (left / up / down / right)

History navigation:

- S : Previous window
- A : Previous workspace

Workspace anchors:

- Y : First workspace
- G : Bottom (scratch) workspace

Applications:

- T : Terminal
- W : Web
- E : Editor
- F : File manager
- D : Document (PDF)
- X : Launcher

## 1. Navigation

### Column Navigation

| Key           | Action                |
| ------------- | --------------------- |
| `Mod + H / ←` | Focus left column     |
| `Mod + L / →` | Focus right column    |
| `Mod + Home`  | Focus first column    |
| `Mod + End`   | Focus last column     |
| `Mod + M`     | Center current column |

### Workspace Navigation

| Key              | Action                                           |
| ---------------- | ------------------------------------------------ |
| `Mod + J / ↓`    | Focus next window/workspace                      |
| `Mod + K / ↑`    | Focus previous window/workspace                  |
| `Mod + PageDown` | Next workspace                                   |
| `Mod + PageUp`   | Previous workspace                               |
| `Mod + Y`        | Jump to workspace 1                              |
| `Mod + G`        | Jump to workspace 9 (bottom / scratch workspace) |
| `Mod + A`        | Return to previous workspace                     |

### Window History

| Key                 | Action                             |
| ------------------- | ---------------------------------- |
| `Mod + S`           | Return to previous focused window  |
| `Mod + Tab`         | Recent windows (current workspace) |
| `Mod + Shift + Tab` | Recent windows (reverse)           |
| `Alt + Tab`         | Recent windows (global)            |
| `Alt + Shift + Tab` | Recent windows (global reverse)    |
| `Alt + Grave`       | Cycle windows of same application  |
| `Mod + Grave`       | Overview                           |

---

# 2. Workspace Management

| Key                 | Action                            |
| ------------------- | --------------------------------- |
| `Mod + 1…5`         | Focus workspace                   |
| `Mod + Shift + 1…5` | Move column to workspace          |
| `Mod + Shift + J/K` | Move column to adjacent workspace |
| `Mod + Shift + Y`   | Move column to workspace 1        |
| `Mod + Shift + G`   | Move column to workspace 9        |

---

# 3. Window Management

| Key                  | Action                     |
| -------------------- | -------------------------- |
| `Mod + Shift + C`    | Close window               |
| `Mod + Mouse Middle` | Close window               |
| `Mod + Z`            | Maximize column            |
| `Mod + V`            | Cycle preset column widths |
| `Mod + Shift + H/L`  | Consume / Expel window     |
| `Mod + [` `]`        | Resize column              |
| `Mod + - / =`        | Resize window height       |

---

# 4. Applications

| Key                     | Application  |
| ----------------------- | ------------ |
| `Mod + Return` / `T`    | Ghostty      |
| `Mod + Space` / `W`     | Firefox      |
| `Mod + Esc` / `E`       | Neovide      |
| `Mod + Backspace` / `F` | Nemo         |
| `Mod + D`               | Zathura      |
| `Mod + X`               | App Launcher |

---

# 5. Multi-monitor

### Focus monitor

| Key                 | Action                   |
| ------------------- | ------------------------ |
| `Mod + N I O U`     | Left / Up / Down / Right |
| `Mod + Ctrl + ←↑↓→` | Same actions             |

### Move column

| Key                         | Action      |
| --------------------------- | ----------- |
| `Mod + Shift + N I O U`     | Move column |
| `Mod + Shift + Ctrl + ←↑↓→` | Move column |

---

# 6. System

| Key                      | Action                           |
| ------------------------ | -------------------------------- |
| `Print`                  | Screenshot                       |
| `Ctrl + Print`           | Screenshot current monitor       |
| `Alt + Print`            | Screenshot current window        |
| `XF86Audio*`             | Volume                           |
| `XF86Brightness*`        | Brightness                       |
| `Mod + P`                | Hotkey overlay                   |
| `Mod + Ctrl + B`         | Lock screen & power off monitors |
| `Mod + Ctrl + Shift + B` | Suspend                          |
| `Mod + Ctrl + R`         | Reload config                    |
| `Mod + Ctrl + Q`         | Quit Niri                        |

---

## Scratch Workspace

Workspace **9** is reserved as a temporary workspace.

```
Mod + G
```

Jump to the bottom workspace.

```
Mod + Shift + G
```

Move the current column there.

This behaves similarly to a scratchpad while remaining fully compatible with Niri's dynamic workspace model.

