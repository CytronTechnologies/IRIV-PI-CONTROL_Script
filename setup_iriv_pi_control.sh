#!/bin/bash

# Make sure the script is run as root.
if [ $(id -u) -ne 0 ]; then
    echo
    echo
    echo "Please run as root."
    exit 1
fi


# create folder for scripts.
cd /usr/local/bin
sudo mkdir iriv_pi_control
cd iriv_pi_control

# Install Adafruit SSD1306 OLED python library.
git clone https://github.com/adafruit/Adafruit_Python_SSD1306.git
cd Adafruit_Python_SSD1306
python setup.py install
cd ..

# Download script.
curl -LO https://raw.githubusercontent.com/CytronTechnologies/IRIV-PI-CONTROL_Script/main/background_script.py

# Add the command to run the script to rc.local if it's not there yet.
rc_file="/etc/rc.local"
grep "iriv_pi_control" $rc_file >/dev/null
if [ $? -ne 0 ]; then
    # Insert into rc.local before final 'exit 0'
    sed -i "s/^exit 0/sudo python \/usr\/local\/bin\/iriv_pi_control\/background_script.py \&\nexit 0/g" $rc_file
fi



# Configure the config.txt file.
config_file="/boot/config.txt"

# Disable USB OTG.
grep "#otg_mode=1" $config_file >/dev/null
if [ $? -ne 0 ]; then
    sed -i "s/^otg_mode=1/#otg_mode=1/g" $config_file
fi

# Enable USB host.
grep "dtoverlay=dwc2,dr_mode=host" $config_file >/dev/null
if [ $? -ne 0 ]; then
    echo "dtoverlay=dwc2,dr_mode=host" >> $config_file
fi

#Enable I2C1.
grep "dtparam=i2c_arm=on" $config_file >/dev/null
if [ $? -ne 0 ]; then
    echo "dtparam=i2c_arm=on" >> $config_file
else
    grep "#dtparam=i2c_arm=on" $config_file >/dev/null
    if [ $? -eq 0 ]; then
        sed -i "s/^#dtparam=i2c_arm=on/dtparam=i2c_arm=on/g" $config_file
    fi
fi

# Enable I2C0 for RTC.
grep "dtparam=i2c_vc=on" $config_file >/dev/null
if [ $? -ne 0 ]; then
    echo "dtparam=i2c_vc=on" >> $config_file
    echo "dtoverlay=i2c-rtc,pcf85063a,i2c_csi_dsi" >> $config_file
fi

# Change to external antenna.
grep "dtparam=ant2" $config_file >/dev/null
if [ $? -ne 0 ]; then
    echo "dtparam=ant2" >> $config_file
fi

echo
echo
echo "######################################"
echo "Cytron IRIV PiControl Setup Completed"
echo "######################################"
echo
echo "Please reboot for the changes to take effect."
