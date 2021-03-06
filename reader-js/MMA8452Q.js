// Generated by CoffeeScript 1.6.1
(function() {
  var MMA8452Q;

  MMA8452Q = (function() {
    var address, buffToEng, calFactor, command, device, fullscale_bits, fullscale_eng, i2c, length, shiftBits, shiftedBuffer, wire;

    function MMA8452Q() {}

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

    MMA8452Q.prototype.read = function(callback) {
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
        return callback(err, [realX, realY, realZ, Date.now()]);
      });
    };

    return MMA8452Q;

  })();

  module.exports = MMA8452Q;

}).call(this);
