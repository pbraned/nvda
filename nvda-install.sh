VERSION="595.104.02"

# Install kernel headers
apt install -y linux-headers-$(uname -r)

# Blacklist Driver:
clear;
cat > /etc/modprobe.d/blacklist-nouveau.conf << EOF
blacklist nouveau
options nouveau modeset=0
EOF
update-initramfs -u;

# Unload Driver
modprobe -r nouveau;
lsmod | grep nouveau;

# Dependencies for Nvidia
apt install -y build-essential;
apt install -y pciutils;
apt install -y pve-headers;

# Download Drivers
## VERSION="570.153.02"
URL="https://us.download.nvidia.com/XFree86/Linux-x86_64/$VERSION/NVIDIA-Linux-x86_64-$VERSION.run"
wget --quiet $URL -O /tmp/NVIDIA-Linux-x86_64.run;

# Clean Driver
bash /tmp/NVIDIA-Linux-x86_64.run --uninstall --silent;
apt purge -y *nvidia*;
apt autoremove -y;

# Install Driver nvidia
bash /tmp/NVIDIA-Linux-x86_64.run --no-x-check --dkms;
# cat /var/log/nvidia-installer.log;

# Modules (Optional ?)
# if ! grep nvidia /etc/modules 1>/dev/null; then
# echo "nvidia-drm
# nvidia-uvm" >> /etc/modules;
# fi
# update-initramfs -u;

# Check Work
/usr/bin/nvidia-smi;
