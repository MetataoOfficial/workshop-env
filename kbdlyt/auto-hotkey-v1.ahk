;SC010::q
;SC011::w
SC012::d
SC013::f
SC014::;
SC015::/
SC016::y
SC017::g
SC018::r
SC019::p

;SC01E::a
;SC01F::s
SC020::e
SC021::t
SC022::,
SC023::.
SC024::n
SC025::i
SC026::o
SC027::u

;SC02c::z
;SC02d::x
;SC02e::c
;SC02f::v
;SC030::b
SC031::m
SC032::h
SC033::j
SC034::k
SC035::l

; 将左边的CapsLock设置为Escape
sc03a::escape
; 将右边的Shift设置为Backspace
RShift::backspace

^`::  ; Ctrl + `: 切换窗口的置顶状态
WinGetActiveTitle, ActiveWindow
WinSet, AlwaysOnTop, Toggle, %ActiveWindow%
return
