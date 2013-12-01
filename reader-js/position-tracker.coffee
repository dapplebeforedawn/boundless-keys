MMA8452Q      = require "./MMA8452Q"
accelerometer = new MMA8452Q
previousValue = [0, 0, 0, 0]

# call read n times and average to get a stable
# zero point
nTimes = 30
initPrevious = (times, afterInit)->
  return afterInit() unless times

  computeNext = (values)->
    [x, y, z, stamp] = values
    [pX, pY, pZ]     = previousValue
    previousValue    = [pX+x/nTimes, pY+y/nTimes, pZ+z/nTimes, stamp]

  accelerometer.read (err, values)->
    computeNext(values)
    initPrevious(times - 1, afterInit)

afterInit = ()->
  console.log previousValue

initPrevious(nTimes, afterInit)

# read = ()->
#   accelerometer.read (err, values)->
#     [realX, realY, realZ, stamp] = values
#
# setInterval read, 50

#for each frame calculate the position delta
#x(t) = x(0) + v(0)*t + 1/2*a*t^2
#
# each frame calculates and saves a position and velocity, and timestamp
# new frames are calculated with an acceleration, a timestamp and the t-1 frame.
# all frames have access to the innertial reference
