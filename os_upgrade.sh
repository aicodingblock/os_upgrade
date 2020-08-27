#! /bin/bash
# /etc/init.d/aimakers 

### BEGIN INIT INFO
# Provides:          AI Coding Pack
# Writer:	     PHJ
# Date:              2020.08
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Simple script to start a program at boot
# Description:       A simple script from www.stuffaboutcode.com which will start / stop a program a boot / shutdown.
### END INIT INFO

# If you want a command to always run, put it here
# Carry out specific functions when asked to by the system

#DISCLAIMER
temp_step="step1"
INSTALL_STEP=$temp_step
#echo $INSTALL_STEP

#Function Define
##Make os_upgrade service file...

echo $INSTALL_STEP
if [[ "$INSTALL_STEP" = "step1" ]]; then
	echo "start step1" > check_step.txt;
	
	if [[ -d /home/pi/os_upgrade ]]; then
		echo "OS Upgrade Folder already existed...";
	else
		echo "Create OS Upgrade Folder";
		mkdir /home/pi/os_upgrade;
	fi
	sudo chmod +x os_upgrade.sh
	cp os_upgrade.sh /home/pi/os_upgrade

	lxterminal --title="AMK OS Upgrade Step1" -e bash -c "cd /home/pi/os_upgrade/;
	#git check
	git clone https://github.com/aicodingblock/OS.git;
	cp ./OS/autostart /home/pi/.config/lxsession/LXDE-pi/ && cp ./OS/version.info /home/pi/;
	sudo cp ./OS/sources.list /etc/apt/sources.list
	#dir check
	sudo mkdir /lib/modules/4.19.127-v7;
	sudo cp -r ./OS/rootfs/4.19.127-v7/* /lib/modules/4.19.127-v7/;
	sudo chmod -R +x ./OS/boot/*;
	sudo cp -r ./OS/boot/* /boot/;
	sed -i 's/temp_step=\"step1\"/temp_step=\"step2\"/' os_upgrade.sh;
	echo '@lxterminal -e bash /home/pi/os_upgrade/os_upgrade.sh' >> /home/pi/.config/lxsession/LXDE-pi/autostart;
	sudo reboot;
	bash"	
elif [[ "$INSTALL_STEP" = "step2" ]]; then
	lxterminal --title="AMK OS Upgrade Step2" -e bash -c "cd /home/pi/os_upgrade/;	
	echo 'start step2' >> check_step.txt;
	sudo apt-get update;
	sudo apt autoremove -y;
	sudo apt-get install bc -y;
	sudo apt-get install libncurses5-dev -y;
	echo 'my_loader' | sudo tee --append /etc/modules > /dev/null;
	sudo depmod -a;
	sudo modprobe my_loader;
	sed -i 's/temp_step=\"step2\"/temp_step=\"step3\"/' os_upgrade.sh;
	sudo reboot;
	bash;"
elif [[ "$INSTALL_STEP" = "step3" ]];  then
	lxterminal --title="AMK OS Upgrade Step3" -e bash -c "cd /home/pi/os_upgrade/;	
	echo 'start step3' >> check_step.txt;
	sudo apt-get install chromium-browser --yes;
	sudo pip3 install asyncio;
	sudo pip3 install bluepy;
	mkdir /home/pi/os_upgrade/temp;
	cd temp/;
	git clone https://github.com/aicodingblock/codingblock.git;
	cd ./codingblock && cp ./Desktop/serial.desktop /home/pi/Desktop && cp ./Desktop/aicodingpack.png /home/pi/Pictures/ ;
	cp ./Desktop/desktop-items-0.conf /home/pi/.config/pcmanfm/LXDE-pi/ ;
	cp -r ./autorun/py_script/* /home/pi/autorun/py_script/;
	cp -r ./blockcoding/* /home/pi/blockcoding/kt_ai_makers_kit_block_coding_driver/blockDriver/;
	mkdir /home/pi/.aicodingblock && mkdir /home/pi/.aicodingblock/bin && cp -r ./aicodingblock/* /home/pi/.aicodingblock/bin;
	sudo cp ./system_service/*  /lib/systemd/system;
	sed -i 's/temp_step=\"step3\"/temp_step=\"step4\"/' /home/pi/os_upgrade/os_upgrade.sh;
	sudo reboot;
	bash"
elif [[ "$INSTALL_STEP" = "step4" ]];  then
	lxterminal --title="AMK OS Upgrade Step4" -e bash -c "cd /home/pi/os_upgrade/;	
	echo 'start step4' >> check_step.txt;
	sed -i 's/@lxterminal -e bash \/home\/pi\/os_upgrade\/os_upgrade.sh/ /' /home/pi/.config/lxsession/LXDE-pi/autostart;
	sudo systemctl enable aimk_auto.service
	sudo systemctl start aimk_auto.service
	echo 'OS Upgrade Complete';
	aplay /home/pi/os_upgrade/temp/codingblock/complete.wav;
	sleep 3;
	cd /home/pi/ && sudo rm -r /home/pi/os_upgrade;
	cat /home/pi/version.info;
	bash;"
fi
