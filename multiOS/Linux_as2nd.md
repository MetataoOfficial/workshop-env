# 2025-5-20 前夜 草记

- 安装配置好Manjaro后, 发现两个系统会分散精力 -- 至少要选择每次启动哪个系统. 于是决定:
- **平时只以一个系统为主(Linux), 另一个(Win)只为备用.**

几天没留神, 那个天天想给用户当爹的微软, 最近在PC机的双系统启动上, 又贱呲呲地搞了许多的小动作.

下面就是怎样Fuck他, 实现Windows / Linux双系统启动 (以当下新版的 ThinkPad - Manjaro 为例):

### 1. 前期设置(重要提醒: 依次进行):
1. 禁用Windows的BitLocker

2. 进入BIOS设置(\[Enter\] F1):
   1) 设置BIOS模式为UEFI (而不是Legacy; 当下新机默认就是UEFI, 不再兼任传统选项)
   2) 将Secure Boot设置为Disabled(重要! 安装前必须)
   3) 在Secure Boot相关设置中, 打开Allow Microsoft 3rd party UEFI CA
   4) Controller Mode选择AHCI(而不是Intel RST; 当下版本, 无此选项, 不需设置)

3. **Note** 关于如何进入BIOS设置, 当下Thinkpad的BIOS中有Boot Mode选项:
- 默认为Quick(快速启动), 这种模式下, 要进入BIOS设置, 需先按Enter然后再按F1
- 还有一种Diagnose(诊断启动), 这种模式下, 开机自检时, 按F1就可以直接进入BIOS(个人喜欢这种方式)

### 2. 媒介准备
1. 在Windows任务栏Start Flag上, 右击鼠标, 选择`磁盘管理`, 打开磁盘管理器
2. 调整硬盘分区, 留出足够大的空间给Linux
   - 新机默认C/D两个盘, 可以把C留给Win, 把D给Linux就好, 这样就不用调整了;
   - 为了避免后面安装Linux时选错, 可以考虑给D格式化为新文件系统(比如, exfat)
3. 下载Manjaro镜像和Rufus备用
4. 插入优盘, 并使用Rufus将Manjaro镜像写入优盘中

### 3. 安装工作
1. 将写好的优盘插入电脑, 重启并按F12, 进入Boot Menu -> 选择从优盘启动
2. 启动后, 在运行的界面中, 选择安装程序, 进入安装过程
3. 按照提示, 照实选择即可逐步安装, 除了在`选择存储器`时需要特别小心地进行设置(不能使用默认值!)
   1) 要用`取代一个分区`的方式, 而不是默认的`抹除磁盘`(后者会将整个磁盘全部擦除! 整个硬盘将只剩下Linux系统了!)
   2) 关于文件系统的选择, Manjaro居然默认选btrfs了! 不确定是否够稳定, 自己手动选了ext4 (事实上, 第二选择也是xfs, 而btrfs在滚挂恢复时的优势很明显)
   3) 还需要仔细地`选择要安装到的分区`(选择Windows中D盘的分区; 可根据前面格式化的文件系统类型, 并参考分区的前后位置确定)

### 4. 后续工作
安装Manjaro后, 重启时会自动出现启动菜单, 可以选择启动到不同的系统.
进入Manjaro时会发现, 即使是朴素的xfce, 现在的界面也提升了很多, 甚至可以谈优雅和审美了.
然而, 这里还有一系列的后续工作要做, 最主要的就是:
1. 换源 `sudo pacman-mirrors --fasttrack`
2. 更新 `sudo pacman -Syu`
3. 启用对 `Snap` (和 `Flatpak`? 不要`AUR`!!) 的支持 (开启Flatpak, 也会有杂七杂八的问题):
```
sudo pacman -S snapd
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
```
4. 启用 TRIM (4SSD) `sudo systemctl enable fstrim.timer`
5. 安装中文输入法
   - `Manjaro Hello` -> `Applications` -> `Extended language support` -> 选择`fcitx`或`ibus` -> `update system`
   - 下载安装完成后, 会返回`fcitx/ibus选择界面`, 重启电脑即可使用
   - 设置为自动启动, 也可以手工运行`fcitx-autostart`启动
   - 设置所选输入法, 主要是zsc -> zhshch等模糊音加上
6. 现在xfce的sh改为zsh了, 比bash确实强不少, 但还是不如fish顺手: `sudo chsh -s /usr/bin/fish [my_user_name]`
7. git配置
```
git config --global user.name "---"
git config --global user.email "---"
# git config --global http.emptyAuth true
```
8. 使用本地时间: `sudo timedatectl set-local-rtc true` # 避免两个系统打架(甚至会影响v2ry)
9. 安装其他必要的软件
```
  fish at amule mpv neovim xfce4-goodies catfish awk xclip emacs synapse ripgrep persepolis fd
  i3-wm i3blocks i3lock # i3-scripts i3-wallpaper i3-default-artwork # manjaro-i3-settings, artwork-i3: conflict! (后面几个都没用, 删)
  xss-lock rofi xorg-xrandr nitrogen volumeicon brightnessctl # clipit dunst
  wqy-zenhei wqy-microhei noto-fonts-cjk ttf-droid ttf-hack ttf-fira-code fortune-mod
  # texlive-core texlive-latexextra texlive-langchinese
 ```
10. 配置keyboard layout: add `xmodmap ~/.Xmodmap` to file `~/.bashrc` or to `zsh/fish/xprofile` etc.
11. 安装Miniconda
    - 从[Miniconda清华源](https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/), 下载`Miniconda3-py310_最新日期-Linux-x86_64.sh` (没选择3.13等更高版本, 是考虑到与pytorch一系列包的兼容问题), `sh Miniconda3-py310*.sh`安装
    - 更新pip源: `python -m pip install --upgrade pip; pip config set global.index-url https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple`
    - 更新conda的源: `~/.condarc`
    - 配置init.py, 安装需要的库(pytorch torchvision torchaudio...)
12. 安装gcc: `sudo pacman -S git gcc gcc-libs make cmake gdb`
13. Fuck GFW:
    - 下载`v2rayN-linux-64.AppImage`, from https://github.com/2dust/v2rayn/releases?after=latest
    - 设置权限并运行, 然后在主界面添加配置
14. 调整分辨率`xrandr --output eDP-1 --mode 1920x1200 --rate 60`, 和桌面背景(xfce中, 一小时换一次)
15. 安装打印机
```
sudo pacman -S manjaro-printer
sudo snap install hplip-printer-app
```
16. 开发(尤其是`嵌入式`):
    - `sudo pacman -S --needed flex bison gperf ninja ccache dfu-util libusb # python python-pip`
    - `sudo pacman -S sdl2 curl mosquitto base-devel`
    - `sudo snap install code --classic`
    - 在vscode中, 安装插件: `ESP-IDF`, `platformIO IDE`, `vim`, `python`, `c/c++`
    - `arduino IDE`(snap)可以考虑安装, 但没必要
17. 安卓 wear os等相关开发?
18. 可以从xfce4-setting-manager中, 参考xfce启动时加载了什么；可以从manjaro-setting-manager中, 改换内核
19. 安装kotlin/java:
    - `sudo pacman -Syu jdk-openjdk` (当下最新版本是24),
    - `java -version; javac -version`
    - `sudo pacman -Syu kotlin`
20. 安装android-studio:
        ```bash
        sudo snap install android-studio --classic
        sudo pacman -Syu qemu-full # for kvm -- 加速模式
        sudo usermod -aG kvm $USER
        ```
