MMA8452Q      = require "./MMA8452Q"
accelerometer = new MMA8452Q

read = ()->
  accelerometer.read (err, values)->
    [realX, realY, realZ] = values
    console.log "[ ",
        realX, ", ",
        realY, ", ",
        realZ, " ] - ",
        Math.sqrt(Math.pow(realX,2) + Math.pow(realY,2) + Math.pow(realZ,2))

setInterval read, 100
