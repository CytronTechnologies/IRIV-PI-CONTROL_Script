# Setting Up IRIV PiControl #
We recommend to setup the IRIV PiControl with:
1. Load the latest Raspberry Pi OS into the CM4 EMMC.
2. Create an empty "ssh" file on /boot to enable ssh.
3. Copy the userconf.txt file to /boot. This is to set the default username to "pi" and password to "raspberry".
4. Boot up the IRIV PiControl, SSH into it and run the setup script using this command:
```
curl -L tinyurl.com/setup-iriv-pi-control | sudo bash
```

**What the setup script does?**
- Added the following settings in /boot/config.txt
  - Disable USB OTG and enable the USB Host.
  - Enable I2C and RTC.
  - Changed the WiFi/Bluetooth antenna to external antenna
- Setup a script to run in the background to:
  - Display the IP address and system informations on the OLED.
  - Monitor the state of the power button. Shutdown the Pi safely when the button is pressed.
