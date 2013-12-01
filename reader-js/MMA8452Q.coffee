class MMA8452Q
  constructor: ()->

  i2c     = require "i2c"
  address = 0x1D
  device  = "/dev/i2c-1"
  wire    = new i2c(address, {device: device})

  # Put the MMA8452Q into "active" mode
  # *Doesn't work, use the included c-lang example in `bin/`*
  # activateAddress = 0x2A
  # activateValue   = 0x01
  # wire.writeBytes activateAddress, [activateValue], (err)->
  #   console.log err if err

  fullscale_eng   = 2     # unit: g
  fullscale_bits  = 2047  # 12 bits / 2
  shiftBits       = 4     # the right most 4 bits are always 0, and need to go away
  calFactor       = fullscale_eng / fullscale_bits

  shiftedBuffer = (buffer)->
    shifted = new Buffer(2)
    shifted.writeInt16BE (buffer.readInt16BE(0) >> shiftBits), 0
    shifted

  buffToEng = (buffer)->
    buffer.readInt16BE(0) * calFactor

  command = 0x00
  length  = 8
  read: (callback)->
    wire.readBytes command, length, (err, res)->
      xBuffRaw = res.slice(1, 3)
      yBuffRaw = res.slice(3, 5)
      zBuffRaw = res.slice(5, 7)

      xBuff = shiftedBuffer(xBuffRaw)
      yBuff = shiftedBuffer(yBuffRaw)
      zBuff = shiftedBuffer(zBuffRaw)

      realX = buffToEng(xBuff)
      realY = buffToEng(yBuff)
      realZ = buffToEng(zBuff)

      # console.log xBuffRaw, yBuffRaw, zBuffRaw
      # console.log xBuff, yBuff, zBuff
      # console.log [realX, realY, realZ]
      callback err, [realX, realY, realZ]

module.exports = MMA8452Q
