# Raspberry PI Model B with Raspbian OS

## Install i2c-tools and activating drivers
```bash
sudo su  # you are now the root user. Be carefull.
apt-get update
apt-get install i2c-tools # install i2c-tools
usermod -aG i2c yourusername  # add yourself to the i2c group
echo -e "i2c-dev\ni2c-bcm2708" >> /etc/modules  # enable the i2c drivers
shutdown now # restart the Pi
```
[i2c-tools documenetation](http://www.lm-sensors.org/wiki/i2cToolsDocumentation)

```bash
i2cdetect -y 1
# 0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
# 00:          -- -- -- -- -- -- -- -- -- -- -- -- --
# 10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# 20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# 30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# 40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# 50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# 60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# 70: -- -- -- -- -- -- -- --

# yay! the i2c address table. (nothing is currently connected)
```

Confirm your board's revision:
```bash
cat /proc/cpuinfo
# Processor       : ARMv6-compatible processor rev 7 (v6l)
# BogoMIPS        : 697.95
# Features        : swp half thumb fastmult vfp edsp java tls
# CPU implementer : 0x41
# CPU architecture: 7
# CPU variant     : 0x0
# CPU part        : 0xb76
# CPU revision    : 7
#
# Hardware        : BCM2708
# Revision        : 000e
# Serial          : 000000008ac3c8eb
```
Revision > `0003` is a revision 2 board.  Mine says `000e`, so it's a rev2.  (there's no rev3 as of this writing)

## Diagram of the GPIO and Ribbon Cable Pinouts
The Raspberry PI and Ribbon Cable
```
 video   GPIO     | <-- SD Card
 |         |      |
 |         V      |
 V   ............. <- GPIO Pin 1 (3.3v)
| |--.............
|_|
     ||||||||||||| <- Red wire
     |||||||||||||
     |||||||||||||
     |||||||||||||

     ______n______
    |.............| <- GPIO Pin 1
    |.............|
```

Connecting the Accelerometer to the Ribbon Cable
```
     (MMA8452 Breakout Board)
          __________
          |SDA--|  |
          |SCL-||  |
          |    ||  |
          |____VV__|
       GND->|  |||<- 3.3V
             \ |||
     ______n_|_|||
    |.............| <- GPIO Pin 1
    |.............|
```

Check i2cdetect for the accelerometers address
```
i2cdetect -y 1
#      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
# 00:          -- -- -- -- -- -- -- -- -- -- -- -- --
# 10: -- -- -- -- -- -- -- -- -- -- -- -- -- 1d -- --
# 20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# 30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# 40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# 50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# 60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# 70: -- -- -- -- -- -- -- --

# Now we see that the accelerometer is at address 0x1D.
```
[Accelerometer Datasheet](http://www.freescale.com/files/sensors/doc/data_sheet/MMA8452Q.pdf)


