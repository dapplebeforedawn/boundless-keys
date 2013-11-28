
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
mark@raspberrypi ~ $ i2cdetect -y 1
0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --
# yay! the i2c address table. (nothing is currently connected)
```
