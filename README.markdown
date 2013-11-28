# Raspberry PI Model B with Raspbian OS

```bash
sudo su  # you are now the root user. Be carefull.
apt-get update
apt-get install i2c-tools # install i2c-tools
usermod -aG i2c yourusername  # add yourself to the i2c group
echo -e "i2c-dev\ni2c-bcm2708" >> /etc/modules  # enable the i2c drivers
exit # logout the root user
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

Confirm your boards revision:

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
```
 video   GPIO     | <-- SD Card
 |         |      |
 |         V      |
 V   ............. <- GPIO Pin 1
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
