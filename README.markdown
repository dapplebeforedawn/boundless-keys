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

## Connecting the Accelerometer to the Ribbon Cable
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
[Accelerometer Application Notes](http://www.artekit.eu/resources/ak-mma8452/doc/AN4076.pdf)


## Installing NodeJs (with NVM)
```bash
sudo apt-get install build-essential
sudo apt-get install libssl-dev
sudo apt-get npm
curl https://raw.github.com/creationix/nvm/master/install.sh | sh
# close and re-open terminals
nvm ls-remote
nvm install <a recent one from ls-remote>
sodu npm install -g coffee-script  # optional, but these the code here is coffeescript
```

## Dealing with repeated starts and the BCM2835 GPIO chip
[BCM2835 clang library](http://www.airspayce.com/mikem/bcm2835/index.html) is used to read higher order registers on the MMA8452Q, and to write the needed setup registers
```
# make/install the bcm2835 library
cd ~/
wget http://www.airspayce.com/mikem/bcm2835/bcm2835-1.33.tar.gz
tar zxvf bcm2835-1.33.tar.gz
cd bcm2835-1.33
./configure
make
sudo make check
sudo make install

# build the i2c sample code so you can get individual registers
# (required to get any registers large than 0x06)
# a pre-compiled version has been provided in `bin/`
gcc -o bin/i2c-clang-example i2c-clang-example.c -l bcm2835

#run it
bin/i2c-clang-example -dp -s29 -r13 1  # read the WHOAMI register

# Running ...
# Clock divider set to: 148
# len set to: 1
# Slave address set to: 29
# Read Partial: d
# Read Result = 0
#
# Read Buf[0] = 2a
# ... done!

# the expected 0x2A is output!
```

When reading sequential registers from the accelerometer, you need to check the datasheet to see what the "auto-increment address" is for your given register.  For example the AIR for 0x06 (`OUT_Z_LSB`) is 0x00.  This means that if you try to read squentiall 0x05 to 0x08, you'll actually get 0x05, 0x06, 0x00, 0x01. (ed. That may not be right.  It may be that you can't read more than eight consecutive registers becuase of repeated start.)


## Putting the accelerometer into active mode:
```
sudo ./bin/i2c-clang-example -dw -s29 2 0x2A 0x01
```
`0x2A` stores the active state (along with a few other things).  We need to set bit 0 to 1 to active the accelerometers.  Write commands are issued as address, value pairs (`0x2A 0x01` in this case).  *Now when we read from registers 1~6 their values actually change!*

## Turning bits into engineering units
```bash
cd reader-js
coffee -c *.coffee ; node simple-logger

# [  -0.05862237420615535 ,  0.04592085979482169 ,  0.9770395701025891  ] -  0.9798732722490773
# [  -0.061553492916463115 ,  0.0537371763556424 ,  0.9789936492427943  ] -  0.9823976190273559
# [  -0.05959941377625794 ,  0.04787493893502687 ,  0.970200293111871  ] -  0.9732074335180894
# [  -0.0625305324865657 ,  0.051783097215437224 ,  0.981924767953102  ] -  0.9852754978025334

# x, y, z and the pythagorean distance.
```
The included `simple-logger.coffee` file reads the accelerometer data into a buffer of bytes.  The MMA8452Q uses 12 bit values for acceleration, but node works in byte sized units (har, har ;-).  Since the accelerometer puts the always-zero four bits in the right most word of the LSB, if we read the two bytes as a 16 bit number it will be 10 times too large.  To account for this `simple-logger.coffee` shifts the 16 bit buffer by 4 bits, dropping the zeros off the LSB side and pushing them on to the MSB side.  Javascript's `>>` bitwise operator respects the sign bit.
