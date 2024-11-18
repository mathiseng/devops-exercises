
# To write everything into terminal log https://www.vdr-portal.de/forum/index.php?thread/130362-logging-in-datei-und-denoch-ausgabe-auf-der-konsole-ohne-neben-jedem-befehl-tee/
# and show executed commands https://stackoverflow.com/questions/2853803/how-to-echo-shell-commands-as-they-are-executed
exec > >(tee -i terminal.log) 2>&1
set -x
#cloud init config generation from here https://blog.oddbit.com/post/2015-03-10-booting-cloud-images-with-libv/
# used mkisofs to merge the data files https://stackoverflow.com/questions/76060464/genisoimage-in-cywin-error-genisoimage-i-option-no-longer-supported
CONFIG="./seed.iso"
if [ ! -f "$CONFIG" ]; then
   echo "Creating new config for ssh"
   mkisofs -output seed.iso -volid cidata -joliet -rock ./cloud-init/user-data ./cloud-init/meta-data
fi


# Start VM
# For port forwarding i needed https://wiki.qemu.org/Documentation/Networking
# For further execution of the script i needed the vm to start in a different process otherwise it would block the terminal https://superuser.com/questions/513496/how-can-i-run-a-command-from-the-terminal-without-blocking-it
echo "Starting the VM..."
nohup qemu-system-x86_64 \
  -m 20G \
  -smp 4 \
  -hda ./ubuntu-22.04-server-cloudimg-amd64.img \
  -cdrom ./seed.iso \
  -netdev user,id=n1,hostfwd=tcp::2222-:22 \
  -device virtio-net-pci,netdev=n1 \
  > vm.log 2>&1 &

echo "Waiting for the VM to boot..."
sleep 50

echo "Deploying application in the VM..."
bash deploy.sh