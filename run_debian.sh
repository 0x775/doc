#如果要确保可以下载，提高速度，如果有代-理，可以类似这样操作，
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890


echo "QEMU运行arm环境脚本"
echo "先安装QEMU"
echo "brew install qemu"
echo "下载kernel:"
echo "更多镜像: https://cloud.debian.org/images/cloud"

if [ ! -e "debian-11-arm64.qcow2" ];then
    echo "镜像系统不存在,下载"
    wget https://cloud.debian.org/images/cloud/bullseye/20240211-1654/debian-11-generic-arm64-20240211-1654.qcow2
    echo "下载 QEMU_EFI:"
    wget http://ftp.br.debian.org/debian/pool/main/e/edk2/qemu-efi-aarch64_0~20181115.85588389-3+deb10u2_all.deb
	dpkg -X *.deb ./ && cp ./usr/share/qemu-efi-aarch64/QEMU_EFI.fd .
	
	mv debian-11-generic-arm64-20240211-1654.qcow2 debian-11-arm64.qcow2
	
    echo "修改root密码为 root"
	sudo apt-get install -y libguestfs-tools
	virt-customize -a debian-11-arm64.qcow2 --root-password password:root
	
	echo "磁盘扩容:"
	qemu-img resize debian-11-arm64.qcow2 +8G
fi

echo "运行QEMU模拟器"
qemu-system-aarch64 \
    -M virt -m 4G -cpu cortex-a72 -smp 2 \
    -bios QEMU_EFI.fd \
    -drive id=hd0,media=disk,if=none,file=debian-11-arm64.qcow2 \
    -device virtio-scsi-pci \
    -device scsi-hd,drive=hd0 \
    -nic user,model=virtio-net-pci,hostfwd=tcp::2222-:22,hostfwd=tcp::8000-:80,hostfwd=tcp::9090-:9090,hostfwd=tcp::9000-:9000 \
    -nographic
echo "等待ssh登录屏幕出现…"


#然后输入用户名 root 回车
#输入默认密码: root 回车
#即可登录


#安装GUI
<<注释
sudo apt update
sudo apt upgrade
sudo apt install -y lxqt lightdm

启动带GUI的系统
qemu-system-aarch64 \
    -M virt -m 4G -cpu cortex-a72 -smp 2 \
    -bios QEMU_EFI.fd \
    -drive id=hd0,media=disk,if=none,file=debian-11-arm64.qcow2 \
    -device virtio-scsi-pci \
    -device scsi-hd,drive=hd0 \
    -device ramfb \
    -device qemu-xhci,id=xhci \
    -device usb-kbd -device usb-tablet -k en-us \
    -nic user,model=virtio-net-pci,hostfwd=tcp::2222-:22,hostfwd=tcp::8000-:80,hostfwd=tcp::9090-:9090,hostfwd=tcp::9000-:9000

注释
