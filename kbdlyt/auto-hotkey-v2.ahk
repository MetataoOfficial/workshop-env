#Requires AutoHotkey v2.0
#SingleInstance Force

; =============================================================================
;                         CELL Layout (Windows v2 版)
; =============================================================================

; --- 字母区重排 (使用 ScanCode 确保硬件层稳定性) ---
; 第一排
sc012::d
sc013::f
sc014::sc027 ; 映射为分号 (QWERTY的;键位代码是sc027)
sc015::/
sc016::y
sc017::g
sc018::r
sc019::p

; 第二排 (Home Row)
sc020::e
sc021::t
sc022::,
sc023::.
sc024::n
sc025::i
sc026::o
sc027::u

; 第三排
sc031::m
sc032::h
sc033::j
sc034::k
sc035::l

; --- 功能键映射 ---
; CapsLock -> Escape
sc03a::Esc
; RightShift -> Backspace
RShift::BackSpace

; --- 窗口置顶功能 (v2 语法升级) ---
^`:: {
    activeWin := WinExist("A")
    if activeWin {
        ; 切换置顶状态
        ExStyle := WinGetExStyle(activeWin)
        if (ExStyle & 0x8) ; 0x8 是 WS_EX_TOPMOST
            WinSetAlwaysOnTop 0, activeWin
        else
            WinSetAlwaysOnTop 1, activeWin
    }
}
