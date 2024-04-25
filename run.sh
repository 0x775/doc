#如果要确保可以下载，提高速度，如果有代-理，可以类似这样操作，
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890


echo "在MacOS上使用QEMU模拟Raspbian（Buster)"
echo "安装QEMU:"
echo "brew install qemu"
echo "下载 qemu-rpi-kernel:"

if [ ! -f "kernel-qemu-4.19.50-buster" ];then
    echo "镜像系统不存在,下载"
    wget https://raw.githubusercontent.com/dhruvvyas90/qemu-rpi-kernel/master/kernel-qemu-4.19.50-buster
    echo "下载 versatile-pb.dtb:"
    wget https://raw.githubusercontent.com/dhruvvyas90/qemu-rpi-kernel/master/versatile-pb.dtb

    echo "下载树莓派操作系统:"
    wget http://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2020-02-14/2020-02-13-raspbian-buster-lite.zip
    unzip 2020-02-13-raspbian-buster-lite.zip
fi

echo "运行QEMU模拟器"
qemu-system-arm -cpu arm1176 -m 256 \
  -kernel kernel-qemu-4.19.50-buster \
  -M versatilepb \
  -dtb versatile-pb.dtb \
  -no-reboot \
  -nographic \
  -append "dwc_otg.lpm_enable=0 root=/dev/sda2 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait" \
  -drive "file=2020-02-13-raspbian-buster-lite.img,index=0,media=disk,format=raw" \
  -net user,hostfwd=tcp::22223-:22 -net nic
echo "等待ssh登录屏幕出现…"


#然后输入用户名 pi 回车
#输入默认密码: raspberry 回车
#即可登录
