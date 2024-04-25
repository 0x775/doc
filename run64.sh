#如果要确保可以下载，提高速度，如果有代-理，可以类似这样操作，
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890


echo "在MacOS上使用QEMU模拟Raspbian（Buster)"
echo "安装QEMU:"
echo "brew install qemu"
echo "下载 qemu-rpi-kernel:"

if [ ! -e "kernel8.img" ];then
    echo "镜像系统不存在,下载"
    wget https://raw.githubusercontent.com/dhruvvyas90/qemu-rpi-kernel/master/native-emulation/5.4.51%20kernels/kernel8.img
    echo "下载 versatile-pb.dtb:"
    wget https://raw.githubusercontent.com/dhruvvyas90/qemu-rpi-kernel/master/native-emulation/dtbs/bcm2710-rpi-3-b-plus.dtb

    echo "下载树莓派操作系统:"
    wget http://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2021-11-08/2021-10-30-raspios-bullseye-armhf-lite.zip
    unzip 2021-10-30-raspios-bullseye-armhf-lite.zip
	qemu-img resize -f raw "2021-10-30-raspios-bullseye-armhf-lite.img" 2G
fi

echo "运行QEMU模拟器"
qemu-system-aarch64 \
    -m 1G \
    -M raspi3b \
    -smp 4 \
    -usb \
    -device usb-mouse \
    -device usb-kbd \
    -device 'usb-net,netdev=net0' \
    -netdev 'user,id=net0,hostfwd=tcp::5022-:22' \
    -drive "file=2021-10-30-raspios-bullseye-armhf-lite.img,index=0,format=raw" \
    -dtb "bcm2710-rpi-3-b-plus.dtb" \
    -kernel "kernel8.img" \
    -append 'rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootdelay=1' \
    -no-reboot \
    -nographic
echo "等待ssh登录屏幕出现…"


#然后输入用户名 pi 回车
#输入默认密码: raspberry 回车
#即可登录
