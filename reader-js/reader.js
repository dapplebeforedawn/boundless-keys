// Generated by CoffeeScript 1.6.1
(function() {
  var address, buffToEng, calFactor, command, device, fullscale_bits, fullscale_eng, i2c, length, read, shiftBits, shiftedBuffer, wire;

  i2c = require("i2c");

  address = 0x1D;

  device = "/dev/i2c-1";

  wire = new i2c(address, {
    device: device
  });

  fullscale_eng = 2;

  fullscale_bits = 2047;

  shiftBits = 4;

  calFactor = fullscale_eng / fullscale_bits;

  shiftedBuffer = function(buffer) {
    var shifted;
    shifted = new Buffer(2);
    shifted.writeInt16BE(buffer.readInt16BE(0) >> shiftBits, 0);
    return shifted;
  };

  buffToEng = function(buffer) {
    return buffer.readInt16BE(0) * calFactor;
  };

  command = 0x00;

  length = 8;

  read = function() {
    return wire.readBytes(command, length, function(err, res) {
      var realX, realY, realZ, xBuff, xBuffRaw, yBuff, yBuffRaw, zBuff, zBuffRaw;
      xBuffRaw = res.slice(1, 3);
      yBuffRaw = res.slice(3, 5);
      zBuffRaw = res.slice(5, 7);
      xBuff = shiftedBuffer(xBuffRaw);
      yBuff = shiftedBuffer(yBuffRaw);
      zBuff = shiftedBuffer(zBuffRaw);
      realX = buffToEng(xBuff);
      realY = buffToEng(yBuff);
      realZ = buffToEng(zBuff);
      return console.log("[ ", realX, ", ", realY, ", ", realZ, " ] - ", Math.sqrt(Math.pow(realX, 2) + Math.pow(realY, 2) + Math.pow(realZ, 2)));
    });
  };

  setInterval(read, 100);

}).call(this);