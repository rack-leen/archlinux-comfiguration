#=======================================================
# 配置archlinux
# archlinux-comfiguration需要下载到用户home目录
#=======================================================

echo "-------------------------------------------------------"
echo " 确认是否为archlinux系发行版"
echo "-------------------------------------------------------"
if which pacman > /dev/null ; then
    echo "该linux发行版是archlinux..."
else
    echo "这个配置文件不适合这个发行版！,将退出安装..."
    exit 
fi 

echo "开始配置archlinux"

echo "-------------------------------------------------------"
echo "1 实用配置"
echo "-------------------------------------------------------"
echo "a 开始dns配置..."
sudo cp ./pacman/resolv.conf /etc/resolv.conf  
sudo chattr +a /etc/resolv.conf #追加权限，重新开机时不用重新修改
echo "dns配置结束..."

sudo pacman -S git -y
echo "b 开始下载配置文件..."
git clone https://github.com/rack-leen/archlinux-comfiguration.git ~/
echo "下载结束..."

echo "c 开始archlinux源配置..."
sudo mv /etc/pacman.d /etc/pacman.d.backup
sudo rm -r /etc/pacman.d 
sudo cp -r ./pacman/pacman.d /etc/pacman.d  
sudo mv /etc/pacman.conf /etc/pacman.conf.backup 
sudo rm -r /etc/pacman.conf 
sudo cp -r ./pacman/pacman.conf /etc/pacman.conf 
sudo pacman -y -S yaourt archlinuxcn-keyring   #下载archlinuxcn密钥
sudo pacman -y -Syyu  #更新系统
echo "archlinux源配置结束..."

echo "d 设置字体"
sudo cp -r ~/archlinux-comfiguration/myfonts  /usr/share/fonts/
sudo pacman -y -S adobe-source-code-pro-fonts wqy-bitmapfont wqy-microhei wqy-zenhei
echo "设置结束..."

echo " e 设置声卡"
sudo cp -r ~/archlinux-comfiguration/alsamixer/asound.conf /etc/ 
echo "设置结束..."

echo "urxvt配置"
touch ~/.Xresources
echo "xft.dpi:125 #设置dpi，对4k高分屏需要设置，设置成默认值的2倍试试。" >> ~/.Xresources
echo "URxvt.font: xft:Source Code Pro:antialias=True:pixelsize=18,xft:WenQuanYi Zen Hei:pixelsize=18" >> ~/.Xresources
echo "URxvt.boldfont: xft:Source Code Pro:antialias=True:pixelsize=18,xft:WenQuanYi Zen Hei:pixelsize=18" >> ~/.Xresources
echo "urxvt配置结束..."

echo "f 配置中文输入"
sudo pacman -y -S fcitx fcitx-configtool fcitx-googlepinyin fcitx-sogoupinyin
sed -i "4i #fcitx" ~/.xprofile
sed -i "5i export GTK_IM_MODULE=fcitx" ~/.xprofile
sed -i "6i export QT_IM_MODULE=fcitx" ~/.xprofile
sed -i "7i export XMODIFIERS=@im=fcitx" ~/.xprofile
sed -i "8i fcitx &" ~/.xprofile
echo "配置结束..."

echo "-------------------------------------------------------"
echo " 2 安装常用软件"
echo "-------------------------------------------------------"

echo " a 安装编译工具链"
sudo pacman -y -S cmake make gcc gdb autoconf
echo "安装结束..."

echo " b 安装各个语言解释器"
sudo pacman -y -S perl ruby lua 
echo "安装结束..."

echo " c 安装常用工具"
sudo pacman -y -S axel vim curl wget links netease-cloud-music mplayer
echo "安装结束..."

echo " d 安装命令行版musicbox"
sudo pacman -y -S python-pip python-setuptools python2-pip python2-setuptools mpg123
cd ~/
git clone https://github.com/darknessomi/musicbox.git
cd ./musicbox 
sudo python setup.py install
cd ~/
sudo rm -r musicbox 
echo "安装结束..."

echo " e 安装flash"
cp -r ~/archlinux-comfiguration/flash/flash ~/ 
mkdir -p ~/.mozilla/plugin
cp -r ~/archlinux-comfiguration/flash/libflashplayer.so 
echo "安装结束..."

echo "f 安装常用软件"
sudo pacman -y -S firefox firefox-i18n-zh-cn
sudo pacman -y -S pycharm
sudo pacman -y -S google-chrome
sudo pacman -y -S wps-office
sudo pacman -y -S libreoffice
sudo pacman -y -S atom wiznote kodi rhythmbox
sudo pacman -y -S gedit netease-cloud-music
echo "安装结束..."

echo "g 安装oh-my-zsh"
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
echo "安装结束..."

echo "-------------------------------------------------------"
echo " 2 vim配置"
echo "-------------------------------------------------------"
#echo "a 下载vim配置文件"
#cd ~/
#git clone https://github.com/rack-leen/vim.git
#mv vim ~/.vim 
#cp ~/.vim/vimrc ~/.vimrc 
#touch ~/1
#echo "vim安装正在进行，请耐心等候... " > ~/1
#vim 1 -c "PluginInstall" -c "q" 
#rm 1 
echo "a 安装vim发行版spf13-vim"
curl https://j.mp/spf13-vim3 -L > spf13-vim.sh && sh spf13-vim.sh
echo "个性化配置spf13-vim"

echo "b 安装youcompleteme插件"
echo "安装youcompleteme"
sudo pacman -y -S vim-youcompleteme-git 
echo "安装clang编译器"
sudo pacman -y -S clang extra/boost  
echo "编译"
mkdir ~/ycm_build
cd ./ycm_build
sudo cmake -G "Unix Mkaefiles" -DEXTERNAL_LIBCLANG_PATH=/usr/lib/libclang.so  ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp 
sudo cmake --build . --target ycm_core --config Release
cp ~/archlinux-configuration/.ycm_extra_conf.py ~/.vim
sudo rm -r ~/ycm_build
echo "安装完成..."


echo "thank you"

