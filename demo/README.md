## 快速开始

### 准备工作目录
```bash
# 克隆仓库
git clone -b axvuart https://github.com/ZhengQuancheng/axvisor.git
# 切换目录
cd axvisor
# 创建临时目录
mkdir -p tmp/{configs,images}
```

### 准备镜像及应用
```bash
# 创建 rootfs.img 镜像
dd if=/dev/zero of=tmp/images/rootfs.img bs=1M count=64 
mkfs.fat -F 32 tmp/images/rootfs.img

# 复制更新脚本及应用
cp demo/update_disk.sh tmp/images/
cp demo/bins/* tmp/images/
cd tmp/images/
# 更新应用至镜像
./update_disk.sh we-read.bin
./update_disk.sh we-send.bin
cd ../../
```

### 准备客户机配置文件
```bash
cp demo/configs/*.toml tmp/configs/
```

### 准备开发板配置文件
```bash
# 复制开发板配置文件
cp configs/board/qemu-aarch64.toml tmp/configs/
# 开启 fs 特性
sed -i 's/features = \[/&\n    "fs",/' tmp/configs/qemu-aarch64.toml
```

### 准备 QEMU 配置文件
```bash
# 复制 QEMU 配置文件
cp .github/workflows/qemu-aarch64.toml tmp/configs/qemu-aarch64-info.toml
# 获取 rootfs.img 的绝对路径
ROOTFS_PATH="$(pwd)/tmp/images/rootfs.img"
# 更新配置文件中的路径
sed -i 's|file=${workspaceFolder}/tmp/rootfs.img|file='"$ROOTFS_PATH"'|g' tmp/configs/qemu-aarch64-info.toml
# 将 success_regex 改为空数组
sed -i '/success_regex = \[/,/\]/c\success_regex = []' tmp/configs/qemu-aarch64-info.toml
# 验证修改
grep "rootfs.img" tmp/configs/qemu-aarch64-info.toml
```

### 运行 axvuart demo 测试
```bash
cargo xtask qemu --build-config tmp/configs/qemu-aarch64.toml --qemu-config tmp/configs/qemu-aarch64-info.toml --vmconfigs tmp/configs/axvuart-aarch64-qemu-1.toml --vmconfigs tmp/configs/axvuart-aarch64-qemu-2.toml
```
